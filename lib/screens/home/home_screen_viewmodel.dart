import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/competition/competition.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/home/competition/creation/competition_creation_screen.dart';
import 'package:liga_master/screens/home/player/creation/player_creation_screen.dart';
import 'package:liga_master/screens/home/player/edition/player_edition_screen.dart';
import 'package:liga_master/screens/home/team/creation/team_creation_screen.dart';
import 'package:liga_master/screens/home/team/edition/team_edition_screen.dart';
import 'package:liga_master/services/appstrings_service.dart';
import 'package:liga_master/services/competition_service.dart';
import 'package:liga_master/services/player_service.dart';
import 'package:liga_master/services/team_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenViewmodel extends ChangeNotifier {
  AppUser _user;
  AppUser get user => _user;
  set user(AppUser value) {
    _user = value;
    notifyListeners();
  }

  List<Competition> get competitions => _user.competitions;

  List<UserTeam> get teams => _user.teams;

  List<UserPlayer> get players => _user.players;

  StreamSubscription<List<UserPlayer>>? _playersSubscription;

  StreamSubscription<List<UserTeam>>? _teamsSubscription;

  StreamSubscription<List<Competition>>? _competitionsSubscription;

  String _resultMessage = "";
  String get resultMessage => _resultMessage;
  set resultMessage(String value) {
    _resultMessage = value;
    notifyListeners();
  }

  HomeScreenViewmodel(this._user);

  void onCreateCompetition(
    BuildContext context,
  ) async {
    var competitionService =
        Provider.of<CompetitionService>(context, listen: false);
    var competition = Competition(id: "");
    bool? save = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CompetitionCreationScreen(
          competition: competition,
          teams: teams,
        ),
      ),
    );

    if (save ?? false) {
      competition.creator = _user;
      _addCompetition(competitionService, competition);
    }
  }

  void onDeleteCompetition(BuildContext context, Competition competition) {
    var competitionService =
        Provider.of<CompetitionService>(context, listen: false);
    competitionService.deleteCompetition(competition, _user.id, () {
      _loadUserCompetitions(competitionService);
    });
  }

  void onCreateTeam(BuildContext context) async {
    int num = 1;
    String id = "T$num";
    bool found = false;

    while (!found) {
      if (!teams.any((team) => team.id == id)) {
        found = true;
      } else {
        num++;
      }
      id = "T$num";
    }
    onEditTeam(context, UserTeam(id: id), isNew: true);
  }

  void onEditTeam(BuildContext context, UserTeam team,
      {bool isNew = false}) async {
    TeamService teamService = Provider.of<TeamService>(context, listen: false);

    bool? save = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isNew
            ? TeamCreationScreen(
                team: team,
                userId: _user.id,
              )
            : TeamEditionScreen(
                team: team,
                players: List.from(players
                    .where((player) =>
                        player.currentTeamName == null &&
                        player.sportPlayed == team.sportPlayed)
                    .toList()),
                user: _user,
              ),
      ),
    );

    if (save ?? false) {
      await teamService.saveTeam(team, _user.id);
    }
  }

  void onDeleteTeam(BuildContext context, UserTeam team) {
    TeamService teamService = Provider.of<TeamService>(context, listen: false);
    teamService.deleteTeam(team, _user.id);
  }

  void onCreatePlayer(BuildContext context) async {
    int num = 1;
    String id = "P$num";
    bool found = false;

    while (!found) {
      if (!players.any((player) => player.id == id)) {
        found = true;
      } else {
        num++;
      }
      id = "P$num";
    }
    onEditPlayer(context, UserPlayer(id: id), isNew: true);
  }

  void onEditPlayer(BuildContext context, UserPlayer player,
      {bool isNew = false}) async {
    PlayerService playerService =
        Provider.of<PlayerService>(context, listen: false);
    bool? save = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => isNew
            ? PlayerCreationScreen(
                player: player,
                userId: _user.id,
              )
            : PlayerEditionScreen(
                player: player,
                user: _user,
              ),
      ),
    );

    if (save ?? false) {
      await playerService.savePlayer(player, _user.id);
    }
  }

  void onDeletePlayer(BuildContext context, UserPlayer player) {
    PlayerService playerService =
        Provider.of<PlayerService>(context, listen: false);
    TeamService teamService = Provider.of<TeamService>(context, listen: false);
    for (UserTeam team in teams) {
      var ids =
          team.players.map((playerFromList) => playerFromList.id).toList();
      if (ids.contains(player.id)) {
        team.players.remove(player);
        teamService.saveTeam(team, _user.id);
      }
    }
    playerService.deletePlayer(player.id, _user.id);
  }

  Future<void> loadUserData(BuildContext context) async {
    final compService = Provider.of<CompetitionService>(context, listen: false);
    final teamService = Provider.of<TeamService>(context, listen: false);
    final playerService = Provider.of<PlayerService>(context, listen: false);
    final appStringsService =
        Provider.of<AppStringsService>(context, listen: false);
    final strings = await appStringsService
        .getAppStringsFromFirestore(Platform.localeName.split("_").first);

    _playersSubscription?.cancel();
    _teamsSubscription?.cancel();
    _competitionsSubscription?.cancel();

    try {
      Fluttertoast.showToast(
          msg: strings!.loadingDataMessage,
          backgroundColor: Colors.blueGrey,
          textColor: LightThemeAppColors.textColor);

      await Future.wait([
        _loadUserPlayersAndTeam(playerService, teamService),
        _loadUserCompetitions(compService),
        _getProfilePicture(),
      ]);

      Fluttertoast.showToast(
          msg: strings.dataLoadedMessage,
          backgroundColor: Colors.blueGrey,
          textColor: LightThemeAppColors.textColor);
    } on FirebaseException catch (e, _) {
      Fluttertoast.showToast(
          msg: strings!.dataLoadErrorMessage,
          backgroundColor: Colors.red,
          textColor: LightThemeAppColors.textColor);
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadUserPlayersAndTeam(
      PlayerService playerService, TeamService teamService) async {
    _playersSubscription =
        playerService.getPlayers(_user.id).listen((playersFirebase) {
      _user.players = playersFirebase;
      notifyListeners();

      _teamsSubscription = teamService
          .getTeams(userId: _user.id, allPlayers: playersFirebase)
          .listen((teamsFirebase) {
        _user.teams = teamsFirebase;
        notifyListeners();
      });
    });
  }

  Future<void> _loadUserCompetitions(CompetitionService compService) async {
    _competitionsSubscription = compService
        .getCompetitions(userId: _user.id)
        .listen((competitionsFirebase) {
      _user.competitions = competitionsFirebase;
      notifyListeners();
    });
  }

  void _addCompetition(
      CompetitionService compService, Competition competition) {
    compService.saveCompetition(competition, _user.id, () {
      _loadUserCompetitions(compService);
    });
  }

  void addCompetitionByCode(BuildContext context, String code,
      {required Color toastColor}) async {
    final compService = Provider.of<CompetitionService>(context, listen: false);
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    _resultMessage = await compService.addCompetitionToUserByCode(
        code: code,
        userId: _user.id,
        successMessage: strings.successMessage,
        errorMessage: strings.errorMessage,
        onCompetitionsUpdated: () {
          _loadUserCompetitions(compService);
        });

    Fluttertoast.showToast(
        msg: _resultMessage,
        backgroundColor: toastColor,
        textColor: LightThemeAppColors.textColor);
  }

  void onLogOut() => _reset();

  void _reset() {
    _playersSubscription?.cancel();
    _teamsSubscription?.cancel();
    _competitionsSubscription?.cancel();

    _playersSubscription = null;
    _teamsSubscription = null;
    _competitionsSubscription = null;

    _user = AppUser.empty();
  }

  Future<void> saveProfilePicture(File image) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory dir = Directory("${appDir.path}/profile_pictures");

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final fileName = "profile_${DateTime.now().millisecondsSinceEpoch}.png";
    final newPath = "${dir.path}/$fileName";

    final File savedImage = await image.copy(newPath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile_picture_${_user.id}", savedImage.path);
  }

  Future<void> _getProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    _user.image = prefs.getString("profile_picture_${_user.id}");
  }
}
