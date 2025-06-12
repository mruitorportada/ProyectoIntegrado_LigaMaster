import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/app_user.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:provider/provider.dart';

class PlayerEditionScreen extends StatefulWidget {
  final UserPlayer player;
  final AppUser user;
  const PlayerEditionScreen(
      {super.key, required this.player, required this.user});

  @override
  State<PlayerEditionScreen> createState() => _PlayerEditionScreenState();
}

class _PlayerEditionScreenState extends State<PlayerEditionScreen> {
  final _formKey = GlobalKey<FormState>();
  UserPlayer get _player => widget.player;
  AppUser get _user => widget.user;

  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late PlayerPosition _positionSelected;

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  void initState() {
    _nameController = TextEditingController(text: _player.name);
    _ratingController = TextEditingController(text: _player.rating.toString());
    _positionSelected = _player.position;
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
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _submitForm(
                  strings: strings,
                  toastColor: Theme.of(context).primaryColor,
                );
              },
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

  Widget _body(AppStrings strings) => PopScope(
        canPop: false,
        child: Form(
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
                initialValue: _player.currentTeamName ?? strings.noTeamText,
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
                initialValue: getSportLabel(strings, _player.sportPlayed),
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
                initialSelection: _player.position,
                entries: getPositionsBasedOnSportSelected(_player.sportPlayed)
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
        ),
      );

  void _updatePlayer() {
    _player.name = _nameController.value.text;
    _player.rating = double.parse(_ratingController.value.text);
    _player.position = _positionSelected;
  }

  void _submitForm(
      {required AppStrings strings, required Color toastColor}) async {
    if (_formKey.currentState!.validate()) {
      final uniqueName = !_user.players.any((userPlayer) =>
          userPlayer.name == _nameController.value.text &&
          userPlayer.id != _player.id);

      if (!uniqueName) {
        Fluttertoast.showToast(
            msg: strings.uniqueNameError, backgroundColor: toastColor);
        return;
      }

      _updatePlayer();
      Navigator.of(context).pop(true);
    }
  }
}
