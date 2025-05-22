import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

InputDecoration getLoginRegisterInputDecoration(
        String label, IconData suffixIcon, void Function() onIconTap) =>
    InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.labeltextColor),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.secondaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: IconButton(
        onPressed: onIconTap,
        icon: Icon(
          suffixIcon,
          color: AppColors.secondaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.secondaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: AppColors.primaryColor,
      filled: true,
    );

InputDecoration getGenericInputDecoration(String label) => InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          color: AppColors.labeltextColor, fontWeight: FontWeight.w600),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.textColor),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.textColor),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: AppColors.primaryColor,
      filled: true,
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

TextStyle dataTableTextStyle() =>
    TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold);
