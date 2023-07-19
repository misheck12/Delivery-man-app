import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xffe77d2d),
  secondaryHeaderColor: const Color(0xfff07524),
  disabledColor: const Color(0xFF6f7275),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(
      0xfff07524))),
  colorScheme: const ColorScheme.dark(primary: Color(0xFF54b46b), secondary: Color(0xFF54b46b)).copyWith(error: const Color(0xFFdd3135)),
);
