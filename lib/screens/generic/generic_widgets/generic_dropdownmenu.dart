import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

DropdownMenu genericDropDownMenu(
        {required String labelText,
        required dynamic initialSelection,
        required List<DropdownMenuEntry<dynamic>> entries,
        required void Function(dynamic) onSelected}) =>
    DropdownMenu(
      initialSelection: initialSelection,
      dropdownMenuEntries: entries,
      onSelected: onSelected,
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        color: LightThemeAppColors.secondaryColor,
      ),
      label: Text(labelText),
    );

ButtonStyle genericDropDownMenuEntryStyle() => MenuItemButton.styleFrom(
      backgroundColor: LightThemeAppColors.secondaryColor,
      foregroundColor: LightThemeAppColors.textColor,
    );
