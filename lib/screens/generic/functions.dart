import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';

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

String? nameValidator(value) =>
    (value == null || value.isEmpty) ? "Por favor, introduce un nombre" : null;

String? ratingValidator(value) {
  if (value.toString().contains(",")) {
    return "Usa punto en vez de coma (3.8)";
  }

  if (value.toString().length > 3) {
    return "Sólo se permiten dos decimales";
  }

  double ratingSelected = double.parse(value);
  if (ratingSelected < 1 || ratingSelected > 5) {
    return "La valoración debe ser entre 1 y 5";
  }
  return null;
}

String? positionValidator(value) =>
    value == null ? "Seleccione una posición" : null;

List<PlayerPosition> getPositionsBasedOnSportSelected(Sport sportSelected) =>
    switch (sportSelected) {
      Sport.football => FootballPlayerPosition.values,
      Sport.futsal => FutsalPlayerPosition.values
    };

PlayerPosition getFirstPositionBasedOnSportSelected(Sport sportSelected) =>
    switch (sportSelected) {
      Sport.football => FootballPlayerPosition.values.first,
      Sport.futsal => FutsalPlayerPosition.values.first
    };
