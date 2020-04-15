import 'package:flutter/material.dart';

ThemeData basicTheme () {
  TextTheme _basicTextTheme (TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontSize: 22.0
      ),
      title: base.title.copyWith(
        color: Colors.black87
      ),
      subtitle: base.subtitle.copyWith(
        color: Colors.black87
      ),
      body1: base.body1.copyWith(
        color: Colors.grey
      ),
      body2: base.body2.copyWith(
        color: Color(0xFF77dc58),
      ),
      button: base.button.copyWith(
        color: Color(0xFF77dc58),
      ),
      display1: base.display1.copyWith(
        //color: Color.fromRGBO(0, 255, 0, 0.2),
        color: Color(0xFFDBF9e3),
      ),
      display2: base.display2.copyWith(
        color: Color(0xE607B553),
      ),
      display3: base.display3,
      display4: base.display4,
    );
  }
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Color.fromRGBO(66, 67, 97, 1.0),
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    cardTheme: base.cardTheme.copyWith(
      color: Color.fromRGBO(224, 240, 255, 1),
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: Colors.transparent,
    ),
    buttonColor: Colors.white,
    iconTheme: base.iconTheme.copyWith(
      size: 24.0,
    ),
  );
}

ThemeData basicDarkTheme () {
  TextTheme _basicTextTheme (TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontSize: 22.0
      ),
      title: base.title.copyWith(
        color: Colors.white,
      ),
      subtitle: base.subtitle.copyWith(
        color: Colors.white70,
      ),
      body1: base.body1.copyWith(
        color: Colors.white70,
      ),
      body2: base.body2.copyWith(
        color: Color(0xFF77dc58),
      ),
      display1: base.display1.copyWith(
        color: Color(0x99084623),
      ),
      display2: base.display2.copyWith(
        color: Color(0xFF94c7a2),
      ),
    );
  }
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    //primaryColor: Color.fromRGBO(66, 67, 97, 1.0),
    // scaffoldBackgroundColor: Color.fromRGBO(73, 74, 104, 1.0),
    primaryColor: Color.fromRGBO(73, 74, 104, 1.0),
    scaffoldBackgroundColor: Color.fromRGBO(66, 67, 97, 1.0),
    cardTheme: base.cardTheme.copyWith(
      color: Color.fromRGBO(73, 74, 104, 1.0),
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: Colors.transparent
    ),
    buttonColor: Colors.lightGreenAccent,
    iconTheme: base.iconTheme.copyWith(
      size: 24.0
    ),
  );
}