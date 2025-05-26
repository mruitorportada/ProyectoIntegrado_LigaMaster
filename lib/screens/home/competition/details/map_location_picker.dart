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

  final Color _textColor = LightThemeAppColors.textColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar(
          context,
          "Selecciona una ubicación",
          [],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).scaffoldBackgroundColor,
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
              (_) => Theme.of(context).colorScheme.secondary,
            ),
            foregroundColor: WidgetStateColor.resolveWith((_) => _textColor),
          ),
          onChanged: (pickedData) => {},
          zoomButtonsBackgroundColor: Theme.of(context).colorScheme.secondary,
          zoomButtonsColor: _textColor,
          locationButtonBackgroundColor:
              Theme.of(context).colorScheme.secondary,
          locationButtonsColor: _textColor,
          mapLoadingBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          markerIcon: Icon(
            Icons.location_on,
            color: Theme.of(context).colorScheme.secondary,
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
