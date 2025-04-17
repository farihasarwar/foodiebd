import 'package:firebase_core/firebase_core.dart';
import 'package:foodiebd/core/constants/firebase_constants.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: FirebaseConstants.apiKey,
        authDomain: FirebaseConstants.authDomain,
        projectId: FirebaseConstants.projectId,
        storageBucket: FirebaseConstants.storageBucket,
        messagingSenderId: FirebaseConstants.messagingSenderId,
        appId: FirebaseConstants.appId,
        measurementId: FirebaseConstants.measurementId,
      ),
    );
  }
} 