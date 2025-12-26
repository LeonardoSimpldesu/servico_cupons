import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:trying_flutter/src/core/theme/app_theme.dart';
import 'src/core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBqqeroet1XqZWO25uJnrzjSII33rIwY0Q",
      authDomain: "trying-flutter-23a8d.firebaseapp.com",
      projectId: "trying-flutter-23a8d",
      storageBucket: "trying-flutter-23a8d.firebasestorage.app",
      messagingSenderId: "68033477432",
      appId: "1:68033477432:web:07148f45b4a42b7525dfcd",
      measurementId: "G-VM6SY7K427",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sistema de Cupons',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

