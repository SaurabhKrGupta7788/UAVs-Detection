# UAVs-Detection: Lightweight Drone Detection & Distance-Speed Estimation

> **🏆 Published Research**: Accepted for the *Proceedings of the 4th International Conference on Artificial Intelligence, Computing Technologies, and Internet of Things (AICTA 2026)*, organized by **NIT Silchar, India**.
> **Title**: Lightweight Vision-based Drone Detection and Distance-Speed Estimation Using Monocular Vision.

This repository contains the codebase for identifying Unmanned Aerial Vehicles (UAVs) using lightweight visual models (YOLO variants, CNNs) and subsequently estimating their physical distance and flight speed utilizing purely monocular vision (a single camera sensor).

## Architecture Overview

\\\
Video/Image Input (Monocular Camera)
    │
    ▼
┌───────────────────────────────────────┐
│  Data Preparation & Auto-Labeling     │  ← Multi-modal (RGB + IR) datasets
└──────────┬────────────────────────────┘
           │
           ▼
┌───────────────────────────────────────┐
│  Lightweight Object Detection (YOLO)  │  ← YOLOv12 / Custom CNN Classifier
└──────────┬────────────────────────────┘
           │
    ┌──────┴───────────────┐
    ▼                      ▼
┌──────────────┐ ┌───────────────────┐
│ Bounding Box │ │ Outlier Detection │
│ Extraction   │ │ (Filtering False) │
└──────┬───────┘ └─────────┬─────────┘
       │                   │
       ▼                   ▼
┌───────────────────────────────────────┐
│  Camera Calibration & Pinhole Math    │ ← Converts bounding box pixels to meters
└──────────────┬────────────────────────┘
               ▼
┌───────────────────────────────────────┐
│  Distance & Speed Estimation Module   │ ← Tracks displacement over frame time (dt)
└───────────────────────────────────────┘
\\\

## System Output

The system generates bounding box predictions alongside calculated physical metrics:

| Frame # | Target | Confidence | Distance (meters) | Estimated Speed (m/s) |
|---|---|---|---|---|
| 250 | UAV / Drone | 0.92 | 45.2 | 12.4 |
| 251 | UAV / Drone | 0.94 | 44.8 | 12.0 |

## Directory Structure

\\\
├── README.md                                 # Project documentation
├── auto_label_script.ipynb                   # Automates bounding box generation
├── data_making.ipynb                         # Dataset preprocessing and augmentation
├── export_gt_to_yolo.m                       # MATLAB script for ground truth conversion
│
├── only_drone_classifier.ipynb               # Baseline CNN drone classification
├── only_drone_yolo_RGB.ipynb                 # YOLO detection trained purely on RGB
├── only_drone_yolo_IR.ipynb                  # YOLO detection trained purely on IR
├── only_drone_yolo_lateFusion.ipynb          # Late fusion of RGB and IR modalities
│
├── only_drone_Calibration.ipynb              # Camera matrix and intrinsic parameter calibration
├── only_drone_distance.ipynb                 # Mathematical modeling for Monocular distance/speed
├── outlier_detection.ipynb                   # Statistical filtering of false positive bounding boxes
└── train-yolov12-object-detection-model.ipynb # Core YOLOv12 training pipeline
\\\

## How to Run

### 1. Prerequisites
- Python 3.9+
- Jupyter Notebook / Lab
- OpenCV, PyTorch, Ultralytics (YOLO)
- MATLAB (Optional, for running \export_gt_to_yolo.m\)

### 2. Install Dependencies

\\\ash
# Install deep learning and vision dependencies
pip install torch torchvision ultralytics opencv-python pandas matplotlib jupyter
\\\

### 3. Run the Application
This repository acts as a sequential research pipeline. Execute the notebooks in this order:
1. **Data Prep**: \uto_label_script.ipynb\ and \data_making.ipynb\
2. **Training**: \	rain-yolov12-object-detection-model.ipynb\
3. **Calibration**: \only_drone_Calibration.ipynb\
4. **Estimation**: \only_drone_distance.ipynb\

## Key Design Decisions

1. **Monocular Vision Constraint**: Instead of relying on expensive LiDAR or stereo cameras, this project forces distance estimation out of a single lens using the Pinhole Camera Model and strict intrinsic calibration, drastically reducing hardware cost.
2. **Late Fusion (RGB + IR)**: Drones operate in varying weather/lighting. By providing separate RGB and Infrared (IR) pipelines and fusing them later (\only_drone_yolo_lateFusion.ipynb\), the model robustly detects drones even against noisy backgrounds or night skies.
3. **Lightweight Edge Deployment**: Opting for Nano/Lightweight YOLO variants ensures the architecture can run real-time on edge devices (like a Raspberry Pi or Jetson Nano) deployed in the field.
