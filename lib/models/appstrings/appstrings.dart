class AppStrings {
  // ------ Login Screen ------
  final String loginButton;
  final String loginText;
  final String resetPasswordText;
  final String resetPasswordEmail;
  final String emailLabel;
  final String passwordLabel;
  final String emailNotFoundText;

  // ------ Sign up Screen -----
  final String registerButton;
  final String registerText;
  final String nameLabel;
  final String surnameLabel;
  final String usernameLabel;
  final String usernameTakenMessage;
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
  final String loadingDataMessage;
  final String dataLoadedMessage;
  final String dataLoadErrorMessage;

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
  final String noCompetitionsMessage;

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
  final String fixtureLabel;
  final String noRoundsMessage;
  final String matchTieInTournamentError;

  final String noFixturesMessage;
  final String generateNextRoundButtonText;
  final String resetTournamentButtonText;
  final String generateFixturesText;
  final String numberOfTimesTeamsFaceEachOtherText;
  final String timesErrorMessage;
  final String matchSavedMessage;
  final String matchNotSavedMessage;
  final String roundErrorMessage;
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
  final String noTeamsText;

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
  final String noPlayersText;

  // ------ Player Edition Screen -----
  final String editPlayerTitle;
  final String positionLabel;

  // ------ Player Creation Screen -----
  final String createPlayerTitle;

  // ------ Other -----
  final String footballSportName;
  final String futsalSportName;

  final String goalKeeperPositionName;
  final String footballDefenderPositionName;
  final String footballMidfielderPositionName;
  final String footballStrikerPositionName;

  final String futsalDefenderPositionName;
  final String futsalMidfielderPositionName;
  final String futsalStrikerPositionName;

  final String goalEventName;
  final String assistEventName;
  final String yellowCardEventName;
  final String redCardEventName;
  final String injuryEventName;

  final String availableStatusText;
  final String injuredStatusText;
  final String bannedStatusText;

  final String tournamentFormatLabel;
  final String leagueFormatLabel;

  final String round64Label;
  final String round32Label;
  final String round16Label;
  final String round8Label;
  final String round4Label;
  final String round2Label;

  // ------ FormErrorMessages -----
  final String emptyNameErrorMessage;
  final String ratingFormatErrorMessage;
  final String ratingLengthErrorMessage;
  final String ratingValueErrorMessage;

  // ------ FirebaseErrorMessages -----
  final String emailAlreadyUsedErrorMessage;
  final String invalidEmailErrorMessage;
  final String userDisabledErrorMessage;
  final String userNotFoundErrorMessage;
  final String wrongPasswordErrorMessage;
  final String tooManyRequestsErrorMessage;
  final String userTokenExpiredErrorMessage;
  final String networkRequestFailedErrorMessage;
  final String invalidCredentialErrorMessage;
  final String operationNotAllowedErrorMessage;
  final String unknownErrorErrorMessage;

  // ------ LocationPickerScreen -----
  final String locationPickerAppBarTitle;
  final String locationPickerButtonText;

  AppStrings({
    required this.loginButton,
    required this.loginText,
    required this.resetPasswordText,
    required this.resetPasswordEmail,
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
    required this.fixtureLabel,
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
    required this.footballSportName,
    required this.futsalSportName,
    required this.goalKeeperPositionName,
    required this.footballDefenderPositionName,
    required this.footballMidfielderPositionName,
    required this.footballStrikerPositionName,
    required this.futsalDefenderPositionName,
    required this.futsalMidfielderPositionName,
    required this.futsalStrikerPositionName,
    required this.goalEventName,
    required this.assistEventName,
    required this.yellowCardEventName,
    required this.redCardEventName,
    required this.injuryEventName,
    required this.availableStatusText,
    required this.injuredStatusText,
    required this.bannedStatusText,
    required this.tournamentFormatLabel,
    required this.leagueFormatLabel,
    required this.round64Label,
    required this.round32Label,
    required this.round16Label,
    required this.round8Label,
    required this.round4Label,
    required this.round2Label,
    required this.matchTieInTournamentError,
    required this.emptyNameErrorMessage,
    required this.ratingFormatErrorMessage,
    required this.ratingLengthErrorMessage,
    required this.ratingValueErrorMessage,
    required this.emailAlreadyUsedErrorMessage,
    required this.invalidEmailErrorMessage,
    required this.userDisabledErrorMessage,
    required this.userNotFoundErrorMessage,
    required this.wrongPasswordErrorMessage,
    required this.tooManyRequestsErrorMessage,
    required this.userTokenExpiredErrorMessage,
    required this.invalidCredentialErrorMessage,
    required this.operationNotAllowedErrorMessage,
    required this.unknownErrorErrorMessage,
    required this.networkRequestFailedErrorMessage,
    required this.locationPickerAppBarTitle,
    required this.locationPickerButtonText,
    required this.timesErrorMessage,
    required this.matchSavedMessage,
    required this.matchNotSavedMessage,
    required this.roundErrorMessage,
    required this.usernameTakenMessage,
    required this.noCompetitionsMessage,
    required this.noPlayersText,
    required this.noTeamsText,
    required this.loadingDataMessage,
    required this.dataLoadedMessage,
    required this.dataLoadErrorMessage,
  });

  factory AppStrings.fromMap(Map<String, dynamic> map) => AppStrings(
        loginButton: map["loginButton"] ?? "",
        loginText: map["loginText"] ?? "",
        resetPasswordEmail: map["resetPasswordEmail"] ?? "",
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
        fixtureLabel: map["fixtureLabel"] ?? "",
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
        footballSportName: map["footballSportName"] ?? "",
        futsalSportName: map["futsalSportName"] ?? "",
        goalKeeperPositionName: map["goalKeeperPositionName"] ?? "",
        footballDefenderPositionName: map["footballDefenderPositionName"] ?? "",
        footballMidfielderPositionName:
            map["footballMidfielderPositionName"] ?? "",
        footballStrikerPositionName: map["footballStrikerPositionName"] ?? "",
        futsalDefenderPositionName: map["futsalDefenderPositionName"] ?? "",
        futsalMidfielderPositionName: map["futsalMidfielderPositionName"] ?? "",
        futsalStrikerPositionName: map["futsalStrikerPositionName"] ?? "",
        goalEventName: map["goalEventName"] ?? "",
        assistEventName: map["assistEventName"] ?? "",
        yellowCardEventName: map["yellowCardEventName"] ?? "",
        redCardEventName: map["redCardEventName"] ?? "",
        injuryEventName: map["injuryEventName"] ?? "",
        availableStatusText: map["availableStatusText"] ?? "",
        injuredStatusText: map["injuredStatusText"] ?? "",
        bannedStatusText: map["bannedStatusText"] ?? "",
        tournamentFormatLabel: map["tournamentFormatLabel"] ?? "",
        leagueFormatLabel: map["leagueFormatLabel"] ?? "",
        round64Label: map["round64Label"] ?? "",
        round32Label: map["round32Label"] ?? "",
        round16Label: map["round16Label"] ?? "",
        round8Label: map["round8Label"] ?? "",
        round4Label: map["round4Label"] ?? "",
        round2Label: map["round2Label"] ?? "",
        matchTieInTournamentError: map["matchTieInTournamentError"] ?? "",
        emptyNameErrorMessage: map["emptyNameErrorMessage"] ?? "",
        ratingFormatErrorMessage: map["ratingFormatErrorMessage"] ?? "",
        ratingLengthErrorMessage: map["ratingLengthErrorMessage"] ?? "",
        ratingValueErrorMessage: map["ratingValueErrorMessage"] ?? "",
        emailAlreadyUsedErrorMessage: map["emailAlreadyUsedErrorMessage"] ?? "",
        invalidEmailErrorMessage: map["invalidEmailErrorMessage"] ?? "",
        userDisabledErrorMessage: map["userDisabledErrorMessage"] ?? "",
        userNotFoundErrorMessage: map["userNotFoundErrorMessage"] ?? "",
        wrongPasswordErrorMessage: map["wrongPasswordErrorMessage"] ?? "",
        tooManyRequestsErrorMessage: map["tooManyRequestsErrorMessage"] ?? "",
        userTokenExpiredErrorMessage: map["userTokenExpiredErrorMessage"] ?? "",
        invalidCredentialErrorMessage:
            map["invalidCredentialErrorMessage"] ?? "",
        operationNotAllowedErrorMessage:
            map["operationNotAllowedErrorMessage"] ?? "",
        unknownErrorErrorMessage: map["unknownErrorErrorMessage"] ?? "",
        networkRequestFailedErrorMessage:
            map["networkRequestFailedErrorMessage"] ?? "",
        locationPickerAppBarTitle: map["locationPickerAppBarTitle"] ?? "",
        locationPickerButtonText: map["locationPickerButtonText"] ?? "",
        timesErrorMessage: map["timesErrorMessage"] ?? "",
        matchSavedMessage: map["matchSavedMessage"] ?? "",
        matchNotSavedMessage: map["matchNotSavedMessage"] ?? "",
        roundErrorMessage: map["roundErrorMessage"] ?? "",
        usernameTakenMessage: map["usernameTakenMessage"] ?? "",
        noCompetitionsMessage: map["noCompetitionsMessage"] ?? "",
        noPlayersText: map["noPlayersText"] ?? "",
        noTeamsText: map["noTeamsText"] ?? "",
        loadingDataMessage: map["loadingDataMessage"] ?? "",
        dataLoadedMessage: map["dataLoadedMessage"] ?? "",
        dataLoadErrorMessage: map["dataLoadErrorMessage"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "loginButton": loginButton,
        "loginText": loginText,
        "resetPasswordEmail": resetPasswordEmail,
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
        "fixtureLabel": fixtureLabel,
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
        "footballSportName": footballSportName,
        "futsalSportName": futsalSportName,
        "goalKeeperPositionName": goalKeeperPositionName,
        "footballDefenderPositionName": footballDefenderPositionName,
        "footballMidfielderPositionName": footballMidfielderPositionName,
        "footballStrikerPositionName": footballStrikerPositionName,
        "futsalDefenderPositionName": futsalDefenderPositionName,
        "futsalMidfielderPositionName": futsalMidfielderPositionName,
        "futsalStrikerPositionName": futsalStrikerPositionName,
        "goalEventName": goalEventName,
        "assistEventName": assistEventName,
        "yellowCardEventName": yellowCardEventName,
        "redCardEventName": redCardEventName,
        "injuryEventName": injuryEventName,
        "availableStatusText": availableStatusText,
        "injuredStatusText": injuredStatusText,
        "bannedStatusText": bannedStatusText,
        "tournamentFormatLabel": tournamentFormatLabel,
        "leagueFormatLabel": leagueFormatLabel,
        "round64Label": round64Label,
        "round32Label": round32Label,
        "round16Label": round16Label,
        "round8Label": round8Label,
        "round4Label": round4Label,
        "round2Label": round2Label,
        "matchTieInTournamentError": matchTieInTournamentError,
        "emptyNameErrorMessage": emptyNameErrorMessage,
        "ratingFormatErrorMessage": ratingFormatErrorMessage,
        "ratingLengthErrorMessage": ratingLengthErrorMessage,
        "ratingValueErrorMessage": ratingValueErrorMessage,
        "emailAlreadyUsedErrorMessage": emailAlreadyUsedErrorMessage,
        "invalidEmailErrorMessage": invalidEmailErrorMessage,
        "userDisabledErrorMessage": userDisabledErrorMessage,
        "userNotFoundErrorMessage": userNotFoundErrorMessage,
        "wrongPasswordErrorMessage": wrongPasswordErrorMessage,
        "tooManyRequestsErrorMessage": tooManyRequestsErrorMessage,
        "userTokenExpiredErrorMessage": userTokenExpiredErrorMessage,
        "invalidCredentialErrorMessage": invalidCredentialErrorMessage,
        "operationNotAllowedErrorMessage": operationNotAllowedErrorMessage,
        "unknownErrorErrorMessage": unknownErrorErrorMessage,
        "networkRequestFailedErrorMessage": networkRequestFailedErrorMessage,
        "locationPickerAppBarTitle": locationPickerAppBarTitle,
        "locationPickerButtonText": locationPickerButtonText,
        "timesErrorMessage": timesErrorMessage,
        "matchSavedMessage": matchSavedMessage,
        "matchNotSavedMessage": matchNotSavedMessage,
        "roundErrorMessage": roundErrorMessage,
        "usernameTakenMessage": usernameTakenMessage,
        "noCompetitionsMessage": noCompetitionsMessage,
        "noPlayersText": noPlayersText,
        "noTeamsText": noTeamsText,
        "loadingDataMessage": loadingDataMessage,
        "dataLoadedMessage": dataLoadedMessage,
        "dataLoadErrorMessage": dataLoadErrorMessage,
      };
}
