import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyC8nlBSsj-ufncmREXK4kaRG9GuVtHPxRM',
          authDomain: 'flutter-weather-app-8e057.firebaseapp.com',
          projectId: 'flutter-weather-app-8e057',
          storageBucket: 'flutter-weather-app-8e057.appspot.com',
          messagingSenderId: '925709401879',
          appId: '1:925709401879:web:5c00a87e4371eab4f8c152',
          measurementId: 'G-54EG9G79ZC',
        ),
      );
    } else {
      await Firebase.initializeApp(); // Uses google-services.json on mobile
    }
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb
            ? '925709401879-4e5io09snjts0a765ph8f1ns44cb5qui.apps.googleusercontent.com'
            : null,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }
}