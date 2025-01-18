import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:line_icons/line_icons.dart';
import 'package:saarthi/utils/device_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


class Control extends StatefulWidget {
  final String fingerType; // Finger identifier
  final ValueNotifier<int> dataNotifier; // Notifier for live updates

  const Control({super.key, required this.fingerType, required this.dataNotifier});

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  // For checking API connection status
  bool apiConnectionStatus = false;

  // Controller for the TextField
  final TextEditingController _messageController = TextEditingController();

  // State for buttons and TextField
  bool isTextFieldEnabled = false;
  bool isScheduleButtonEnabled = true;
  bool power = false;

  @override
  void initState() {
    super.initState();

    // Listen to dataNotifier changes
    widget.dataNotifier.addListener(() {
       DatabaseReference ref = FirebaseDatabase.instance.ref();

    // Navigate to the 'hom' child
    DatabaseReference homeRef = ref.child("hom");
      if (widget.dataNotifier.value == 1) {
       
         homeRef.set(1).then((_) {
  }).catchError((error) {
    print("Failed to set value: $error");
  });
        setState(() {
          power = true; // Toggle the switch ON
        });
      } else {
        setState(() {
          power = false; // Toggle the switch OFF
        });
      }
    });
  }

  @override
  void dispose() {
    // Remove the listener to prevent memory leaks
    widget.dataNotifier.removeListener(() {});
    _messageController.dispose();
    super.dispose();
  }

  void updateHomeRefValue(int value) {
    // Create a reference to the database
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    // Navigate to the 'hom' child
    DatabaseReference homeRef = ref.child("hom");

    // Set the value (1 or 0)
    homeRef.set(value).then((_) {
      print("Value set successfully to $value.");
      setState(() {
        power = value == 1 ? true : false;
      });
    }).catchError((error) {
      print("Failed to set value: $error");
    });
  }

 // Function to toggle TextField and buttons
  void _onScheduleTap() {
    setState(() {
      isTextFieldEnabled = true;
      isScheduleButtonEnabled = false;
    });
  }

