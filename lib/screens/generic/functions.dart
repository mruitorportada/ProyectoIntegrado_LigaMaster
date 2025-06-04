import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:provider/provider.dart';

InputDecoration getLoginRegisterInputDecoration(BuildContext context,
        String label, IconData suffixIcon, void Function() onIconTap) =>
    InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: LightThemeAppColors.labeltextColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: IconButton(
        onPressed: onIconTap,
        icon: Icon(
          suffixIcon,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: Theme.of(context).primaryColor,
      filled: true,
    );

String? nameValidator(value) =>
    (value == null || value.isEmpty) ? "Por favor, introduce un nombre" : null;

String? ratingValidator(value) {
  if (value.toString().contains(",")) {
    return "Usa punto en vez de coma (3.8)";
  }

  if (value.toString().length > 4) {
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

String getCompetitionFormatLabel(
        AppStrings strings, CompetitionFormat format) =>
    switch (format) {
      CompetitionFormat.league => strings.leagueFormatLabel,
      CompetitionFormat.tournament => strings.tournamentFormatLabel
    };

String getSportLabel(AppStrings strings, Sport sport) => switch (sport) {
      Sport.football => strings.footballSportName,
      Sport.futsal => strings.futsalSportName
    };

String getPlayerPositionLabel(AppStrings strings, PlayerPosition position) =>
    switch (position) {
      FootballPlayerPosition.portero ||
      FutsalPlayerPosition.portero =>
        strings.goalKeeperPositionName,
      FootballPlayerPosition.defensa => strings.footballDefenderPositionName,
      FootballPlayerPosition.centrocampista =>
        strings.footballMidfielderPositionName,
      FootballPlayerPosition.delantero => strings.footballStrikerPositionName,
      FutsalPlayerPosition.cierre => strings.futsalDefenderPositionName,
      FutsalPlayerPosition.alas => strings.futsalMidfielderPositionName,
      FutsalPlayerPosition.pivot => strings.futsalStrikerPositionName,
      _ => ""
    };

String getTournamentRoundLabel(BuildContext context, TournamentRounds round) {
  final controller = Provider.of<AppStringsController>(context, listen: false);
  final strings = controller.strings!;

  return switch (round) {
    TournamentRounds.round64 => strings.round64Label,
    TournamentRounds.round32 => strings.round32Label,
    TournamentRounds.round16 => strings.round16Label,
    TournamentRounds.round8 => strings.round8Label,
    TournamentRounds.round4 => strings.round4Label,
    TournamentRounds.round2 => strings.round2Label
  };
}
