import 'package:flutter/material.dart';

// Define los colores de la paleta para modo oscuro
const Color darkPrimaryColor = Color(0xFF2E7D32);
const Color lightPrimaryColor = Color(0xFF1B5E20);
const Color primaryColor = Color(0xFF4CAF50);
const Color textIconsColor = Color(0xFFFFFFFF);
const Color accentColor = Color(0xFFFFC107);
const Color primaryTextColor = Color(0xFFE0E0E0);
const Color secondaryTextColor = Color(0xFF9E9E9E);
const Color dividerColor = Color(0xFF616161);

// Define el tema oscuro de la aplicación
final ThemeData temaOscuroDeAplicacion = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    onPrimary: textIconsColor,
    primaryContainer: lightPrimaryColor,
    onPrimaryContainer: primaryTextColor,
    secondary: accentColor,
    onSecondary: Colors.black,
    secondaryContainer: accentColor.withAlpha(51),
    onSecondaryContainer: primaryTextColor,
    tertiary: primaryColor,
    onTertiary: textIconsColor,
    tertiaryContainer: lightPrimaryColor.withAlpha(128),
    onTertiaryContainer: primaryTextColor,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.grey[900]!,
    onSurface: primaryTextColor,
    outline: dividerColor,
  ),

  brightness: Brightness.dark,

  primaryColor: primaryColor,
  primaryColorDark: darkPrimaryColor,
  primaryColorLight: lightPrimaryColor,
  indicatorColor: accentColor,
  dividerColor: dividerColor,
  scaffoldBackgroundColor: Colors.grey[850]!,

  appBarTheme: AppBarTheme(
    color: Colors.grey[900]!,
    iconTheme: const IconThemeData(color: textIconsColor),
    toolbarTextStyle: TextStyle(
      color: primaryTextColor,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
    titleTextStyle: TextStyle(
      color: primaryTextColor,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: textIconsColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: primaryColor),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),

  iconTheme: const IconThemeData(color: primaryColor),

  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
    ),
    // ... (mantener misma estructura de textTheme cambiando colores a primaryTextColor y secondaryTextColor)
    bodySmall: TextStyle(color: secondaryTextColor, fontSize: 12.0),
    labelLarge: TextStyle(
      color: primaryColor,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    ),
  ).apply(bodyColor: primaryTextColor, displayColor: primaryTextColor),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: dividerColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: primaryColor, width: 2.0),
    ),
    labelStyle: const TextStyle(color: secondaryTextColor),
    hintStyle: const TextStyle(color: secondaryTextColor),
  ),

  cardTheme: CardTheme(
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    margin: const EdgeInsets.all(8.0),
    color: Colors.grey[800]!,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: accentColor,
    foregroundColor: Colors.black,
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: secondaryTextColor,
    backgroundColor: Colors.grey[900]!,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),

  tabBarTheme: const TabBarTheme(
    labelColor: primaryColor,
    unselectedLabelColor: secondaryTextColor,
    indicatorColor: primaryColor,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[800]!,
    disabledColor: Colors.grey[700]!,
    selectedColor: primaryColor,
    secondarySelectedColor: accentColor,
    padding: const EdgeInsets.all(4.0),
    labelStyle: TextStyle(color: primaryTextColor, fontWeight: FontWeight.w500),
    secondaryLabelStyle: const TextStyle(
      color: textIconsColor,
      fontWeight: FontWeight.w500,
    ),
    brightness: Brightness.dark,
    shape: StadiumBorder(side: BorderSide(color: Colors.grey[700]!)),
  ),
);
