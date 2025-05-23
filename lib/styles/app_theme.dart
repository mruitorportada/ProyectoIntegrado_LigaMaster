import 'package:flutter/material.dart';
import 'package:liga_master/screens/generic/appcolors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: LightThemeAppColors.background,
        primaryColor: LightThemeAppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: LightThemeAppColors.primaryColor,
          primary: LightThemeAppColors.primaryColor,
          secondary: LightThemeAppColors.secondaryColor,
          surface: LightThemeAppColors.background,
          error: LightThemeAppColors.error,
          onPrimary: LightThemeAppColors.primaryColor,
          onSecondary: LightThemeAppColors.textColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: LightThemeAppColors.background,
          foregroundColor: LightThemeAppColors.textColor,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateColor.resolveWith(
              (_) => LightThemeAppColors.textColor,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: LightThemeAppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        listTileTheme: ListTileThemeData(
          titleTextStyle:
              TextStyle(fontSize: 16, color: LightThemeAppColors.textColor),
          subtitleTextStyle: TextStyle(
            color: LightThemeAppColors.subtextColor,
            fontWeight: FontWeight.w600,
          ),
          iconColor: LightThemeAppColors.secondaryColor,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: LightThemeAppColors.primaryColor,
          indicatorColor: LightThemeAppColors.secondaryColor,
          labelTextStyle: WidgetStateTextStyle.resolveWith(
            (_) => TextStyle(
              color: LightThemeAppColors.textColor,
            ),
          ),
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: LightThemeAppColors.textColor),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStateColor.resolveWith(
              (_) => LightThemeAppColors.secondaryColor,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: LightThemeAppColors.textColor,
          backgroundColor: LightThemeAppColors.secondaryColor,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: LightThemeAppColors.background,
          titleTextStyle: TextStyle(
            color: LightThemeAppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          contentTextStyle: TextStyle(
            color: LightThemeAppColors.subtextColor,
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (_) => LightThemeAppColors.buttonColor,
            ),
            foregroundColor: WidgetStateColor.resolveWith(
              (_) => LightThemeAppColors.textColor,
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: LightThemeAppColors.textColor),
          bodyMedium: TextStyle(
              color: LightThemeAppColors.subtextColor,
              fontWeight: FontWeight.bold),
          bodySmall: TextStyle(
            color: LightThemeAppColors.subtextColor,
          ),
          titleLarge: TextStyle(color: LightThemeAppColors.textColor),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateColor.resolveWith(
            (_) => LightThemeAppColors.textColor,
          ),
          side: BorderSide(
            color: LightThemeAppColors.secondaryColor,
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
                (_) => LightThemeAppColors.secondaryColor),
          ),
          textStyle: TextStyle(color: LightThemeAppColors.textColor),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: LightThemeAppColors.labeltextColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: LightThemeAppColors.textColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: LightThemeAppColors.subtextColor,
            fontWeight: FontWeight.w900,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: LightThemeAppColors.textColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: LightThemeAppColors.textColor),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: LightThemeAppColors.primaryColor,
          filled: true,
        ),
        useMaterial3: true,
      );
}
