import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPress;

  const RoundedButton(
      {super.key,
      required this.color,
      required this.label,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
