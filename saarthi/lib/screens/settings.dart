import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';

//Lottie Animation
import 'package:lottie/lottie.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/error.json',
                  fit: BoxFit.cover,
                ),
                const Text(
                  'Setting Screen',
                  style: TextStyle(
                      color: Colors.white24,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Under Development ',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.warning_amber_outlined,
                      size: 20,
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
              ],
            )));
  }
}
