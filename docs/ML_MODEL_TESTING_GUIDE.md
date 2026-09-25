# ShilpSetu ML Models Testing Guide

Comprehensive testing procedure for all Machine Learning (ML) and Artificial Intelligence (AI) models integrated into **ShilpSetu**, spanning **On-Device Edge ML** and **Cloud Multi-Modal AI Backend** (hosted at `https://snowiness-pushup-brewing.ngrok-free.dev`).

---

## 🏛️ ML Architecture Overview

```
                               ┌───────────────────────────────────────────────────────────┐
                               │                    SHILPSETU APPLICATION                  │
                               └─────────────────────────────┬─────────────────────────────┘
                                                             │
                    ┌────────────────────────────────────────┴────────────────────────────────────────┐
                    ▼                                                                                 ▼
     ┌──────────────────────────────┐                                                 ┌──────────────────────────────┐
     │    ON-DEVICE EDGE ML         │                                                 │    CLOUD AI & ML BACKEND     │
     │    (Flutter / TFLite / Isolate)                                                │    (FastAPI / ngrok tunnel)  │
     ├──────────────────────────────┤                                                 ├──────────────────────────────┤
     │ • Pre-shutter Quality Gate   │                                                 │ • Voice ASR & Transcription  │
     │ • U-2-Net Edge Segmenter     │                                                 │ • Multi-Modal AI Cataloger   │
     │ • Auto-White-Balance & Color │                                                 │ • RMBG Image Studio Enhancer │
     │ • Isolate Thread Isolation   │                                                 │ • Fair Wage Pricing Engine   │
     └──────────────────────────────┘                                                 │ • Semantic Vector Search     │
                                                                                      │ • GI Tag Craft Classifier    │
                                                                                      └──────────────────────────────┘
```

---

## 🧪 Layer 1: On-Device Edge ML Testing (Flutter)

These tests run on the local development machine using Flutter's test runner to verify edge models, latency budgets, and isolate execution.

### 1. Run All ML Test Suites
Open terminal in `apps/mobile`:
```powershell
cd c:\Users\KIIT\Desktop\Projects\shipsetu-final\apps\mobile
& "C:\FLUTTER SDK\flutter\bin\flutter.bat" test test/ml/
```

### 2. What Each Test Verifies:
| Test File | Test Case | Target Metric / Acceptance Criteria |
| :--- | :--- | :--- |
| `quality_gate_test.dart` | Pre-shutter Quality Gate (`quality_gate.dart`) | Rejects frames with Laplacian blur variance `< 100.0` or mean luminance `< 40.0` |
| `image_processor_test.dart` | Segmentation Budget (`segmenter.dart`) | Completes background isolation in **`< 1500 ms`** (ADR-0003 budget) |
| `image_processor_test.dart` | Auto White Balance (`image_processor.dart`) | Balances color casts across R, G, B channels |
| `image_processor_test.dart` | Square Format Resizing | Normalizes arbitrary camera dimensions to 1:1 marketplace square format |

---

## 🌐 Layer 2: Cloud ML Model Testing (ngrok Backend)

> [!IMPORTANT]
> **ngrok Header Requirement**:
> All free-tier ngrok tunnels return an HTML interstitial block screen unless the header `-H "ngrok-skip-browser-warning: true"` is sent with every HTTP request.

### 1. Health & Status Check
Verify that the model server is live and responsive:
```powershell
curl.exe -s -i "https://snowiness-pushup-brewing.ngrok-free.dev/health" -H "ngrok-skip-browser-warning: true"
```
*Expected Output*: `HTTP/1.1 200 OK` with body `{"status":"healthy","version":"1.0.0"}`

---

### 2. Fair Wage & Pricing Engine Model
- **Endpoint**: `POST /api/v1/pricing/suggest`
- **Function**: Calculates minimum fair wage floor, suggested retail price, and stretch targets based on raw material costs and skilled artisan hours.

```powershell
curl.exe -X POST "https://snowiness-pushup-brewing.ngrok-free.dev/api/v1/pricing/suggest" `
  -H "ngrok-skip-browser-warning: true" `
  -H "Content-Type: application/json" `
  -d '{"craft_type": "terracotta", "raw_material_cost": 450, "artisan_hours": 6, "state": "Odisha"}'
```
*Expected Output*:
```json
{
  "price_floor": 1350.0,
  "price_suggested": 1850.0,
  "price_stretch": 2400.0,
  "breakdown": {
    "material_cost": 450.0,
    "labor_cost": 900.0
  }
}
```

---

### 3. Semantic Vector Search Model
- **Endpoint**: `POST /api/v1/search/query`
- **Function**: Uses SentenceTransformer neural embeddings to perform cross-lingual semantic search across craft titles and descriptions.

```powershell
curl.exe -X POST "https://snowiness-pushup-brewing.ngrok-free.dev/api/v1/search/query" `
  -H "ngrok-skip-browser-warning: true" `
  -H "Content-Type: application/json" `
  -d '{"query": "handmade clay festive diya", "top_k": 3}'
```
*Expected Output*: Scored craft items ranked by cosine similarity score (`0.0` - `1.0`).

---

### 4. Voice Cataloger & ASR Model
- **Endpoint**: `POST /api/v1/catalog/voice`
- **Function**: Transcribes spoken regional audio and uses Gemini to extract structured attributes (material, hours, colors) and bilingual descriptions.

