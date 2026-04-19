# PowerOCR

> **AI-powered OCR & QR code utility for iOS** — scan documents, extract text with bounding boxes, generate custom QR codes, and export to PDF — all in a polished dark/light Material 3 UI.

[![Flutter](https://img.shields.io/badge/Flutter-3.38.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)](https://dart.dev)
[![iOS](https://img.shields.io/badge/iOS-16%2B-black?logo=apple)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-Proprietary-red)](LICENSE)
[![CI](https://github.com/your-org/PowerOCR/actions/workflows/ios_deployment.yml/badge.svg)](https://github.com/your-org/PowerOCR/actions)

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Directory Structure](#directory-structure)
- [Data Flow](#data-flow)
- [Database Schema](#database-schema)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Running the App](#running-the-app)
- [CI/CD & Deployment](#cicd--deployment)
- [Localization](#localization)
- [Monetization](#monetization)
- [Troubleshooting](#troubleshooting)

---

## Overview

**PowerOCR** là ứng dụng iOS viết bằng Flutter, cho phép người dùng:

- **Quét văn bản** từ camera hoặc thư viện ảnh bằng Google ML Kit (offline) hoặc Google Vision API (online, độ chính xác cao hơn).
- **Quét QR / Barcode** tự động theo thời gian thực từ camera.
- **Quét theo lô (Batch Scan)** nhiều trang rồi xuất thành một file PDF duy nhất.
- **Tạo QR code** tùy chỉnh với màu sắc, hình dạng mắt và module, lưu vào thư viện và chia sẻ.
- **Xem lịch sử** toàn bộ lần quét trước với ảnh thumbnail, văn bản, bounding boxes.

---

## Key Features

| # | Tính năng | Mô tả |
|---|-----------|-------|
| 1 | **Dual-engine OCR** | ML Kit (offline) + Google Vision API (online) — tự động fallback nếu offline |
| 2 | **Auto QR Detection** | Phát hiện QR/barcode tự động từ camera frames qua `compute` isolate |
| 3 | **Batch Scan → PDF** | Chụp nhiều trang, xem grid preview, xuất thành PDF có thể chia sẻ |
| 4 | **Bounding Box Overlay** | Hiển thị khung highlight từng text block lên ảnh (toggle on/off) |
| 5 | **Visual Layout Mode** | Tái tạo bố cục gốc với căn chỉnh cột từ bounding box coordinates |
| 6 | **QR Generator** | Tạo QR tùy chỉnh (màu, eyeShape, dataShape), lưu ảnh PNG, chia sẻ |
| 7 | **QR Library** | Thư viện QR đã tạo với chi tiết, copy, share, delete |
| 8 | **Scan History** | Lịch sử quét local với full-text và bounding boxes, persistent qua Hive |
| 9 | **Dark / Light Mode** | Material 3, animated theme switch, persist preference |
| 10 | **Bilingual UI** | Tiếng Việt & English, switch ngay trong Settings |
| 11 | **Tablet Layout** | Responsive layout — side-by-side view trên iPad |
| 12 | **Push Notifications** | Firebase Cloud Messaging tích hợp sẵn |
| 13 | **AdMob** | Banner + Interstitial ads (iOS, debug/release ad units phân tách) |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Dart 3.10.7+ |
| **Framework** | Flutter 3.38.7 |
| **State Management** | flutter_bloc 9 + BLoC/Cubit pattern |
| **Navigation** | go_router 17 |
| **Dependency Injection** | injectable 2.5 + get_it 9 |
| **Local Database** | Hive CE 2.15 (NoSQL, zero-config) |
| **OCR — Offline** | google_mlkit_text_recognition 0.15 |
| **OCR — Online** | Google Cloud Vision API (REST via Retrofit/Dio) |
| **QR Scanning** | google_mlkit_barcode_scanning 0.14 |
| **QR Generation** | pretty_qr_code 3.6 |
| **PDF Export** | pdf 3.12 |
| **Push Notifications** | Firebase Messaging 16 + flutter_local_notifications 21 |
| **Ads** | google_mobile_ads 8 + app_tracking_transparency 2 |
| **Sharing** | share_plus 12 |
| **HTTP Client** | Dio 5 + Retrofit 4 |
| **Image Picker** | camera 0.12 + image_picker 1.1 |
| **Typogaraphy** | Montserrat (full weight range 100–900) |
| **Localization** | flutter_localizations + ARB files (vi, en) |
| **Code Generation** | build_runner, json_serializable, hive_ce_generator, injectable_generator, retrofit_generator |
| **CI/CD** | GitHub Actions + Fastlane → TestFlight / App Store |
| **Environment** | envied (compile-time secure env vars) |

---

## Prerequisites

Cài đặt các công cụ sau trước khi bắt đầu:

| Tool | Version | Install |
|------|---------|---------|
| Flutter | 3.38.7 | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) hoặc `fvm install 3.38.7` |
| FVM (khuyến nghị) | latest | `dart pub global activate fvm` |
| Xcode | 16+ | Mac App Store |
| CocoaPods | 1.16+ | `sudo gem install cocoapods` |
| Ruby | 3.3 | `rbenv install 3.3.0` |
| Bundler | 2+ | `gem install bundler` |
| Firebase CLI | latest | `npm install -g firebase-tools` |


## Contributing

1. Fork repository
2. Tạo branch: `git checkout -b feature/your-feature`
3. Commit: follow [Conventional Commits](https://www.conventionalcommits.org/)
4. Push và tạo Pull Request

---

## License

Proprietary — All rights reserved. © 2025 PowerOCR.