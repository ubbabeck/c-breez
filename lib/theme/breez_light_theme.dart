import 'package:flutter/material.dart';

import 'breez_colors.dart';

final ThemeData breezLightTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark()
      .copyWith(primary: Colors.white, secondary: Colors.white),
  primaryColor: const Color.fromRGBO(255, 255, 255, 1.0),
  primaryColorDark: BreezColors.blue[900],
  primaryColorLight: const Color.fromRGBO(0, 133, 251, 1.0),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(0, 133, 251, 1.0)),
  canvasColor: BreezColors.blue[500],
  backgroundColor: Colors.white,
  bottomAppBarTheme: const BottomAppBarTheme(elevation: 0),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    color: Colors.transparent,
    actionsIconTheme: IconThemeData(color: Color.fromRGBO(0, 120, 253, 1.0)),
    //toolbarTextStyle: toolbarTextStyle,
    // titleTextStyle: TextTheme(
    //   headline6:
    //       TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
    // ).headline6, systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
          color: BreezColors.grey[600], fontSize: 20.5, letterSpacing: 0.25),
      contentTextStyle:
          TextStyle(color: BreezColors.grey[500], fontSize: 16.0, height: 1.5),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)))),
  dialogBackgroundColor: Colors.transparent,
  errorColor: const Color(0xffffe685),
  dividerColor: const Color(0x33ffffff),
  cardColor: BreezColors.blue[500],
  highlightColor: BreezColors.blue[200],
  textTheme: TextTheme(
      subtitle2: TextStyle(
          color: BreezColors.grey[600], fontSize: 14.3, letterSpacing: 0.2),
      headline5: TextStyle(color: BreezColors.grey[600], fontSize: 26.0),
      button: TextStyle(
          color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25),
      headline4: const TextStyle(
        color: Color(0xffffe685),
        fontSize: 18.0,
      ),
      headline6: const TextStyle(
          color: Colors.white,
          fontSize: 12.3,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.22)),
  primaryTextTheme: TextTheme(
    headline4: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    headline3: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.28),
    headline5: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 24.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    bodyText2: TextStyle(
        color: BreezColors.blue[900],
        fontSize: 16.4,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    subtitle2: TextStyle(
        color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
    button: TextStyle(
        color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25),
    caption: TextStyle(color: BreezColors.grey[500], fontSize: 12.0),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromRGBO(0, 133, 251, 0.25),
    selectionHandleColor: Color(0xFF0085fb),
  ),
  primaryIconTheme: IconThemeData(color: BreezColors.grey[500]),
  bottomAppBarColor: const Color(0xFF0085fb),
  fontFamily: 'IBMPlexSans',
  textButtonTheme: const TextButtonThemeData(),
  outlinedButtonTheme: const OutlinedButtonThemeData(),
  elevatedButtonTheme: const ElevatedButtonThemeData(),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF0085fb);
        } else {
          return const Color(0x8a000000);
        }
      },
    ),
  ),
);
