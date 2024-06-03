import 'package:flutter/material.dart';

import 'color_util.dart';

ThemeData themeData = ThemeData(
  colorSchemeSeed: CustomColors.midnightBlue,
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: CustomColors.midnightBlue),
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 40),
  snackBarTheme:
      const SnackBarThemeData(backgroundColor: CustomColors.midnightBlue),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: CustomColors.pearlWhite)),
);
