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
        color: AppColors.secondaryColor,
      ),
      label: Text(labelText),
      menuStyle: MenuStyle(
        backgroundColor:
            WidgetStateProperty.resolveWith((_) => AppColors.secondaryColor),
      ),
      textStyle: TextStyle(color: AppColors.textColor),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.labeltextColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.textColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

ButtonStyle genericDropDownMenuEntryStyle() => MenuItemButton.styleFrom(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: AppColors.textColor,
    );
