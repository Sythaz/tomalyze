
# Tomalyze: Tomato Maturity Classification 🍅✨

Tomalyze is a cross-platform Flutter application with a FastAPI (Python) backend that performs image segmentation, feature extraction, and model inference using pre-trained SVM and KNN models. This project was developed as a university final project (5th semester) for courses such as Machine Learning, Image Processing & Computer Vision, and Mobile Development. 😄

---

## Table of Contents

- Overview
- Features
- Tech Stack
- Architecture
- Project Structure
- Quick Start
  - Backend (FastAPI)
  - Frontend (Flutter)
- Backend API Reference

---

## Overview 🎯

Tomalyze detects tomato maturity stages: Unripe, Half-ripe, and Ripe. The backend performs image segmentation, feature extraction, scaling, and inference with pre-trained models. The Flutter frontend provides a simple UI to capture or upload images and display predictions. This project is educational in purpose and designed to be approachable and easy to modify for learning and experimentation.

---

## Features 🚀

- Image segmentation (GrabCut)
- Feature extraction (9 features: mean RGB, circular hue stats, saturation, LAB a*, etc.)
- Two models: SVM and KNN
- Clean and Simple Flutter UI for scanning and uploading images
- Swagger UI and REST API for direct model inference

---

## Tech Stack 💻

- Flutter / Dart (Frontend)
- Python / FastAPI (Backend)
- OpenCV, NumPy, scikit-learn (Model & preprocessing)
- Uvicorn (ASGI server)

---

## Architecture 🧩

The Flutter app uploads an image to the backend (using multipart/form-data). The backend segments tomato region, extracts features, scales them, and performs inference using SVM/KNN. The response contains predictions and probabilities. 🔥

---

## Project Structure 📂

```
tomalyze/
├── android/                    # Native Android project
├── ios/                        # Native iOS project
├── lib/                        # Flutter app source
├── python_backend/             # FastAPI inference server
│   ├── main.py                 # Entry point
│   ├── requirements.txt
│   └── ml_models/              # scaler.pkl, svm_model.pkl, knn_model.pkl
├── pubspec.yaml                # Flutter dependencies
└── README.md                   # Project documentation
```

---

## Quick Start / How to Run⚡

### Prerequisites

- Flutter SDK
- Android Studio (or Xcode for iOS)
- Python 3.8+ (3.10 recommended)
- pip

### Backend — Setup & Run (FastAPI)

1. Move into the python backend directory:

```bash
cd python_backend
```

2. Create and activate a virtual environment (recommended).

Windows (PowerShell):

```powershell
python -m venv venv
venv\Scripts\Activate
```

macOS / Linux:

```bash
python3 -m venv venv
source venv/bin/activate
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Add trained model files to `python_backend/ml_models` (scaler.pkl, svm_model.pkl, knn_model.pkl).

5. Run the server

```bash
python main.py
```

Server will be available at: http://127.0.0.1:8000 (Swagger at `/docs`)

---

### Frontend — Setup & Run (Flutter)

1. Install Flutter SDK and configure your development environment: https://flutter.dev/docs/get-started/install
2. From project root:

```bash
flutter pub get
```

3. Run the app (Android/iOS/web):

```bash
flutter run
```

4. Build release APK (Android):

```bash
flutter build apk --release
```

5. Build iOS: (macOS + Xcode required)

```bash
flutter build ios --release
```

---

## Backend API Reference

### Endpoints

- `POST /predict-knn`: Predict using `KNN` model.
- `POST /predict-svm`: Predict using `SVM` model.
- `POST /predict-all` : Run both models and return predictions.

All expect `multipart/form-data` with `file` (image) field.

### Swagger UI

Open: http://127.0.0.1:8000/docs — you can test endpoints directly here.

### Example cURL

```bash
curl -X POST "http://127.0.0.1:8000/predict-all" -F "file=@/path/to/tomato.jpg"
```

### Example Response

```json
{
  "filename": "tomato.jpg",
  "svm_prediction": "ripe",
  "svm_prob": [0.1, 0.2, 0.7],
  "knn_prediction": "ripe",
  "knn_prob": [0.05, 0.15, 0.80]
}
```