```powershell
curl.exe -X POST "https://snowiness-pushup-brewing.ngrok-free.dev/api/v1/catalog/voice" `
  -H "ngrok-skip-browser-warning: true" `
  -F "audio=@path\to\recording.m4a" `
  -F "language_hint=hi"
```
*Expected Output*:
```json
{
  "detected_language": "hi",
  "raw_transcript": "यह हाथ से बना टेराकोटा दीया है...",
  "title_en": "Handmade Terracotta Diya",
  "title_hi": "हाथ से बना टेराकोटा दीया",
  "description_en": "Handmade terracotta diya crafted with natural organic clay...",
  "description_hi": "शुद्ध प्राकृतिक मिट्टी से बना पारम्परिक दीया...",
  "features": ["Pure Terracotta Clay", "Hand Sculpted", "Traditional Diya"],
  "processing_time_ms": 1280
}
```

---

### 5. Studio Image Enhancement Model
- **Endpoint**: `POST /api/v1/image/enhance`
- **Function**: Background isolation, studio white replacement, and resolution upscaling. Rejects blurry images with HTTP 422.

```powershell
curl.exe -X POST "https://snowiness-pushup-brewing.ngrok-free.dev/api/v1/image/enhance" `
  -H "ngrok-skip-browser-warning: true" `
  -F "image=@path\to\craft.jpg"
```
*Expected Output*:
```json
{
  "enhanced_image_url": "/uploads/enhanced/2026/09/sample.webp",
  "quality_score": 0.94,
  "processing_time_ms": 1420
}
```

---

### 6. One-Tap Unified Multi-Modal AI Model
- **Endpoint**: `POST /api/v1/products/create-ai`
- **Function**: Combines image vision model and audio speech model in a single unified inference call.

```powershell
curl.exe -X POST "https://snowiness-pushup-brewing.ngrok-free.dev/api/v1/products/create-ai" `
  -H "ngrok-skip-browser-warning: true" `
  -F "image=@path\to\craft.jpg" `
  -F "audio=@path\to\recording.m4a" `
  -F "artisan_id=artisan_test" `
  -F "language_hint=hi" `
  -F "auto_save=false"
```

---

## 📱 Layer 3: Interactive In-App Testing Checklist

Run the mobile app on a connected Android phone or emulator:
```powershell
cd c:\Users\KIIT\Desktop\Projects\shipsetu-final\apps\mobile
& "C:\FLUTTER SDK\flutter\bin\flutter.bat" run
```

### Test Case Walkthrough:

#### A. Camera Studio Viewfinder (`/capture`)
1. **Blur Rejection Gate**: Point camera at an out-of-focus background. Confirm that the top HUD banner warns **"Too Blurry"** and disables capture.
2. **Backlight Detection Gate**: Point camera towards direct light source. Confirm that the banner warns **"Too Backlit"**.
3. **Capture**: Ensure optimal lighting and focus. Tap the **96dp shutter button**.
4. Confirm image is captured and processed through `ml_isolate.dart`.

#### B. Voice Cataloger (`/cataloger`)
1. Tap the **Giant 96dp Microphone Button**.
2. Speak clearly in any supported language (Hindi, English, Odia, Bengali, Tamil, Telugu, Marathi, Gujarati):
   > *"This terracotta pot was hand sculpted using organic clay over eight hours of work."*
3. Tap the microphone again to stop recording.
4. **Observe**:
   - Status changes to `"Processing your voice note..."` with an hourglass icon.
   - The app calls `POST /api/v1/catalog/voice` on the ngrok backend.
   - Extracted attribute chips appear (e.g. `Pure Terracotta Clay`, `8 Hours Artisan Labor`).
   - The device automatically plays the spoken readback via Text-to-Speech (TTS).

#### C. Fair Wage Pricing Screen (`/pricing`)
1. Tap **"Check Fair Price"**.
2. Confirm the 3 dynamic pricing tiers appear:
   - **Fair Wage Floor**: Absolute minimum price below which artisan will be exploited.
   - **Suggested Market Price**: Optimal fair trade marketplace price.
   - **Stretch Target**: Premium artisan gallery price.
3. Tap the speaker icon to listen to the audio explanation of labor and material breakdown.

#### D. Catalog Feed Screen (`/catalog`)
1. Pull down to refresh.
2. Verify that newly created and published products load directly from the ngrok backend (`GET /api/v1/products/feed`).
3. Verify that product photos load through `CachedNetworkImage` with no ngrok interstitial blocking.
4. Tap the audio button on any card to confirm spoken product title and description readback.

---

## ⚙️ Layer 4: Backend Automated Pytest Suite

Run all backend unit and integration tests:
```powershell
cd c:\Users\KIIT\Desktop\Projects\shipsetu-final\apps\backend
uv run pytest -v
```

---

## 🛠️ Troubleshooting & Debugging

| Symptom | Root Cause | Solution |
| :--- | :--- | :--- |
| **HTTP 422 Unprocessable Entity** | Image rejected by pre-enhancement quality model | Ensure test image is sharp (`variance > 100`) and well lit |
| **HTML received instead of JSON** | Missing ngrok header | Add `-H "ngrok-skip-browser-warning: true"` to request headers |
| **Microphone permission error** | App permissions not granted | Grant audio recording permission when prompted on Android device |
| **TTS audio silent on Android 11+** | System TTS engine package hidden | Verified `<intent><action android:name="android.intent.action.TTS_SERVICE" /></intent>` in `AndroidManifest.xml` |
