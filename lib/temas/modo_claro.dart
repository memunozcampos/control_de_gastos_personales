import 'package:flutter/material.dart';

// Define los colores de la paleta
const Color darkPrimaryColor = Color(0xFF388E3C);
const Color lightPrimaryColor = Color(0xFFC8E6C9);
const Color primaryColor = Color(0xFF4CAF50);
const Color textIconsColor = Color(0xFFFFFFFF);

// Color para texto/iconos sobre fondos primarios
const Color accentColor = Color(0xFFFFC107);
const Color primaryTextColor = Color(0xFF212121);
const Color secondaryTextColor = Color(0xFF757575);
const Color dividerColor = Color(0xFFBDBDBD);

// Define el tema principal de la aplicación
final ThemeData temaDeAplicacion = ThemeData(
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    onPrimary: textIconsColor,
    primaryContainer: lightPrimaryColor,
    onPrimaryContainer: primaryTextColor,
    secondary: accentColor,
    onSecondary: primaryTextColor,
    secondaryContainer: accentColor.withAlpha(51),
    onSecondaryContainer: primaryTextColor,
    tertiary: primaryColor,
    onTertiary: textIconsColor,
    tertiaryContainer: lightPrimaryColor.withAlpha(128),
    onTertiaryContainer: primaryTextColor,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: primaryTextColor,
    outline: dividerColor,
  ),

  // Define el brillo general del tema (claro u oscuro)
  brightness: Brightness.light,

  // Define el color primario (usado por defecto por muchos widgets)
  primaryColor: primaryColor,

  // Define una variante más oscura del color primario
  primaryColorDark: darkPrimaryColor,

  // Define una variante más clara del color primario
  primaryColorLight: lightPrimaryColor,

  // Define el color de los indicadores de progreso
  indicatorColor: accentColor,

  // Define el color de los divisores
  dividerColor: dividerColor,

  // Define el color de fondo para los Scaffolds
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  // Define el tema para los AppBar
  appBarTheme: const AppBarTheme(
    color: primaryColor,
    iconTheme: IconThemeData(color: textIconsColor),
    toolbarTextStyle: TextStyle(
      color: textIconsColor,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
    titleTextStyle: TextStyle(
      color: textIconsColor,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
  ),

  // Define el tema para los botones
  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),

  // Define el tema para ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: textIconsColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
  ),

  // Define el tema para TextButton
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: primaryColor),
  ),

  // Define el tema para OutlinedButton
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),

  // Define el tema para los iconos
  iconTheme: const IconThemeData(color: primaryColor),

  // Define el tema para el texto
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 45.0,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: primaryTextColor,
      fontSize: 36.0,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: primaryTextColor,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: primaryTextColor,
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: primaryTextColor,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: primaryTextColor,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(color: primaryTextColor, fontSize: 16.0),
    bodyMedium: TextStyle(color: primaryTextColor, fontSize: 14.0),
    bodySmall: TextStyle(color: secondaryTextColor, fontSize: 12.0),
    labelLarge: TextStyle(
      color: primaryColor,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(color: primaryTextColor, fontSize: 12.0),
    labelSmall: TextStyle(color: secondaryTextColor, fontSize: 11.0),
  ).apply(bodyColor: primaryTextColor, displayColor: primaryTextColor),

  // Define el tema para los campos de texto (InputDecoration)
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

  // Define el tema para las tarjetas (Card)
  cardTheme: CardTheme(
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    margin: const EdgeInsets.all(8.0),
  ),

  // Define el tema para FloatingActionButton
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: accentColor,
    foregroundColor: primaryTextColor,
  ),

  // Define el tema para diálogos
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),

  // Define el tema para BottomNavigationBar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: secondaryTextColor,
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),

  // Define el tema para TabBar
  tabBarTheme: const TabBarTheme(
    labelColor: primaryColor,
    unselectedLabelColor: secondaryTextColor,
    indicatorColor: primaryColor,
  ),

  // Define el tema para Chip
  chipTheme: ChipThemeData(
    backgroundColor: lightPrimaryColor.withAlpha(77),
    disabledColor: Colors.grey.withAlpha(128),
    selectedColor: primaryColor,
    secondarySelectedColor: accentColor,
    padding: const EdgeInsets.all(4.0),
    labelStyle: TextStyle(
      color: primaryTextColor.withAlpha(204),
      fontWeight: FontWeight.w500,
    ),
    secondaryLabelStyle: const TextStyle(
      color: textIconsColor,
      fontWeight: FontWeight.w500,
    ),
    brightness: Brightness.light,
    shape: StadiumBorder(side: BorderSide(color: primaryColor.withAlpha(51))),
  ),
);
