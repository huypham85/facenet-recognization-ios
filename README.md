# Class Attendance App

## Project Overview

This project involves the development of a student attendance management system for iOS devices. The system leverages the FaceNet facial recognition model and Bluetooth Low Energy (BLE) technology to ensure efficient, secure, and reliable attendance tracking.

## Features

- **Facial Recognition**: Utilizes the FaceNet model for accurate facial identification.
- **Bluetooth Low Energy (BLE)**: Ensures students are within close proximity to the teacher's device for attendance check-in.
- **iOS Application**: User-friendly app for both students and teachers to manage attendance.
- **Admin Web Interface**: Web platform for admin to manage classes, users, and approve face registration requests.

## Key Technologies

- **FaceNet**: Facial recognition model developed by Google.
- **BLE (Bluetooth Low Energy)**: Ensures proximity between devices for attendance check-in.
- **Firebase**: Backend services for real-time database, authentication, and storage.
- **iOS Development**: UIKit, Swift.
- **Machine Learning**: Pre-trained model for facial recognition.

## Key Achievements

- **High Accuracy**: The system identifies students with approximately 95% accuracy.
- **Fast Processing**: Attendance check-in takes around 0.25 seconds per student.
- **Flexible Check-In**: Students can check in via their own devices, increasing convenience and reducing the need for a fixed check-in device.

## How to Use

1. **Register**: Students and teachers need to register and get approval for their facial data.
2. **Check-In**: Students can check in to their classes by simply being in close proximity to the teacher's device and having their face recognized by the app.

## Setup and Installation

### Prerequisites

- **Xcode**: Version 11 or later.
- **Swift**: Version 5.1 or later.
- **Cocoapods**: To manage dependencies.

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/class-attendance-app.git
   cd class-attendance-app
   ```

2. **Install dependencies**:
   ```bash
   pod install
   ```

3. **Open the project in Xcode**:
   ```bash
   open ClassAttendanceApp.xcworkspace
   ```

4. **Build and run the project**:
   Select your target device or simulator and press `Cmd + R` to build and run the project.

## Usage

1. **Register and Login**:
   - Open the app and register as a student or teacher.
   - Admin will approve the registration request.

2. **Face Registration**:
   - Take a clear picture of your face for recognition.
   - Admin will approve the face registration.

3. **Attendance Check-In**:
   - Open the app and ensure you are close to the teacher’s device.
   - The app will automatically recognize your face and mark your attendance.

## Architecture

### iOS App

- **UIKit**: For building the user interface.
- **FaceNet**: For facial recognition.
- **BLE**: For proximity detection.
- **Firebase**: For real-time database, authentication, and storage.

### Admin Web Interface

- **React**: For building the web interface.
- **Firebase**: For backend services.

## Screenshots
![Picture1](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/18840059-399f-48bc-96ec-eaf9425f781e)
![Picture2](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/a4fbb52f-e152-4405-9ca4-3b193cef6d93)
![Picture3](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/f29d12a8-2629-4ef2-8d13-c978617b6453)
![Picture4](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/f1a496d7-70e0-4ad5-a5ca-c654a9400683)
![Picture5](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/aebe08db-4780-4220-bcb9-b717a23a9b1f)
![Picture6](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/f0dd74bf-cb2d-4fbe-b77f-baef1d5a35f6)
![Picture7](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/8c4c8265-195a-4b7b-9b97-82ce500a85ec)
![Picture8](https://github.com/huypham85/facenet-recognization-ios/assets/64804929/f5cb77a8-b101-4587-90a9-81a29d81e90c)

## Contribution

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-branch
   ```
3. Make your changes and commit them:
   ```bash
   git commit -m "Description of your changes"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-branch
   ```
5. Create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

Special thanks to all contributors and the developer community for their valuable feedback and contributions.
