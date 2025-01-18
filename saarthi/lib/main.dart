import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saarthi/SplashScreen.dart';
import 'package:saarthi/constraints.dart';
import 'package:saarthi/introduction_animation/introduction_animation_screen.dart';
import 'package:saarthi/rootnavigator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
    //   options: FirebaseOptions(
    // apiKey: 'AIzaSyDRMYRp6L3Gial0wEQN2MJgrnAlH-nw8Io',
    // appId: '1:470072475917:android:f12eae43222d42a6533044',
    // messagingSenderId: '470072475917',
    // projectId: 'saarthi-84622',
    // storageBucket: 'saarthi-84622-default-rtdb.asia-southeast1.firebasedatabase.app',   )
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Screens',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: aBackgroundColor,
      ),
      home: IntroductionAnimationScreen(),
    );
  }
}