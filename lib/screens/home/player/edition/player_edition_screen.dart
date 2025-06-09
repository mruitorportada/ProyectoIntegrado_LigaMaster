import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:provider/provider.dart';

class PlayerEditionScreen extends StatefulWidget {
  final UserPlayer player;
  const PlayerEditionScreen({super.key, required this.player});

  @override
  State<PlayerEditionScreen> createState() => _PlayerEditionScreenState();
}

class _PlayerEditionScreenState extends State<PlayerEditionScreen> {
  final _formKey = GlobalKey<FormState>();
  UserPlayer get player => widget.player;
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late PlayerPosition _positionSelected;

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  void initState() {
    _nameController = TextEditingController(text: player.name);
    _ratingController = TextEditingController(text: player.rating.toString());
    _positionSelected = player.position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<AppStringsController>(context, listen: false);
    final strings = controller.strings!;

    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          context,
          strings.editPlayerTitle,
          [
            IconButton(
              onPressed: () => submitForm(),
              icon: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        body: _body(strings),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  Widget _body(AppStrings strings) => Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: _textColor),
              validator: (value) {
                String? nameErrorMessage = nameValidator(value);
                return nameErrorMessage != null
                    ? getLocalizedNameErrorMessage(strings)
                    : null;
              },
              decoration: InputDecoration(
                labelText: strings.nameLabel,
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: player.currentTeamName ?? strings.noTeamText,
              style: TextStyle(color: _textColor),
              readOnly: true,
              decoration: InputDecoration(
                labelText: strings.teamLabel,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _ratingController,
              style: TextStyle(color: _textColor),
              validator: (value) {
                String? errorMessage = ratingValidator(value);
                return getLocalizedRatingErrorMessage(strings, errorMessage);
              },
              decoration: InputDecoration(
                labelText: strings.ratingLabel,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: getSportLabel(strings, player.sportPlayed),
              style: TextStyle(color: _textColor),
              readOnly: true,
              decoration: InputDecoration(
                labelText: strings.sportLabel,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            genericDropDownMenu(
              context,
              initialSelection: player.position,
              entries: getPositionsBasedOnSportSelected(player.sportPlayed)
                  .map(
                    (pos) => DropdownMenuEntry(
                      value: pos,
                      label: getPlayerPositionLabel(strings, pos),
                      style: genericDropDownMenuEntryStyle(
                        context,
                      ),
                    ),
                  )
                  .toList(),
              onSelected: (value) => setState(
                () {
                  _positionSelected = value;
                },
              ),
              labelText: strings.positionLabel,
            )
          ],
        ),
      );

  void updatePlayer() {
    player.name = _nameController.value.text;
    player.rating = double.parse(_ratingController.value.text);
    player.position = _positionSelected;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      updatePlayer();
      Navigator.of(context).pop(true);
    }
  }
}
