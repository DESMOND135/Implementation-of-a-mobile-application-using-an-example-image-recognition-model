# Implementation of a Mobile Application Using an Example Image Recognition Model

## About the Project
I developed this cross-platform mobile application using **Flutter** to demonstrate the integration of machine learning models into mobile environments. The application allows users to select images from their gallery and performs real-time image recognition using a pre-trained **TensorFlow Lite** model.

## Features
- **Image Recognition**: Classifies objects within images using the MobileNet V1 model.
- **Gallery Integration**: Seamlessly pick images from the device gallery for classification.
- **High Performance**: Optimized for mobile devices with an edge-computing approach (processing happens on-device).
- **Minimalist UI**: A clean, distraction-free interface developed for ease of use.

## Technical Details
- **Frontend**: Flutter & Dart
- **AI Model**: MobileNet V1 (Quantized TFLite)
- **Key Libraries**:
    - `tflite_flutter`: For model inference.
    - `image_picker`: For handling media selection.
    - `image`: For pre-processing and resizing image data (224x224).

## How to Run
I have structured this project for easy deployment. Follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/DESMOND135/Implementation-of-a-mobile-application-using-an-example-image-recognition-model.git
   ```
2. **Navigate to the project directory**:
   ```bash
   cd image_recognition_app
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Launch the application**:
   ```bash
   flutter run
   ```

## Developer
Developed by **Desmond**.
