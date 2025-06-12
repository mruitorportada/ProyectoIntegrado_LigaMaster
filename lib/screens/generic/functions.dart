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
    (value == null || value.isEmpty || value.toString().startsWith(""))
        ? "Por favor, introduce un nombre"
        : null;

String? ratingValidator(value) {
  String valueToString = value.toString().replaceAll(" ", "");
  if (valueToString.isEmpty) {
    return "La valoración debe ser entre 1 y 5";
  }

  if (valueToString.contains(",") ||
      valueToString.contains("-") ||
      valueToString.endsWith(".") ||
      valueToString.startsWith("0")) {
    return "Usa este formato (3.8)";
  }

  if (valueToString.length > 4) {
    return "Sólo se permiten dos decimales";
  }

  double ratingSelected = double.parse(valueToString);
  if (ratingSelected < 1 || ratingSelected > 5) {
    return "La valoración debe ser entre 1 y 5";
  }
  return null;
}

String getTeamRating(double rating) {
  int length = rating.toString().length;
  String ratingToString = rating.toString();
  return length < 4
      ? ratingToString.substring(0, length)
      : ratingToString.substring(0, 4);
}

String getErrorMessage(AppStrings strings, String errorcode) {
  return switch (errorcode) {
    "email-already-in-use" => strings.emailAlreadyUsedErrorMessage,
    "invalid-email" => strings.invalidEmailErrorMessage,
    "user-disabled" => strings.userDisabledErrorMessage,
    "user-not-found" => strings.userNotFoundErrorMessage,
    "wrong-password" => strings.wrongPasswordErrorMessage,
    "too-many-requests" => strings.tooManyRequestsErrorMessage,
    "user-token-expired" => strings.userTokenExpiredErrorMessage,
    "network-request-failed" => strings.networkRequestFailedErrorMessage,
    "invalid-credential" => strings.invalidCredentialErrorMessage,
    "operation-not-allowed" => strings.operationNotAllowedErrorMessage,
    _ => strings.unknownErrorErrorMessage
  };
}

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

String getLocalizedNameErrorMessage(AppStrings strings) =>
    strings.emptyNameErrorMessage;

String? getLocalizedRatingErrorMessage(
        AppStrings strings, String? errorMessage) =>
    switch (errorMessage) {
      "Usa este formato (3.8)" => strings.ratingFormatErrorMessage,
      "Sólo se permiten dos decimales" => strings.ratingLengthErrorMessage,
      "La valoración debe ser entre 1 y 5" => strings.ratingValueErrorMessage,
      _ => null
    };
