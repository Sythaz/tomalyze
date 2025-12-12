from fastapi import FastAPI, UploadFile, File, HTTPException
import uvicorn
import numpy as np
import pickle
import cv2

app = FastAPI(
    title="Tomato Maturity API",
    description="Backend inference dengan pipeline 100 persen sama dengan notebook"
)

models = {}


# -------------------------------------------------------
# LOAD MODEL DAN SCALER
# -------------------------------------------------------
@app.on_event("startup")
def load_models():
    try:
        with open("ml_models/scaler.pkl", "rb") as f:
            models["scaler"] = pickle.load(f)
        with open("ml_models/svm_model.pkl", "rb") as f:
            models["svm"] = pickle.load(f)
        with open("ml_models/knn_model.pkl", "rb") as f:
            models["knn"] = pickle.load(f)

        print("Model loaded")
    except Exception as e:
        print("Load error:", e)


# 1. auto_segment_grabcut
def auto_segment_grabcut(img_bgr):

    # --- A. INITIAL BOUNDING BOX ---
    hsv = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2HSV)
    lower = np.array([0, 40, 50])
    upper = np.array([180, 255, 255])
    mask_rough = cv2.inRange(hsv, lower, upper)

    contours, _ = cv2.findContours(mask_rough, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    if not contours:
        return None, None, None, None

    c = max(contours, key=cv2.contourArea)
    x, y, w, h = cv2.boundingRect(c)

    # Padding biar tomat tidak kegunting
    pad = 10
    h_img, w_img = img_bgr.shape[:2]
    x = max(0, x - pad); y = max(0, y - pad)
    w = min(w_img - x, w + 2*pad); h = min(h_img - y, h + 2*pad)
    rect = (x, y, w, h)

    # --- B. GRABCUT ---
    mask = np.zeros(img_bgr.shape[:2], np.uint8)
    bgdModel = np.zeros((1, 65), np.float64)
    fgdModel = np.zeros((1, 65), np.float64)

    cv2.grabCut(img_bgr, mask, rect, bgdModel, fgdModel, 5, cv2.GC_INIT_WITH_RECT)

    # Mask final GrabCut
    mask_final = np.where((mask == 0) | (mask == 2), 0, 1).astype('uint8')
    mask_final = mask_final * 255

    # --- Hasil segmentasi (gabungan/filter final) ---
    segmented = cv2.bitwise_and(img_bgr, img_bgr, mask=mask_final)

    # --- Cari area non-zero dari mask untuk bounding box ---
    coords = cv2.findNonZero(mask_final)

    if coords is not None:
        x, y, w, h = cv2.boundingRect(coords)

        # Crop dari gambar hasil segmentasi
        crop_img = segmented[y:y+h, x:x+w]
    else:
        crop_img = None
        crop_mask = None

    return img_bgr, mask_final, segmented, crop_img


# 2. extract_features
def extract_features(img_bgr):
    # Copy gambar agar tidak memodifikasi input asli
    img_crop = img_bgr.copy()

    # Mask biner: True jika pixel bukan background hitam (0,0,0)
    # Digunakan untuk mengambil hanya area tomat
    mask_bin = np.any(img_crop != 0, axis=2)   
    
    # Konversi warna ke HSV, RGB, dan LAB
    hsv_crop = cv2.cvtColor(img_crop, cv2.COLOR_BGR2HSV)
    img_rgb  = cv2.cvtColor(img_crop, cv2.COLOR_BGR2RGB) 
    img_lab  = cv2.cvtColor(img_crop, cv2.COLOR_BGR2LAB)    

    # Pisahkan channel RGB, simpan sebagai float32 untuk perhitungan statistik
    R = img_rgb[:,:,0].astype(np.float32) 
    G = img_rgb[:,:,1].astype(np.float32) 
    B = img_rgb[:,:,2].astype(np.float32)    
    
    # OpenCV Hue range 0-180, konversi ke 0-360 (derajat asli)
    H_deg = hsv_crop[:,:,0].astype(np.float32) * 2.0

    # Saturation 0-255, normalisasi ke 0-1
    S = hsv_crop[:,:,1].astype(np.float32) / 255.0

    # LAB channel a* 0-255, geser ke -128 sampai +128
    a = img_lab[:,:,1].astype(np.float32) - 128.0 
    
    # Filter pixel berdasarkan mask tomat (menghilangkan background hitam)
    Rm = R[mask_bin]
    Gm = G[mask_bin]
    Bm = B[mask_bin]
    Hm = H_deg[mask_bin]    
    Sm = S[mask_bin]
    am = a[mask_bin]

    # Konversi Hue ke radian untuk circular statistics
    Hm_rad = np.deg2rad(Hm)

    # Circular Hue Components
    # cos(H) = sumbu X di lingkaran warna, dominansi merah
    # sin(H) = sumbu Y di lingkaran warna, dominansi kuning/hijau
    mean_cos_H = float(np.cos(Hm_rad).mean()) if Hm.size else 0
    mean_sin_H = float(np.sin(Hm_rad).mean()) if Hm.size else 0

    # Panjang resultant vector → seberapa seragam warna
    R_length = np.sqrt(mean_cos_H**2 + mean_sin_H**2)
    # Circular Standard Deviation (variasi warna)
    circ_std_H = 1.0 - R_length

    # Rataan Saturation (kepekatan warna)
    mean_S = float(Sm.mean()) if Sm.size else 0
    # Rataan LAB a* (hijau → merah)
    mean_a = float(am.mean()) if am.size else 0

    # epsilon untuk cegah pembagian nol
    eps = 1e-6   

    # Normalized Red
    norm_R = float((Rm / (Rm + Gm + Bm + eps)).mean()) if Rm.size else 0
    # Red vs Green Ratio
    rg_ratio = float(((Rm - Gm) / (Rm + Gm + eps)).mean()) if Rm.size else 0
    
    # Mean R dan G (indikator intensitas pigmen)
    mean_R = float(Rm.mean()) if Rm.size else 0
    mean_G = float(Gm.mean()) if Gm.size else 0

    return {
        "mean_cos_H": mean_cos_H,   
        "mean_sin_H": mean_sin_H,   
        "circ_std_H": circ_std_H,         
        "mean_S": mean_S,           
        "mean_a": mean_a,           
        "norm_R": norm_R,           
        "rg_ratio": rg_ratio,       
        "mean_R": mean_R,           
        "mean_G": mean_G,           
    }, img_rgb, hsv_crop, mask_bin

# 3. enhancement atau preprocessing lain
def preprocess_image(img):
    if img is None: return None

    # A. Denoising (Median Blur)
    denoised = cv2.medianBlur(img, 3)

    # B. Morphological Closing (Menutup lubang kecil)
    kernel = np.ones((3,3), np.uint8)
    closing = cv2.morphologyEx(denoised, cv2.MORPH_CLOSE, kernel)

    # C. Smart Resize (Padding) - Agar gambar tidak gepeng
    old_h, old_w = closing.shape[:2]
    target_size = 256

    # Hitung rasio
    ratio = min(target_size / old_h, target_size / old_w)
    new_h, new_w = int(old_h * ratio), int(old_w * ratio)

    # Resize proporsional
    resized = cv2.resize(closing, (new_w, new_h))

    # Tempel ke kanvas hitam 256x256
    final_img = np.zeros((target_size, target_size, 3), dtype=np.uint8)
    y_offset = (target_size - new_h) // 2
    x_offset = (target_size - new_w) // 2
    final_img[y_offset:y_offset+new_h, x_offset:x_offset+new_w] = resized

    return final_img

# 4. urutan fitur ke array sesuai training
def features_dict_to_array(f):
    return np.array([[
        f["mean_cos_H"],
        f["mean_sin_H"],
        f["circ_std_H"],
        f["mean_S"],
        f["mean_a"],
        f["norm_R"],
        f["rg_ratio"],
        f["mean_R"],
        f["mean_G"]
    ]])

@app.post("/predict-knn")
async def predict_knn(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        arr = np.frombuffer(contents, np.uint8)
        img_bgr = cv2.imdecode(arr, cv2.IMREAD_COLOR)

        if img_bgr is None:
            raise HTTPException(400, "File tidak valid")

        # Segmentasi
        ori, mask, seg, crop = auto_segment_grabcut(img_bgr)
        if crop is None:
            raise HTTPException(400, "Segmentasi gagal; tomat tidak ditemukan")

        # Ekstraksi fitur
        features_dict, _, _, _ = extract_features(crop)
        fitur_array = features_dict_to_array(features_dict)

        # Scaling
        fitur_scaled = models["scaler"].transform(fitur_array)

        # KNN Predict
        knn = models["knn"]
        pred_knn = knn.predict(fitur_scaled)[0]

        try:
            proba_knn = knn.predict_proba(fitur_scaled)[0].tolist()
        except:
            proba_knn = None

        return {
            "filename": file.filename,
            "prediction_model": "KNN",
            "prediction": pred_knn,
            "probability": proba_knn,
        }

    except Exception as e:
        raise HTTPException(500, str(e))

@app.post("/predict-svm")
async def predict_svm(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        arr = np.frombuffer(contents, np.uint8)
        img_bgr = cv2.imdecode(arr, cv2.IMREAD_COLOR)

        if img_bgr is None:
            raise HTTPException(400, "File tidak valid")

        # Segmentasi
        ori, mask, seg, crop = auto_segment_grabcut(img_bgr)
        if crop is None:
            raise HTTPException(400, "Segmentasi gagal; tomat tidak ditemukan")

        # Ekstraksi fitur
        features_dict, _, _, _ = extract_features(crop)
        fitur_array = features_dict_to_array(features_dict)

        # Scaling
        fitur_scaled = models["scaler"].transform(fitur_array)

        # SVM Predict
        svm = models["svm"]
        pred_svm = svm.predict(fitur_scaled)[0]

        try:
            proba_svm = svm.predict_proba(fitur_scaled)[0].tolist()
        except:
            proba_svm = None

        return {
            "filename": file.filename,
            "prediction_model": "SVM",
            "prediction": pred_svm,
            "probability": proba_svm,
        }

    except Exception as e:
        raise HTTPException(500, str(e))


# -------------------------------------------------------
# ENDPOINT PREDICT
# -------------------------------------------------------
@app.post("/predict-all")
async def predict(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        arr = np.frombuffer(contents, np.uint8)
        img_bgr = cv2.imdecode(arr, cv2.IMREAD_COLOR)

        if img_bgr is None:
            raise HTTPException(400, "File tidak valid")

        # ----- SEGMENTASI -----
        ori, mask, seg, crop = auto_segment_grabcut(img_bgr)

        if crop is None:
            raise HTTPException(400, "Segmentasi gagal; tomat tidak ditemukan")

        # ----- EKSTRAKSI FITUR -----
        features_dict, _, _, _ = extract_features(crop)

        # ----- URUTAN FITUR -----
        fitur_array = features_dict_to_array(features_dict)

        # ----- SCALING -----
        fitur_scaled = models["scaler"].transform(fitur_array)

        # ----- PREDIKSI KNN DAN SVM -----
        svm = models["svm"]
        knn = models["knn"]

        pred_svm = svm.predict(fitur_scaled)[0]
        pred_knn = knn.predict(fitur_scaled)[0]

        try:
            proba_svm = svm.predict_proba(fitur_scaled)[0].tolist()
        except:
            proba_svm = None

        try:
            proba_knn = knn.predict_proba(fitur_scaled)[0].tolist()
        except:
            proba_knn = None

        return {
            "filename": file.filename,
            "svm_prediction": pred_svm,
            "svm_prob": proba_svm,
            "knn_prediction": pred_knn,
            "knn_prob": proba_knn
        }

    except Exception as e:
        raise HTTPException(500, str(e))

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
