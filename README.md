# 🧠 Migraine Prediction App – Flutter Frontend for Thesis Project

This is the official Flutter-based mobile front-end for the thesis titled:  
**"Random Forest Classification for Migraine Prediction with Flutter-Based Mobile Visualization of Behavioral Triggers"**  
by Marcel Molnár & Efthimis Kalpasidis, supervised by Patrik Granlöv and Hemant Ghayvat (Spring 2025, LNU).

---

## 🎯 Project Overview

This project explores how machine learning and mobile app design can be combined to empower migraine sufferers with personalized insights.

Using the **mBrain21 dataset**, a **Random Forest classifier** predicts migraine occurrence based on self-reported behavioral data (e.g., sleep, stress, physical activity).  
The predictions and key patterns are visualized in a cross-platform **Flutter** app to support user reflection and education.

---

## 📲 App Features

- Upload/view historical self-logged data
- View **daily migraine risk prediction**
- Visualize changes in stress, sleep, and activity
- Tap on graph points to view behavioral data (e.g., missed meals, poor sleep)
- Interactive charts using `fl_chart` library

---

## 🧪 Machine Learning

- **Model**: Random Forest Classifier
- **Features**: Lagged variables, 3-day averages, day-to-day changes, flags (e.g., poor sleep, missed meals)
- **Handling Class Imbalance**: SMOTE + balanced class weights
- **Performance**:
  - AUC: 0.519
  - F1-score: 0.472
  - High recall (77%), but many false positives

> See thesis PDF for full analysis.

---

## 🔧 Setup Instructions

### Requirements

- Flutter SDK (v3.x recommended)
- Dart
- Visual Studio Code (recommended IDE)

### Steps

```bash
git clone https://github.com/Effe10/thesis_flutter.git
cd thesis_flutter
flutter pub get
flutter run
