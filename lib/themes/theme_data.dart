import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finalassignment/themes/text_theme.dart';
import 'package:finalassignment/themes/color_scheme.dart';

class LocThemeData {
  static ThemeData lightThemeData = themeData(lightColorScheme);

  static ThemeData themeData(ColorScheme colorScheme) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface.withOpacity(0.5),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: colorScheme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(),
      colorScheme: colorScheme,
      canvasColor: colorScheme.onSecondary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
      ),
      fontFamily: 'Roboto',
      highlightColor: Colors.transparent,
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      scaffoldBackgroundColor: colorScheme.background,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: textTheme,
      useMaterial3: true,
    );
  }
}