  void _onSendTap() {
    setState(() {
      isTextFieldEnabled = false;
      isScheduleButtonEnabled = true;
      // Perform the "send" action here (e.g., send message to server)
      print("Message Sent: ${_messageController.text}");
      _messageController.clear(); // Clear the TextField
    });
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientText(
                    'Hey CareTaker!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    colors: const [
                      Colors.tealAccent,
                      Colors.cyan,
                      Colors.blueAccent,
                    ],
                  ),
                  InkResponse(
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade900,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (!apiConnectionStatus) {
                            // await connectServer();
                          }
                        },
                        icon: Icon(
                          apiConnectionStatus
                              ? LineIcons.server
                              : LineIcons.powerOff,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Custom Message Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _messageController,
                      enabled: isTextFieldEnabled,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Set an alert or type your message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: isScheduleButtonEnabled
                              ? _onScheduleTap
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                          ),
                          child: const Text("Schedule"),
                        ),
                        ElevatedButton(
                          onPressed: isTextFieldEnabled ? _onSendTap : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Device List Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Linked Device',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DeviceButton(
                icon: Icon(LineIcons.lightbulb, size: 90, color: Colors.white),
                name: "Night Light",
                area: "Bed Room",
                power: power,
                onChange: (value) {
                  updateHomeRefValue(value ? 1 : 2);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Control3 extends StatefulWidget {
  final String fingerType; // Finger identifier
  final ValueNotifier<int> dataNotifier; // Notifier for live updates

  const Control3({super.key, required this.fingerType, required this.dataNotifier});

  @override
  State<Control3> createState() => _Control3State();
}

class _Control3State extends State<Control3> {
  // For checking API connection status
  bool apiConnectionStatus = false;

  // Controller for the TextField
  final TextEditingController _messageController = TextEditingController();

  // State for buttons and TextField
  bool isTextFieldEnabled = false;
  bool isScheduleButtonEnabled = true;

  // Function to toggle TextField and buttons
  void _onScheduleTap() {
    setState(() {
      isTextFieldEnabled = true;
      isScheduleButtonEnabled = false;
    });
  }

  void _onSendTap() {
    setState(() {
      isTextFieldEnabled = false;
      isScheduleButtonEnabled = true;
      // Perform the "send" action here (e.g., send message to server)
      print("Message Sent: ${_messageController.text}");
      _messageController.clear(); // Clear the TextField
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientText(
                    'Hey CareTaker!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    colors: const [
                      Colors.tealAccent,
                      Colors.cyan,
                      Colors.blueAccent,
                    ],
                  ),
                  InkResponse(
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade900,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (!apiConnectionStatus) {
                            // await connectServer();
                          }
                        },
                        icon: Icon(
                          apiConnectionStatus
                              ? LineIcons.server
                              : LineIcons.powerOff,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Custom Message Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _messageController,
                      enabled: isTextFieldEnabled,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Set an alert or type your message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: isScheduleButtonEnabled
                              ? _onScheduleTap
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                          ),
                          child: const Text("Schedule"),
                        ),
                        ElevatedButton(
                          onPressed: isTextFieldEnabled ? _onSendTap : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Device List Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Linked Device',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
              child: DeviceButton(
                icon: Icon(LineIcons.wifi, size: 90, color: Colors.white),
                name: "Wifi",
                area: "Office",
                power: false,
                onChange: (value) => {
                  // onPowerChange(value, 0)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Control1 extends StatefulWidget {
  final String fingerType; // Finger identifier
  final ValueNotifier<int> dataNotifier; // Notifier for live updates

  const Control1({super.key, required this.fingerType, required this.dataNotifier});

  @override
  State<Control1> createState() => _Control1State();
}

class _Control1State extends State<Control1> {
  // For checking API connection status
  bool apiConnectionStatus = false;

  // Controller for the TextField
  final TextEditingController _messageController = TextEditingController();

  // State for buttons and TextField
  bool isTextFieldEnabled = false;
  bool isScheduleButtonEnabled = true;

  // Function to toggle TextField and buttons
  void _onScheduleTap() {
    setState(() {
      isTextFieldEnabled = true;
      isScheduleButtonEnabled = false;
    });
  }

  void _onSendTap() {
    setState(() {
      isTextFieldEnabled = false;
      isScheduleButtonEnabled = true;
      // Perform the "send" action here (e.g., send message to server)
      print("Message Sent: ${_messageController.text}");
      _messageController.clear(); // Clear the TextField
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
             Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientText(
                    'Hey CareTaker!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    colors: const [
                      Colors.tealAccent,
                      Colors.cyan,
                      Colors.blueAccent,
                    ],
                  ),
                  InkResponse(
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade900,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (!apiConnectionStatus) {
                            // await connectServer();
                          }
                        },
                        icon: Icon(
                          apiConnectionStatus
                              ? LineIcons.server
                              : LineIcons.powerOff,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Custom Message Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _messageController,
                      enabled: isTextFieldEnabled,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Set an alert or type your message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: isScheduleButtonEnabled
                              ? _onScheduleTap
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                          ),
                          child: const Text("Schedule"),
                        ),
                        ElevatedButton(
                          onPressed: isTextFieldEnabled ? _onSendTap : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Device List Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Linked Device',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          
            // Header
           Expanded(
              child: DeviceButton(
                icon: Icon(LineIcons.snowflake, size: 90, color: Colors.white),
                name: "AC",
                area: "Living Room",
                power: false,
                onChange: (value) => {
                  // onPowerChange(value, 0)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class Control2 extends StatefulWidget {
  final String fingerType; // Finger identifier (e.g., index, middle, etc.)
  final ValueNotifier<int> dataNotifier; // Notifier for live updates

  const Control2({super.key, required this.fingerType, required this.dataNotifier});

  @override
  State<Control2> createState() => _Control2State();
}

class _Control2State extends State<Control2> {
  // For checking API connection status
  bool apiConnectionStatus = false;

  // Controller for the TextField
  final TextEditingController _messageController = TextEditingController();

  // State for buttons and TextField
  bool isTextFieldEnabled = false;
  bool isScheduleButtonEnabled = true;

  // Flutter local notifications plugin instance
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Adding listener to the notifier
    widget.dataNotifier.addListener(_handleIoTUpdate);

    // Load the saved message for the specific finger
    _loadMessage(widget.fingerType);
  }

  @override
  void dispose() {
    // Removing listener to avoid memory leaks
    widget.dataNotifier.removeListener(_handleIoTUpdate);
    super.dispose();
  }

  // Method triggered when IoT server sends a new value
  Future<void> _handleIoTUpdate() async {
    if (widget.dataNotifier.value == 1) {
      _showAlert("Finger ${widget.fingerType} has sent a signal.");
    }
  }

  // Show alert dialog
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert Triggered"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _onScheduleTap() {
    setState(() {
      isTextFieldEnabled = true;
      isScheduleButtonEnabled = false;
    });
  }

  void _onSendTap() async {
    // Save the message using the specific finger type
    await _saveMessage(widget.fingerType, _messageController.text);
    setState(() {
      isTextFieldEnabled = false;
      isScheduleButtonEnabled = true;
      print("Message Sent: ${_messageController.text}");
    });
  }

  // Save the message for the specific finger
  Future<void> _saveMessage(String fingerType, String message) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("2", message); // Use fingerType as the key
    print('Message saved for $fingerType: $message');
  }

  // Load the saved message from SharedPreferences based on fingerType
  void _loadMessage(String fingerType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessage = prefs.getString(fingerType);
    if (savedMessage != null) {
      _messageController.text = savedMessage;
      print('screen Loaded saved message for $fingerType: $savedMessage');
    } else {
      print('No saved message found for $fingerType');
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientText(
                    'Hey CareTaker!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    colors: const [
                      Colors.tealAccent,
                      Colors.cyan,
                      Colors.blueAccent,
                    ],
                  ),
                  InkResponse(
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade900,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (!apiConnectionStatus) {
                            // await connectServer();
                          }
                        },
                        icon: Icon(
                          apiConnectionStatus
                              ? LineIcons.server
                              : LineIcons.powerOff,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Custom Message Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _messageController,
                      enabled: isTextFieldEnabled,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Set an alert or type your message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: isScheduleButtonEnabled
                              ? _onScheduleTap
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                          ),
                          child: const Text("Schedule"),
                        ),
                        ElevatedButton(
                          onPressed: isTextFieldEnabled ? _onSendTap : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Device List Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Linked Device',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DeviceButton(
                icon: Icon(LineIcons.television, size: 90, color: Colors.white),
                name: "Television",
                area: "Bedroom",
                power: false,
                onChange: (value) => {
                  // onPowerChange(value, 0)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
