import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import the notification package
import 'package:saarthi/screens/controls.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences package

class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  // Using ValueNotifier for live updates in Control class
  final ValueNotifier<int> indexDataNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> middleDataNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> ringDataNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> pinkyDataNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> fallDataNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> homeDataNotifier = ValueNotifier<int>(0);

  // Flutter Local Notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    listenToFingerData();
  }

  // Initialize the notification plugin
  void initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Set up listeners for each finger gesture data
  void listenToFingerData() {
    DatabaseReference indexRef = ref.child("gesture/index/alert");
    DatabaseReference middleRef = ref.child("gesture/middle/alert");
    DatabaseReference ringRef = ref.child("gesture/ring/alert");
    DatabaseReference pinkyRef = ref.child("gesture/pinky/alert");
    DatabaseReference fallRef = ref.child("fall");
    DatabaseReference homeRef = ref.child("hom");

    indexRef.onValue.listen((event) {
      final newValue = event.snapshot.value as int;
      indexDataNotifier.value = newValue;
      print("Index finger data updated: $newValue");

      if (newValue == 1) { 
         homeRef.set(1).then((_) {
  }).catchError((error) {
    print("Failed to set value: $error");
  });
      }
      // checkAndNotifyFinger("index", newValue);
    });
    middleRef.onValue.listen((event) {
      final newValue = event.snapshot.value as int;
      middleDataNotifier.value = newValue;
      print("Middle finger data updated: $newValue");
      // checkAndNotifyFinger("middle", newValue);
    });
    ringRef.onValue.listen((event) async {
      final newValue = event.snapshot.value as int;
      ringDataNotifier.value = newValue;
      print("Ring finger data updated: $newValue");
       if (newValue == 1) {
       _loadMessage("ring");
        
    
   
      // checkAndNotifyFinger("ring", newValue);
       }
    });
    pinkyRef.onValue.listen((event) {
      final newValue = event.snapshot.value as int;
      pinkyDataNotifier.value = newValue;
      print("Pinky finger data updated: $newValue");
      // checkAndNotifyFinger("pinky", newValue);
    });

    fallRef.onValue.listen((event) {
      final newValue = event.snapshot.value as int;
      fallDataNotifier.value = newValue;
      print("Person fall data updated: $newValue");
      // Show notification when fall data is updated
      if (newValue == 1) {
        print("notify updated: $newValue");
        showFallNotification();
      }
    });

    homeRef.onValue.listen((event) {
      final newValue = event.snapshot.value as int;
      homeDataNotifier.value = newValue;
      print("Home automation data updated: $newValue");
    });
  }

   void _loadMessage(String fingerType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessage = prefs.getString(fingerType);
    if (savedMessage != null) {
      showFingerNotification(savedMessage);
      print('Loaded saved message for $fingerType: $savedMessage');
    } else {
      print('No saved message found for $fingerType');
    }
  }

  Future<void> saveFingerDataWithMessage({
  required int indexValue,
  required int middleValue,
  required int ringValue,
  required int pinkyValue,
}) async {
  // Get the SharedPreferences instance
  final prefs = await SharedPreferences.getInstance();

  // Save the customized message for each finger value
  await prefs.setString('index_$indexValue', "Custom message for Index finger value: $indexValue");
  await prefs.setString('middle_$middleValue', "Custom message for Middle finger value: $middleValue");
  await prefs.setString('ring_$ringValue', "Custom message for Ring finger value: $ringValue");
  await prefs.setString('pinky_$pinkyValue', "Custom message for Pinky finger value: $pinkyValue");

  print('Finger data with custom messages saved.');
}

  // Function to check the finger data and show notification if it's different
  // void checkAndNotifyFinger(int key) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   prefs.getString(key as String);
  //   int storedValue = prefs.getInt(fingerType) ?? -1; // -1 means no value set

  //   if (storedValue != value) {
  //     prefs.setInt(fingerType, value); // Store the new value

  //     // Show notification based on finger type and value
  //     showFingerNotification(fingerType, value);
  //   }
  // }

  // Function to show a notification based on finger gesture
  void showFingerNotification(String? value) async {
  const androidDetails = AndroidNotificationDetails(
    'finger_notification_channel',
    'Finger Gesture Notification',
    channelDescription: 'Notifications for finger gesture updates',
    importance: Importance.max,
    priority: Priority.high,
  );
  const notificationDetails = NotificationDetails(android: androidDetails);

print("messaging    $value");
  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Gesture Update',
    '$value',
    notificationDetails,
    payload: 'Check Fast',
  );
}


  // Function to show a notification when fall data is updated
  void showFallNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'fall_notification_channel',
      'Fall Notification',
      channelDescription: 'Notifications for fall detection',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Alert: Fall Detected',
      'A fall has been detected, please check the person immediately.',
      notificationDetails,
      payload: 'fall_detected',
    );
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: Colors.black,
        child: GNav(
          backgroundColor: Colors.black,
          rippleColor: Colors.grey.shade900,
          tabBackgroundColor: Colors.grey.shade900,
          hoverColor: Colors.grey.shade900,
          activeColor: Colors.white,
          color: Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          duration: const Duration(milliseconds: 400),
          gap: 4,
          iconSize: 24,
          onTabChange: (index) {
            saveFingerDataWithMessage(indexValue: index, middleValue: index, ringValue: index, pinkyValue: index);
            setState(() {
              selectedIndex = index;
            });
          },
          selectedIndex: selectedIndex,
          tabs: const [
            GButton(icon: LineIcons.handPointingUp, text: "Index"),
            GButton(icon: LineIcons.handWithMiddleFingerRaised, text: "Middle"),
            GButton(icon: LineIcons.scissorsHand, text: "Ring"),
            GButton(icon: LineIcons.peaceHand, text: "Pinky"),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: getSelectedWidget(index: selectedIndex),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    switch (index) {
      case 0:
        return Control(fingerType: "Index", dataNotifier: indexDataNotifier);
      case 1:
        return Control1(fingerType: "Middle", dataNotifier: middleDataNotifier);
      case 2:
        return Control2(fingerType: "Ring", dataNotifier: ringDataNotifier);
      case 3:
        return Control3(fingerType: "Pinky", dataNotifier: pinkyDataNotifier);
      default:
        return Control(fingerType: "Index", dataNotifier: indexDataNotifier);
    }
  }
}

