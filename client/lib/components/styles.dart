import 'package:flutter/material.dart';

var buttonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  primary: Colors.white, // Background color
  onPrimary: Colors.blue, // Text color
  side: const BorderSide(color: Colors.blue, width: 2), // Border color and width
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10), // Rounded corners
  ),
);

var accentButtonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  primary: Colors.blue, // Background color
  onPrimary: Colors.white, // Text color
  // side: const BorderSide(color: Colors.blue, width: 2), // Border color and width
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10), // Rounded corners
  ),
);

InputDecoration formFieldStyleWithLabel(String label, {IconButton? iconButton, String? errorText}) {
  return InputDecoration(
    labelText: label,
    suffixIcon: iconButton,
    labelStyle: const TextStyle(fontSize: 18),
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    errorText: errorText,
  );
}

var formTextStyle = const TextStyle(fontSize: 18);