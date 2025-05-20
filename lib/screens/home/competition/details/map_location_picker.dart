import 'package:flutter/material.dart';
import 'package:liga_master/models/match/sport_match.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class MatchLocationPicker extends StatelessWidget {
  final CompetitionDetailsViewmodel viewModel;
  final SportMatch match;
  const MatchLocationPicker(
      {super.key, required this.match, required this.viewModel});

  final Color _buttonBackground = AppColors.accent;
  final Color _appBarBackground = AppColors.background;
  final Color _textColor = AppColors.text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          "Selecciona una ubicación",
          _appBarBackground,
          [],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: _buttonBackground,
            ),
          ),
        ),
        body: FlutterLocationPicker(
          initZoom: 11,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          trackMyPosition: true,
          selectLocationButtonText: "Seleccionar ubicación actual",
          selectLocationButtonStyle: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (_) => _buttonBackground,
            ),
            foregroundColor: WidgetStateColor.resolveWith((_) => _textColor),
          ),
          onChanged: (pickedData) => {},
          zoomButtonsBackgroundColor: _buttonBackground,
          zoomButtonsColor: _textColor,
          locationButtonBackgroundColor: _buttonBackground,
          locationButtonsColor: _textColor,
          mapLoadingBackgroundColor: _appBarBackground,
          markerIcon: Icon(
            Icons.location_on,
            color: _buttonBackground,
            size: 32,
          ),
          onPicked: (pickedAddress) {
            viewModel.updateMatchLocation(match, pickedAddress, context);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
