import 'package:flutter/material.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

InputDecoration getLoginRegisterInputDecoration(
        String label, IconData suffixIcon, void Function() onIconTap) =>
    InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: LightThemeAppColors.labeltextColor),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: LightThemeAppColors.secondaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: IconButton(
        onPressed: onIconTap,
        icon: Icon(
          suffixIcon,
          color: LightThemeAppColors.secondaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: LightThemeAppColors.secondaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: LightThemeAppColors.primaryColor,
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

String getErrorMessage(String errorcode) {
  return switch (errorcode) {
    "email-already-in-use" => "Ya existe una cuenta con ese email",
    "invalid-email" => "El email no existe",
    "user-disabled" => "El usuario está desabilitado",
    "user-not-found" => "El usuario no existe",
    "wrong-password" => "Contraseña incorrecta",
    "too-many-requests" => "Demasiadas peticiones",
    "user-token-expired" => "El token del usuario ha expirado",
    "network-request-failed" => "La petición de la red falló",
    "invalid-credential" => "Credenciales inválidos",
    "operation-not-allowed" => "Operación no permitida",
    _ => "Error desconocido en el proceso"
  };
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

TextStyle dataTableTextStyle() => TextStyle(
    color: LightThemeAppColors.textColor, fontWeight: FontWeight.bold);
