# LearnSphere

A Flutter application for personalized learning with roadmap generation, community features, and AI-powered chatbot.

## Features

- User Authentication (Login, Sign Up, Verification)
- Personalized Learning Roadmaps
- Community Discussions
- AI Chatbot for Assistance
- PDF Viewing and File Management
- Speech-to-Text Functionality
- Data Visualization with Charts

## Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Python (Flask)
- **Database:** Firebase Firestore
- **Authentication:** Firebase Auth
- **AI/ML:** Custom models for roadmap generation and chatbot

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Python 3.x
- Firebase project setup

### Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd flutter_application_1
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Set up Firebase:
   - Add your Firebase configuration to `lib/firebase_options.dart`
   - Enable Firestore and Authentication in Firebase Console

4. Set up Backend:
   - Navigate to `lib/Backend/`
   - Install Python dependencies:
     ```bash
     pip install -r requirements.txt
     ```
   - Run the backend server:
     ```bash
     python app.py
     ```

5. Run the Flutter app:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/`: Flutter application code
  - `AuthenticationScreens/`: Login, Sign Up, Verification
  - `Screens/`: Main app screens (Home, Roadmap, Chat, Community)
  - `Services/`: API services and utilities
  - `Backend/`: Python backend scripts
- `android/`, `ios/`: Platform-specific code
- `Assets/`: Images and static files

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## Pending Tasks

To complete the project and make it fully deploy-ready, the following tasks need to be addressed:

### Backend Improvements
- **Environment Configuration**: Move hardcoded Firebase credentials path to environment variables or a config file for security and portability.
- **Database Migration**: Replace local MongoDB connection with a cloud database (e.g., MongoDB Atlas) for production deployment.
- **Roadmap Storage**: Implement cloud storage for user roadmaps instead of local JSON files to support multiple users and persistence.
- **Error Handling**: Add comprehensive error handling and logging for API endpoints.
- **Security**: Implement proper authentication middleware and input validation for all endpoints.

### Frontend Improvements
- **Asset Management**: Replace placeholder images (e.g., in SignUp screen) with actual assets or user-uploaded images.
- **Testing**: Add unit and integration tests for critical components.
- **Performance**: Optimize app performance, especially for roadmap generation and PDF viewing.

### Deployment Readiness
- **Environment Variables**: Set up proper environment variable management for API keys and configuration.
- **CI/CD Pipeline**: Implement automated testing and deployment pipelines.
- **Monitoring**: Add logging and monitoring for both frontend and backend.

## Deployment

### Backend Deployment
1. Set up environment variables:
   - Create a `.env` file in `lib/Backend/` with:
     ```
     GOOGLE_API_KEY=your_google_api_key
     FIREBASE_CREDENTIALS_PATH=path/to/firebase/credentials.json
     MONGODB_URI=your_mongodb_connection_string
     ```
   - For production, use cloud services like MongoDB Atlas and secure Firebase credentials.

2. Deploy to a cloud platform (e.g., Heroku, AWS, Google Cloud):
   - Install dependencies: `pip install -r requirements.txt`
   - Run the app: `python app.py`
   - For Heroku: Add a `Procfile` with `web: python app.py`

### Flutter App Deployment
1. Build for Android:
   ```bash
   flutter build apk --release
   ```
   - The APK will be in `build/app/outputs/flutter-apk/`

2. Build for iOS (on macOS):
   ```bash
   flutter build ios --release
   ```
   - Open `ios/Runner.xcworkspace` in Xcode and archive for App Store submission.

3. Web Deployment:
   ```bash
   flutter build web --release
   ```
   - Deploy the `build/web/` folder to a web server.

### Firebase Setup
- Ensure Firebase project is configured with Firestore and Authentication enabled.
- Update `lib/firebase_options.dart` with your Firebase project configuration.

## License

This project is licensed under the MIT License.
