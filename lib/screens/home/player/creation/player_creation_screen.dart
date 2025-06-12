import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liga_master/models/appstrings/appstrings.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/enums.dart';
import 'package:liga_master/models/user/entities/user_player.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/functions.dart';
import 'package:liga_master/screens/generic/generic_widgets/generic_dropdownmenu.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/services/player_service.dart';
import 'package:provider/provider.dart';

class PlayerCreationScreen extends StatefulWidget {
  final UserPlayer player;
  final String userId;
  const PlayerCreationScreen(
      {super.key, required this.player, required this.userId});

  @override
  State<PlayerCreationScreen> createState() => _PlayerCreationScreenState();
}

class _PlayerCreationScreenState extends State<PlayerCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  UserPlayer get _player => widget.player;
  String get _userId => widget.userId;

  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  Sport _sportSelected = Sport.football;
  PlayerPosition _positionSelected = FootballPlayerPosition.portero;

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  void initState() {
    _nameController = TextEditingController(text: _player.name);
    _ratingController = TextEditingController(text: _player.rating.toString());
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
          strings.createPlayerTitle,
          [
            IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _submitForm(
                    strings: strings,
                    toastColor: Theme.of(context).primaryColor);
              },
              icon: Icon(
                Icons.check,
              ),
            )
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: _body(strings),
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
              genericDropDownMenu(
                context,
                initialSelection: _sportSelected,
                entries: Sport.values
                    .map(
                      (e) => DropdownMenuEntry(
                        value: e,
                        label: getSportLabel(strings, e),
                        style: genericDropDownMenuEntryStyle(context),
                      ),
                    )
                    .toList(),
                onSelected: (value) => setState(
                  () {
                    _sportSelected = value!;
                    _positionSelected =
                        getFirstPositionBasedOnSportSelected(_sportSelected);
                  },
                ),
                labelText: strings.sportLabel,
              ),
              SizedBox(
                height: 20,
              ),
              genericDropDownMenu(
                context,
                initialSelection:
                    getFirstPositionBasedOnSportSelected(_sportSelected),
                entries: getPositionsBasedOnSportSelected(_sportSelected)
                    .map(
                      (pos) => DropdownMenuEntry(
                        value: pos,
                        label: getPlayerPositionLabel(strings, pos),
                        style: genericDropDownMenuEntryStyle(context),
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
    _player.name = _nameController.value.text.trim();
    _player.rating = double.parse(_ratingController.value.text);
    _player.sportPlayed = _sportSelected;
    _player.position = _positionSelected;
  }

  void _submitForm(
      {required AppStrings strings, required Color toastColor}) async {
    if (_formKey.currentState!.validate()) {
      final playerService = Provider.of<PlayerService>(context, listen: false);

      final uniqueName = await playerService.checkPlayerNameIsUnique(
          _nameController.value.text.trim(), _userId);

      if (!uniqueName) {
        Fluttertoast.showToast(
            msg: strings.uniqueNameError, backgroundColor: toastColor);
        return;
      }

      _updatePlayer();
      if (mounted) Navigator.of(context).pop(true);
    }
  }
}
