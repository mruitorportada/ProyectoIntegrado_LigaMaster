import 'package:flutter/material.dart';

InputDecoration getLoginRegisterInputDecoration(
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

InputDecoration getGenericInputDecoration(
        String label, Color labelColor, Color textColor) =>
    InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: labelColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColor),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColor),
        borderRadius: BorderRadius.circular(12),
      ),
    );
