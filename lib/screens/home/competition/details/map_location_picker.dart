import 'package:flutter/material.dart';
import 'package:liga_master/models/appstrings/appstrings_controller.dart';
import 'package:liga_master/models/match/sport_match.dart';
import 'package:liga_master/screens/generic/appcolors.dart';
import 'package:liga_master/screens/generic/generic_widgets/myappbar.dart';
import 'package:liga_master/screens/home/competition/details/competition_details_viewmodel.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MatchLocationPicker extends StatefulWidget {
  final CompetitionDetailsViewmodel viewModel;
  final SportMatch match;
  const MatchLocationPicker(
      {super.key, required this.match, required this.viewModel});

  @override
  State<MatchLocationPicker> createState() => _MatchLocationPickerState();
}

class _MatchLocationPickerState extends State<MatchLocationPicker> {
  final Color _textColor = LightThemeAppColors.textColor;
  CompetitionDetailsViewmodel get _viewmodel => widget.viewModel;
  SportMatch get _match => widget.match;

  bool locationPermissionGranted = false;

  @override
  void initState() {
    _checkLocationStatus().then((value) {
      locationPermissionGranted = value;
    });
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
          strings.locationPickerAppBarTitle,
          [],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: PopScope(
          canPop: false,
          child: FlutterLocationPicker(
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            trackMyPosition: locationPermissionGranted,
            selectLocationButtonText: strings.locationPickerButtonText,
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
            mapLoadingBackgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
            markerIcon: Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.secondary,
              size: 32,
            ),
            onPicked: (pickedAddress) {
              _viewmodel.updateMatchLocation(_match, pickedAddress, context);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _checkLocationStatus() async =>
      await Permission.location.isGranted;
}
