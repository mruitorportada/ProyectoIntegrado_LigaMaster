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
        dividerColor: LightThemeAppColors.buttonColor,
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
        datePickerTheme: DatePickerThemeData(
          backgroundColor: LightThemeAppColors.background,
          headerForegroundColor: LightThemeAppColors.textColor,
          dividerColor: LightThemeAppColors.textColor,
          yearForegroundColor: WidgetStateColor.resolveWith(
            (_) => LightThemeAppColors.textColor,
          ),
          yearBackgroundColor: WidgetStateColor.resolveWith(
            (_) => LightThemeAppColors.primaryColor,
          ),
          yearOverlayColor: WidgetStateColor.resolveWith(
            (_) => LightThemeAppColors.secondaryColor,
          ),
          dayForegroundColor: WidgetStateColor.resolveWith(
              (_) => LightThemeAppColors.textColor),
          weekdayStyle: TextStyle(color: LightThemeAppColors.secondaryColor),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: LightThemeAppColors.background,
          helpTextStyle: TextStyle(
            color: LightThemeAppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
          hourMinuteTextColor: LightThemeAppColors.textColor,
          hourMinuteColor: LightThemeAppColors.primaryColor,
        ),
        useMaterial3: true,
      );

  static ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: DarkThemeAppColors.background,
        primaryColor: DarkThemeAppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DarkThemeAppColors.primaryColor,
          primary: DarkThemeAppColors.primaryColor,
          secondary: DarkThemeAppColors.secondaryColor,
          surface: DarkThemeAppColors.background,
          error: DarkThemeAppColors.error,
          onPrimary: DarkThemeAppColors.primaryColor,
          onSecondary: DarkThemeAppColors.textColor,
        ),
        dividerColor: DarkThemeAppColors.buttonColor,
        appBarTheme: AppBarTheme(
          backgroundColor: DarkThemeAppColors.background,
          foregroundColor: DarkThemeAppColors.textColor,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateColor.resolveWith(
              (_) => DarkThemeAppColors.textColor,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: DarkThemeAppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        listTileTheme: ListTileThemeData(
          titleTextStyle:
              TextStyle(fontSize: 16, color: DarkThemeAppColors.textColor),
          subtitleTextStyle: TextStyle(
            color: DarkThemeAppColors.subtextColor,
            fontWeight: FontWeight.w600,
          ),
          iconColor: DarkThemeAppColors.secondaryColor,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: DarkThemeAppColors.primaryColor,
          indicatorColor: DarkThemeAppColors.secondaryColor,
          labelTextStyle: WidgetStateTextStyle.resolveWith(
            (_) => TextStyle(
              color: DarkThemeAppColors.textColor,
            ),
          ),
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: DarkThemeAppColors.textColor),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStateColor.resolveWith(
              (_) => DarkThemeAppColors.secondaryColor,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: DarkThemeAppColors.textColor,
          backgroundColor: DarkThemeAppColors.secondaryColor,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: DarkThemeAppColors.background,
          titleTextStyle: TextStyle(
            color: DarkThemeAppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          contentTextStyle: TextStyle(
            color: DarkThemeAppColors.subtextColor,
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (_) => DarkThemeAppColors.buttonColor,
            ),
            foregroundColor: WidgetStateColor.resolveWith(
              (_) => DarkThemeAppColors.textColor,
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: DarkThemeAppColors.textColor),
          bodyMedium: TextStyle(
              color: DarkThemeAppColors.subtextColor,
              fontWeight: FontWeight.bold),
          bodySmall: TextStyle(
            color: DarkThemeAppColors.subtextColor,
          ),
          titleLarge: TextStyle(color: DarkThemeAppColors.textColor),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateColor.resolveWith(
            (_) => DarkThemeAppColors.textColor,
          ),
          side: BorderSide(
            color: DarkThemeAppColors.secondaryColor,
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
                (_) => DarkThemeAppColors.secondaryColor),
          ),
          textStyle: TextStyle(color: DarkThemeAppColors.textColor),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: DarkThemeAppColors.labeltextColor),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: DarkThemeAppColors.textColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: DarkThemeAppColors.subtextColor,
            fontWeight: FontWeight.w900,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DarkThemeAppColors.textColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DarkThemeAppColors.textColor),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: DarkThemeAppColors.primaryColor,
          filled: true,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: DarkThemeAppColors.background,
          headerForegroundColor: DarkThemeAppColors.textColor,
          dividerColor: DarkThemeAppColors.textColor,
          yearForegroundColor: WidgetStateColor.resolveWith(
            (_) => DarkThemeAppColors.textColor,
          ),
          yearBackgroundColor: WidgetStateColor.resolveWith(
            (_) => DarkThemeAppColors.primaryColor,
          ),
          yearOverlayColor: WidgetStateColor.resolveWith(
            (_) => DarkThemeAppColors.secondaryColor,
          ),
          dayForegroundColor:
              WidgetStateColor.resolveWith((_) => DarkThemeAppColors.textColor),
          weekdayStyle: TextStyle(color: DarkThemeAppColors.secondaryColor),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: DarkThemeAppColors.background,
          helpTextStyle: TextStyle(
            color: DarkThemeAppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
          hourMinuteTextColor: DarkThemeAppColors.textColor,
          hourMinuteColor: DarkThemeAppColors.primaryColor,
        ),
        useMaterial3: true,
      );
}
