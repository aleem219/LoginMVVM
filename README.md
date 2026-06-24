# LoginMVVM

## A reference implementation for performing REST API calls — GET and POST — within a UIKit application, following MVVM architecture.

## Overview

LoginMVVM demonstrates a clean separation of concerns using the MVVM (Model-View-ViewModel) design pattern in a UIKit-based iOS app. It includes a complete authentication flow with API-backed login, reusable custom UI components, and a modular project structure.

## Features

🔐 Authentication — Login flow backed by REST API calls (GET/POST)

🧩 MVVM Architecture — Clear separation between View, ViewModel, and Model layers

🎨 Reusable Components — Custom DesignableButton, DesignableView, and reusable AlertView popup

📸 Image Picker — Upload and preview profile images with size validation

🌐 Networking Layer — Centralized API/service handling via ServiceController

🧱 Extensions — Common UIButton, UITextField, UIView, and UIViewController extensions for shared functionality


## Test Credentials

For testing purposes, use the following sample login credentials:

Username: emilys

Password: emilyspass

## Project Structure

LoginMVVM/
├── CommonModule/
│   ├── Alert/              # Reusable AlertView component
│   ├── AlertController/
│   ├── navigation/
│   ├── UIButton+Extension/
│   ├── UITextField+Extension/
│   ├── UIView+Extension/
│   └── UIViewcontroller+Extension/
├── Constants/
├── Delegates/
├── FeaturedModule/
│   └── Login/               # Login screen (View, ViewModel, ViewController)
├── Helper/
├── Networking/
├── Resources/
├── ServiceController/
└── Storyboard/

## Requirements

Xcode 15+

iOS 16+

Swift 5+


## Installation

Clone the repository

bash   git clone https://github.com/aleem219/LoginMVVM.git


Open LoginMVVM.xcodeproj in Xcode

Build and run on a simulator or device


## Dependencies


ProgressHUD — for loading indicators

## Screenshot

<img width="1170" height="2532" alt="Simulator Screenshot - iPhone 16e - 2026-06-24 at 19 52 43" src="https://github.com/user-attachments/assets/9b0d15cf-a700-48ed-863f-d7bede054b52" />
