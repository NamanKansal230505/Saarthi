
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saarthi/constraints.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    key,
    required this.buttonName,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);
  final String buttonName;
  final VoidCallback onTap;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: TextButton(
          style: TextButton.styleFrom(overlayColor: Colors.black12),
          onPressed: onTap,
          child: Text(
            buttonName,
            style: aButtonText.copyWith(color: textColor),
          ),
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('buttonName', buttonName));
  }
}

// class MyRoutes {
//   static String signinRoute = "/signin";
//   // static String homeRoute = "/";
// }