# 🍅 Tomalyze

Aplikasi mobile untuk menganalisis kematangan tomat menggunakan **Machine Learning**.

## 📱 Tentang Aplikasi

Tomalyze adalah aplikasi berbasis Flutter yang membantu petani dan pengusaha tomat untuk mendeteksi tingkat kematangan tomat secara otomatis melalui foto. Aplikasi ini menggunakan teknologi Computer Vision dan Machine Learning untuk memberikan hasil analisis yang akurat.

### Fitur Utama
- 🔐 **Login dengan Google** - Autentikasi mudah dan aman
- 📷 **Upload Foto Tomat** - Ambil foto langsung atau pilih dari galeri
- 🤖 **Analisis ML** - Prediksi kematangan menggunakan model SVM dan KNN
- 📊 **Hasil Akurat** - Tampilan hasil dengan tingkat keyakinan (confidence score)
- 🎨 **UI Modern** - Desain clean dengan font Montserrat

## 🛠️ Teknologi

### Frontend (Mobile App)
- **Flutter 3.9.2** - Framework cross-platform
- **Firebase Auth** - Autentikasi Google Sign-In
- **Provider** - State management
- **HTTP** - Komunikasi dengan backend
- **Image Picker** - Upload foto dari kamera/galeri

### Backend (ML Service)
- **Python FastAPI** - REST API server
- **scikit-learn** - Model SVM dan KNN
- **OpenCV** - Image processing dan segmentasi
- **NumPy** - Komputasi numerik

## 📂 Struktur Project

```
tomalyze/
├── lib/
│   ├── core/
│   │   ├── constants/        # Konfigurasi (API URL, dll)
│   │   ├── models/           # Model data
│   │   ├── providers/        # State management
│   │   └── services/         # HTTP services
│   └── presentation/
│       ├── views/            # Halaman-halaman UI
│       └── widgets/          # Komponen UI reusable
├── python_backend/
│   ├── ml_models/            # File model ML (.pkl)
│   ├── main.py               # FastAPI server
│   └── requirements.txt      # Dependencies Python
└── assets/                   # Icon & fonts

```

## 🚀 Cara Menjalankan

### 1. Backend (Python)
```bash
cd python_backend
pip install -r requirements.txt
python main.py
```
Backend akan jalan di `http://localhost:8000`

### 2. Frontend (Flutter)
```bash
flutter pub get
flutter run
```

**Catatan:**
- Untuk Android emulator, backend URL sudah dikonfigurasi ke `http://10.0.2.2:8000`
- Untuk device fisik, ubah URL di `lib/core/constants/api_constants.dart` sesuai IP komputer Anda

## 📖 Cara Pakai

1. **Login** menggunakan akun Google
2. Di halaman utama, klik tombol hijau **"Analisis Backend (ML)"**
3. **Pilih foto** tomat dari kamera atau galeri
4. Klik salah satu tombol analisis:
   - **Analisis (SVM)** - Prediksi dengan model SVM
   - **Analisis (KNN)** - Prediksi dengan model KNN
   - **Analisis (Both)** - Prediksi dengan kedua model
5. Tunggu beberapa detik, hasil akan muncul:
   - **Matang** atau **Belum Matang**
   - Confidence score (tingkat keyakinan)

## 🔧 Konfigurasi

### Firebase Setup
1. Download `google-services.json` dari Firebase Console
2. Letakkan di `android/app/`
3. Update `firebase_options.dart` jika diperlukan

### Backend URL
Edit `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:8000'; // Untuk emulator
// static const String baseUrl = 'http://192.168.x.x:8000'; // Untuk device fisik
```

## 📦 Dependencies Utama

**Flutter:**
- `firebase_auth` - Autentikasi
- `google_sign_in` - Google login
- `provider` - State management
- `http` - REST API client
- `image_picker` - Pilih gambar

**Python:**
- `fastapi` - Web framework
- `scikit-learn` - Machine learning
- `opencv-python` - Image processing
- `uvicorn` - ASGI server

## 👥 Tim Pengembang

Project ini dikembangkan sebagai bagian dari tugas Pemrograman Mobile.

## 📄 Lisensi

Project ini dibuat untuk keperluan edukasi.
