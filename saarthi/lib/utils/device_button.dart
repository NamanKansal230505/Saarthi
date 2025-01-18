import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceButton extends StatelessWidget {
  final Icon icon; // Updated to use IconData for flexibility
  final String name;
  final String area;
  final bool power;
  final void Function(bool)? onChange;

  const DeviceButton({
    super.key,
    required this.icon,
    required this.name,
    required this.area,
    required this.power,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: power ? Colors.greenAccent.shade100 : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: power
                  ? Colors.greenAccent.shade100.withOpacity(0.5)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Icon on the left
                CircleAvatar(
                  radius: 100,
                  backgroundColor: power ? Colors.green : Colors.grey.shade800,
                  child: icon,
                ),
                const SizedBox(height: 30),
                // Device details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: power
                            ? Colors.black.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      area,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: power ? Colors.black54 : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Switch on the right
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Transform.scale(
                scale: 1,
                child: CupertinoSwitch(
                  value: power,
                  onChanged: onChange,
                  activeColor: Colors.greenAccent.shade400,
                  thumbColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
