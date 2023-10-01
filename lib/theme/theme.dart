import 'package:flutter/material.dart';

class ThemeApp {
  static Color red = Color.fromRGBO(236, 70, 70, 1);
  static Color orange = Color.fromRGBO(219, 100, 0, 1);
  static Color green = Color.fromRGBO(22, 199, 154, 1);

  static defaultShadow(context) {
    return <BoxShadow>[
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 10,
        color: Theme.of(context).focusColor.withAlpha(25),
      ),
    ];
  }

  static defaultCardBorderRadius() => BorderRadius.circular(15);
  static defaultCardColor({bool enabled = true}) => enabled ? Colors.white : Colors.white54;
}

ThemeData theme = ThemeData(
    backgroundColor: Color.fromRGBO(245, 245, 245, 1),
    primaryColor: Color(0xFF044565),
    cardColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
        // Headline1 = Estilo dos titulos
        headline1: const TextStyle(
          fontFamily: 'Comfortaa',
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(1, 20, 39, 10),
        ),
        // Headline2 = Estilo dos subtitulos
        headline2: const TextStyle(
          fontFamily: 'SourceSansPro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(1, 20, 39, 10),
        ),
        // Headline3 = Estilo dos titulos dentro das listas
        headline3: const TextStyle(
          fontFamily: 'Comfortaa',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(1, 20, 39, 10),
        ),
        // Headline4 = Estilo dos subtitulos dentro das listas
        headline4: const TextStyle(
          fontFamily: 'SourceSansPro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(4, 59, 101, 10),
        ),
        // Headline5 = Estilo de texto dos SpeedDials
        headline5: const TextStyle(
          fontFamily: 'SourceSansPro',
          fontSize: 16,
          color: Color.fromRGBO(4, 59, 101, 10),
        ),
        // Headline6 = Estilo de texto dos Formulários da Add_users_page
        headline6: TextStyle(
          fontFamily: 'SourceSansPro',
          fontSize: 16,
          color: Colors.grey[900],
        ),
        bodyText1: const TextStyle(
            fontFamily: 'Comfortaa', fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromRGBO(4, 59, 101, 1)),
        bodyText2: TextStyle(fontFamily: 'SourceSansPro', fontSize: 14, color: Colors.grey[600])));
