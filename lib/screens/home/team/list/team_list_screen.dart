import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/user/entities/user_team.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_card.dart';
import 'package:liga_master/screens/generic/generic_widgets/simple_alert_dialog.dart';
import 'package:liga_master/screens/home/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamListScreen extends StatelessWidget {
  final HomeScreenViewmodel homeScreenViewModel;
  const TeamListScreen({super.key, required this.homeScreenViewModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body,
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  Widget get _body => teamList();

  ListenableBuilder teamList() => ListenableBuilder(
        listenable: homeScreenViewModel,
        builder: (context, _) => ListView.builder(
          itemCount: homeScreenViewModel.teams.length,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemBuilder: (context, index) => ListenableBuilder(
            listenable: homeScreenViewModel.teams[index],
            builder: (context, _) => teamItem(
                homeScreenViewModel.teams[index],
                context,
                homeScreenViewModel.onEditTeam,
                homeScreenViewModel.onDeleteTeam),
          ),
        ),
      );

  Widget teamItem(
          UserTeam team,
          BuildContext context,
          void Function(BuildContext, UserTeam, {bool isNew}) goToEdit,
          void Function(BuildContext, UserTeam team) deleteTeam) =>
      GestureDetector(
        onTap: () => goToEdit(context, team, isNew: false),
        onLongPress: () => showDeleteDialog(context, deleteTeam, team),
        child: genericCard(
          title: team.name,
          subtitle: team.sportPlayed.name,
          trailIcon: Icons.sports_soccer_outlined,
        ),
      );

  FloatingActionButton _floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () => homeScreenViewModel.onCreateTeam(context),
        child: Icon(Icons.add),
      );

  void showDeleteDialog(
      BuildContext context,
      void Function(BuildContext context, UserTeam team) deleteTeam,
      UserTeam team) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    showDialog(
      context: context,
      builder: (context) => simpleAlertDialog(
        context,
        title: strings.deleteItemDialogTitle,
        message: strings.deleteTeamText,
        actions: [
          TextButton(
            onPressed: () =>
                {deleteTeam(context, team), Navigator.of(context).pop()},
            child: Text(
              strings.acceptDialogButtonText,
              style: TextStyle(color: LightThemeAppColors.error),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              strings.cancelTextButton,
              style: TextStyle(color: LightThemeAppColors.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
