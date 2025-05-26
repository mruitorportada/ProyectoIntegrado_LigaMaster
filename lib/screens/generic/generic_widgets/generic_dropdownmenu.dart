import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

DropdownMenu genericDropDownMenu(BuildContext context,
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
        color: Theme.of(context).colorScheme.secondary,
      ),
      label: Text(labelText),
    );

ButtonStyle genericDropDownMenuEntryStyle(BuildContext context) =>
    MenuItemButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: LightThemeAppColors.textColor,
    );
