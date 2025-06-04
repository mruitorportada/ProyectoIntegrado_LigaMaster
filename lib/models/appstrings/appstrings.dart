class AppStrings {
  // ------ Login Screen ------
  final String loginButton;
  final String loginText;
  final String resetPasswordText;
  final String emailLabel;
  final String passwordLabel;
  final String emailNotFoundText;

  // ------ Sign up Screen -----
  final String registerButton;
  final String registerText;
  final String nameLabel;
  final String surnameLabel;
  final String usernameLabel;
  final String passwordFormatErrorText;
  final String allFieldsRequiredText;
  final String emailVerificationText;
  final String emailSentText;
  final String resendButtonText;

  // ------ Profile Screen -----
  final String profileScreenTitle;
  final String numCompetitionsSavedLabel;
  final String numTeamsSavedLabel;
  final String numPlayersSavedLabel;
  final String cropImageAppBarTitle;

  // ------ Home Screen -----
  final String homeScreenTitle;
  final String competitionsLabel;
  final String teamsLabel;
  final String playersLabel;

  // ------ Drawer -----
  final String homeDrawerLabel;
  final String profileDrawerLabel;
  final String logOutDrawerLabel;

  // ------ Competition List Screen -----
  final String deleteItemDialogTitle;
  final String deleteCompetitionText;
  final String addCompetitionText;
  final String addCompetitionByCodeText;
  final String addCompetitionByCodeLabel;
  final String insertCodeLabel;
  final String acceptDialogButtonText;
  final String successMessage;
  final String errorMessage;

  // ------ Competition Creation Screen -----
  final String addCompetitionScreenTitle;
  final String sportLabel;
  final String numberOfTeamsThatParticipateLabel;
  final String formatLabel;
  final String selectTeamsButtonText;
  final String cancelTextButton;
  final String noTeamsAvaliableToAddText;
  final String errorNumberOfTeamsSelected;

  // ------ Competition Details Screen -----
  final String infoTabLabel;
  final String teamsTabLabel;
  final String rankingTabLabel;
  final String resultsTabLabel;
  final String fixturesTabLabel;
  final String statsTabLabel;

  final String creatorLabel;
  final String codeLabel;

  final String matchesLabel;
  final String goalsScoredLabel;
  final String goalsConcededLabel;

  final String assistsLabel;
  final String yellowCardsLabel;
  final String redCardsLabel;
  final String statusLabel;
  final String playersTitle;

  final String teamLabel;
  final String pointsLabel;
  final String victoriesLabel;
  final String losesLabel;
  final String tiesLabel;
  final String goalDifferenceLabel;

  final String roundLabel;
  final String noRoundsMessage;

  final String noFixturesMessage;
  final String generateNextRoundButtonText;
  final String resetTournamentButtonText;
  final String generateFixturesText;
  final String numberOfTimesTeamsFaceEachOtherText;
  final String createFixtureButtonText;

  final String matchDetailsTitle;
  final String selectEventTitle;
  final String selectTeamTitle;
  final String selectPlayerTitle;
  final String banLengthTitle;
  final String banLengthErrorMessage;
  final String banInputLabel;
  final String saveMatchDialogText;
  final String dateErrorText;
  final String timeErrorText;
  final String teamsSortedByGoalsScoredTableTitle;
  final String teamsSortedByGoalsConcededTableTitle;
  final String playersSortedByGoalsScoredTableTitle;
  final String playersSortedByAssistsTableTitle;
  final String playerLabel;

  // ------ Team List Screen -----
  final String deleteTeamText;

  // ------ Team Edition Screen -----
  final String editTeamTitle;
  final String playersButtonText;
  final String playersInTeamTitle;
  final String noPlayersInTeamText;
  final String noPlayersAvaliableToSelect;
  final String uniqueNameError;
  final String closeDialogText;

  // ------ Team Creation Screen -----
  final String addTeamTitle;
  final String ratingLabel;

  // ------ Player List Screen -----
  final String deletePlayerText;
  final String noTeamText;

  // ------ Player Edition Screen -----
  final String editPlayerTitle;
  final String positionLabel;

  // ------ Player Creation Screen -----
  final String createPlayerTitle;

  AppStrings({
    required this.loginButton,
    required this.loginText,
    required this.resetPasswordText,
    required this.emailLabel,
    required this.passwordLabel,
    required this.emailNotFoundText,
    required this.registerButton,
    required this.registerText,
    required this.nameLabel,
    required this.surnameLabel,
    required this.usernameLabel,
    required this.passwordFormatErrorText,
    required this.allFieldsRequiredText,
    required this.emailVerificationText,
    required this.emailSentText,
    required this.resendButtonText,
    required this.profileScreenTitle,
    required this.numCompetitionsSavedLabel,
    required this.numTeamsSavedLabel,
    required this.numPlayersSavedLabel,
    required this.cropImageAppBarTitle,
    required this.homeScreenTitle,
    required this.competitionsLabel,
    required this.teamsLabel,
    required this.playersLabel,
    required this.homeDrawerLabel,
    required this.profileDrawerLabel,
    required this.logOutDrawerLabel,
    required this.deleteItemDialogTitle,
    required this.deleteCompetitionText,
    required this.addCompetitionText,
    required this.addCompetitionByCodeText,
    required this.addCompetitionByCodeLabel,
    required this.successMessage,
    required this.errorMessage,
    required this.insertCodeLabel,
    required this.acceptDialogButtonText,
    required this.addCompetitionScreenTitle,
    required this.sportLabel,
    required this.numberOfTeamsThatParticipateLabel,
    required this.formatLabel,
    required this.selectTeamsButtonText,
    required this.cancelTextButton,
    required this.noTeamsAvaliableToAddText,
    required this.errorNumberOfTeamsSelected,
    required this.infoTabLabel,
    required this.teamsTabLabel,
    required this.rankingTabLabel,
    required this.resultsTabLabel,
    required this.fixturesTabLabel,
    required this.statsTabLabel,
    required this.ratingLabel,
    required this.creatorLabel,
    required this.codeLabel,
    required this.matchesLabel,
    required this.goalsScoredLabel,
    required this.goalsConcededLabel,
    required this.assistsLabel,
    required this.yellowCardsLabel,
    required this.redCardsLabel,
    required this.statusLabel,
    required this.playersTitle,
    required this.teamLabel,
    required this.pointsLabel,
    required this.victoriesLabel,
    required this.losesLabel,
    required this.tiesLabel,
    required this.goalDifferenceLabel,
    required this.roundLabel,
    required this.noRoundsMessage,
    required this.noFixturesMessage,
    required this.generateNextRoundButtonText,
    required this.resetTournamentButtonText,
    required this.generateFixturesText,
    required this.numberOfTimesTeamsFaceEachOtherText,
    required this.createFixtureButtonText,
    required this.matchDetailsTitle,
    required this.selectEventTitle,
    required this.selectTeamTitle,
    required this.selectPlayerTitle,
    required this.banLengthTitle,
    required this.banLengthErrorMessage,
    required this.banInputLabel,
    required this.saveMatchDialogText,
    required this.dateErrorText,
    required this.timeErrorText,
    required this.teamsSortedByGoalsScoredTableTitle,
    required this.teamsSortedByGoalsConcededTableTitle,
    required this.playersSortedByGoalsScoredTableTitle,
    required this.playersSortedByAssistsTableTitle,
    required this.playerLabel,
    required this.deleteTeamText,
    required this.editTeamTitle,
    required this.playersButtonText,
    required this.playersInTeamTitle,
    required this.noPlayersInTeamText,
    required this.noPlayersAvaliableToSelect,
    required this.uniqueNameError,
    required this.addTeamTitle,
    required this.deletePlayerText,
    required this.noTeamText,
    required this.editPlayerTitle,
    required this.closeDialogText,
    required this.positionLabel,
    required this.createPlayerTitle,
  });

  factory AppStrings.fromMap(Map<String, dynamic> map) => AppStrings(
        loginButton: map["loginButton"] ?? "",
        loginText: map["loginText"] ?? "",
        resetPasswordText: map["resetPasswordText"] ?? "",
        emailLabel: map["emailLabel"] ?? "",
        passwordLabel: map["passwordLabel"] ?? "",
        emailNotFoundText: map["emailNotFoundText"] ?? "",
        registerButton: map["registerButton"] ?? "",
        registerText: map["registerText"] ?? "",
        nameLabel: map["nameLabel"] ?? "",
        surnameLabel: map["surnameLabel"] ?? "",
        usernameLabel: map["usernameLabel"] ?? "",
        passwordFormatErrorText: map["passwordFormatErrorText"] ?? "",
        allFieldsRequiredText: map["allFieldsRequiredText"] ?? "",
        emailVerificationText: map["emailVerificationText"] ?? "",
        emailSentText: map["emailSentText"] ?? "",
        resendButtonText: map["resendButtonText"] ?? "",
        profileScreenTitle: map["profileScreenTitle"] ?? "",
        numCompetitionsSavedLabel: map["numCompetitionsSavedLabel"] ?? "",
        numTeamsSavedLabel: map["numTeamsSavedLabel"] ?? "",
        numPlayersSavedLabel: map["numPlayersSavedLabel"] ?? "",
        cropImageAppBarTitle: map["cropImageAppBarTitle"] ?? "",
        homeScreenTitle: map["homeScreenTitle"] ?? "",
        competitionsLabel: map["competitionsLabel"] ?? "",
        teamsLabel: map["teamsLabel"] ?? "",
        playersLabel: map["playersLabel"] ?? "",
        homeDrawerLabel: map["homeDrawerLabel"] ?? "",
        profileDrawerLabel: map["profileDrawerLabel"] ?? "",
        logOutDrawerLabel: map["logOutDrawerLabel"] ?? "",
        deleteItemDialogTitle: map["deleteItemDialogTitle"] ?? "",
        deleteCompetitionText: map["deleteCompetitionText"] ?? "",
        addCompetitionText: map["addCompetitionText"] ?? "",
        successMessage: map["successMessage"] ?? "",
        errorMessage: map["errorMessage"] ?? "",
        addCompetitionByCodeText: map["addCompetitionByCodeText"] ?? "",
        addCompetitionByCodeLabel: map["addCompetitionByCodeLabel"] ?? "",
        insertCodeLabel: map["insertCodeLabel"] ?? "",
        acceptDialogButtonText: map["acceptDialogButtonText"] ?? "",
        addCompetitionScreenTitle: map["addCompetitionScreenTitle"] ?? "",
        sportLabel: map["sportLabel"] ?? "",
        ratingLabel: map["ratingLabel"] ?? "",
        numberOfTeamsThatParticipateLabel:
            map["numberOfTeamsThatParticipateLabel"] ?? "",
        formatLabel: map["formatLabel"] ?? "",
        selectTeamsButtonText: map["selectTeamsButtonText"] ?? "",
        cancelTextButton: map["cancelTextButton"] ?? "",
        noTeamsAvaliableToAddText: map["noTeamsAvaliableToAddText"] ?? "",
        errorNumberOfTeamsSelected: map["errorNumberOfTeamsSelected"] ?? "",
        infoTabLabel: map["infoTabLabel"] ?? "",
        teamsTabLabel: map["teamsTabLabel"] ?? "",
        rankingTabLabel: map["rankingTabLabel"] ?? "",
        resultsTabLabel: map["resultsTabLabel"] ?? "",
        fixturesTabLabel: map["fixturesTabLabel"] ?? "",
        statsTabLabel: map["statsTabLabel"] ?? "",
        creatorLabel: map["creatorLabel"] ?? "",
        codeLabel: map["codeLabel"] ?? "",
        matchesLabel: map["matchesLabel"] ?? "",
        goalsScoredLabel: map["goalsScoredLabel"] ?? "",
        goalsConcededLabel: map["goalsConcededLabel"] ?? "",
        assistsLabel: map["assistsLabel"] ?? "",
        yellowCardsLabel: map["yellowCardsLabel"] ?? "",
        redCardsLabel: map["redCardsLabel"] ?? "",
        statusLabel: map["statusLabel"] ?? "",
        playersTitle: map["playersTitle"] ?? "",
        teamLabel: map["teamLabel"] ?? "",
        pointsLabel: map["pointsLabel"] ?? "",
        victoriesLabel: map["victoriesLabel"] ?? "",
        losesLabel: map["losesLabel"] ?? "",
        tiesLabel: map["tiesLabel"] ?? "",
        goalDifferenceLabel: map["goalDifferenceLabel"] ?? "",
        roundLabel: map["roundLabel"] ?? "",
        noRoundsMessage: map["noRoundsMessage"] ?? "",
        noFixturesMessage: map["noFixturesMessage"] ?? "",
        generateNextRoundButtonText: map["generateNextRoundButtonText"] ?? "",
        resetTournamentButtonText: map["resetTournamentButtonText"] ?? "",
        generateFixturesText: map["generateFixturesText"] ?? "",
        numberOfTimesTeamsFaceEachOtherText:
            map["numberOfTimesTeamsFaceEachOtherText"] ?? "",
        createFixtureButtonText: map["createFixtureButtonText"] ?? "",
        matchDetailsTitle: map["matchDetailsTitle"] ?? "",
        selectEventTitle: map["selectEventTitle"] ?? "",
        selectTeamTitle: map["selectTeamTitle"] ?? "",
        selectPlayerTitle: map["selectPlayerTitle"] ?? "",
        banLengthTitle: map["banLengthTitle"] ?? "",
        banLengthErrorMessage: map["banLengthErrorMessage"] ?? "",
        banInputLabel: map["banInputLabel"] ?? "",
        saveMatchDialogText: map["saveMatchDialogText"] ?? "",
        dateErrorText: map["dateErrorText"] ?? "",
        timeErrorText: map["timeErrorText"] ?? "",
        teamsSortedByGoalsScoredTableTitle:
            map["teamsSortedByGoalsScoredTableTitle"] ?? "",
        teamsSortedByGoalsConcededTableTitle:
            map["teamsSortedByGoalsConcededTableTitle"] ?? "",
        playersSortedByGoalsScoredTableTitle:
            map["playersSortedByGoalsScoredTableTitle"] ?? "",
        playersSortedByAssistsTableTitle:
            map["playersSortedByAssistsTableTitle"] ?? "",
        playerLabel: map["playerLabel"] ?? "",
        deleteTeamText: map["deleteTeamText"] ?? "",
        editTeamTitle: map["editTeamTitle"] ?? "",
        closeDialogText: map["closeDialogText"] ?? "",
        playersButtonText: map["playersButtonText"] ?? "",
        playersInTeamTitle: map["playersInTeamTitle"] ?? "",
        noPlayersInTeamText: map["noPlayersInTeamText"] ?? "",
        noPlayersAvaliableToSelect: map["noPlayersAvaliableToSelect"] ?? "",
        uniqueNameError: map["uniqueNameError"] ?? "",
        addTeamTitle: map["addTeamTitle"] ?? "",
        deletePlayerText: map["deletePlayerText"] ?? "",
        noTeamText: map["noTeamText"] ?? "",
        editPlayerTitle: map["editPlayerTitle"] ?? "",
        positionLabel: map["positionLabel"] ?? "",
        createPlayerTitle: map["createPlayerTitle"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "loginButton": loginButton,
        "loginText": loginText,
        "resetPasswordText": resetPasswordText,
        "emailLabel": emailLabel,
        "passwordLabel": passwordLabel,
        "emailNotFoundText": emailNotFoundText,
        "registerButton": registerButton,
        "registerText": registerText,
        "nameLabel": nameLabel,
        "surnameLabel": surnameLabel,
        "usernameLabel": usernameLabel,
        "passwordFormatErrorText": passwordFormatErrorText,
        "allFieldsRequiredText": allFieldsRequiredText,
        "emailVerificationText": emailVerificationText,
        "emailSentText": emailSentText,
        "resendButtonText": resendButtonText,
        "profileScreenTitle": profileScreenTitle,
        "numCompetitionsSavedLabel": numCompetitionsSavedLabel,
        "numTeamsSavedLabel": numTeamsSavedLabel,
        "numPlayersSavedLabel": numPlayersSavedLabel,
        "cropImageAppBarTitle": cropImageAppBarTitle,
        "homeScreenTitle": homeScreenTitle,
        "competitionsLabel": competitionsLabel,
        "teamsLabel": teamsLabel,
        "ratingLabel": ratingLabel,
        "playersLabel": playersLabel,
        "homeDrawerLabel": homeDrawerLabel,
        "profileDrawerLabel": profileDrawerLabel,
        "logOutDrawerLabel": logOutDrawerLabel,
        "deleteItemDialogTitle": deleteItemDialogTitle,
        "deleteCompetitionText": deleteCompetitionText,
        "addCompetitionText": addCompetitionText,
        "addCompetitionByCodeText": addCompetitionByCodeText,
        "addCompetitionByCodeLabel": addCompetitionByCodeLabel,
        "successMessage": successMessage,
        "errorMessage": errorMessage,
        "insertCodeLabel": insertCodeLabel,
        "acceptDialogButtonText": acceptDialogButtonText,
        "addCompetitionScreenTitle": addCompetitionScreenTitle,
        "sportLabel": sportLabel,
        "numberOfTeamsThatParticipateLabel": numberOfTeamsThatParticipateLabel,
        "formatLabel": formatLabel,
        "selectTeamsButtonText": selectTeamsButtonText,
        "cancelTextButton": cancelTextButton,
        "noTeamsAvaliableToAddText": noTeamsAvaliableToAddText,
        "errorNumberOfTeamsSelected": errorNumberOfTeamsSelected,
        "infoTabLabel": infoTabLabel,
        "teamsTabLabel": teamsTabLabel,
        "rankingTabLabel": rankingTabLabel,
        "resultsTabLabel": resultsTabLabel,
        "fixturesTabLabel": fixturesTabLabel,
        "statsTabLabel": statsTabLabel,
        "creatorLabel": creatorLabel,
        "codeLabel": codeLabel,
        "matchesLabel": matchesLabel,
        "goalsScoredLabel": goalsScoredLabel,
        "goalsConcededLabel": goalsConcededLabel,
        "assistsLabel": assistsLabel,
        "yellowCardsLabel": yellowCardsLabel,
        "redCardsLabel": redCardsLabel,
        "statusLabel": statusLabel,
        "playersTitle": playersTitle,
        "teamLabel": teamLabel,
        "pointsLabel": pointsLabel,
        "victoriesLabel": victoriesLabel,
        "losesLabel": losesLabel,
        "tiesLabel": tiesLabel,
        "goalDifferenceLabel": goalDifferenceLabel,
        "roundLabel": roundLabel,
        "noRoundsMessage": noRoundsMessage,
        "noFixturesMessage": noFixturesMessage,
        "generateNextRoundButtonText": generateNextRoundButtonText,
        "resetTournamentButtonText": resetTournamentButtonText,
        "generateFixturesText": generateFixturesText,
        "numberOfTimesTeamsFaceEachOtherText":
            numberOfTimesTeamsFaceEachOtherText,
        "createFixtureButtonText": createFixtureButtonText,
        "matchDetailsTitle": matchDetailsTitle,
        "selectEventTitle": selectEventTitle,
        "selectTeamTitle": selectTeamTitle,
        "selectPlayerTitle": selectPlayerTitle,
        "banLengthTitle": banLengthTitle,
        "banLengthErrorMessage": banLengthErrorMessage,
        "banInputLabel": banInputLabel,
        "saveMatchDialogText": saveMatchDialogText,
        "dateErrorText": dateErrorText,
        "timeErrorText": timeErrorText,
        "teamsSortedByGoalsScoredTableTitle":
            teamsSortedByGoalsScoredTableTitle,
        "teamsSortedByGoalsConcededTableTitle":
            teamsSortedByGoalsConcededTableTitle,
        "playersSortedByGoalsScoredTableTitle":
            playersSortedByGoalsScoredTableTitle,
        "playersSortedByAssistsTableTitle": playersSortedByAssistsTableTitle,
        "playerLabel": playerLabel,
        "deleteTeamText": deleteTeamText,
        "editTeamTitle": editTeamTitle,
        "closeDialogText": closeDialogText,
        "playersButtonText": playersButtonText,
        "playersInTeamTitle": playersInTeamTitle,
        "noPlayersInTeamText": noPlayersInTeamText,
        "noPlayersAvaliableToSelect": noPlayersAvaliableToSelect,
        "uniqueNameError": uniqueNameError,
        "addTeamTitle": addTeamTitle,
        "deletePlayerText": deletePlayerText,
        "noTeamText": noTeamText,
        "editPlayerTitle": editPlayerTitle,
        "positionLabel": positionLabel,
        "createPlayerTitle": createPlayerTitle,
      };
}
