import 'package:flutter/material.dart';

InputDecoration getInputDecoration(
        String label, IconData suffixIcon, void Function() onIconTap) =>
    InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white54),
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: IconButton(
        onPressed: onIconTap,
        icon: Icon(
          suffixIcon,
          color: Colors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(255, 0, 204, 204)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
