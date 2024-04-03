import 'package:flutter/material.dart';

class GruvboxLightPalette {
  GruvboxLightPalette._();

  static const bg = Color(0xffffffff);
  static const bg0h = Color(0xFFf9f5d7);
  static const bg0s = Color(0xFFf2e5bc);
  static const bg1 = Color(0xFFebdbb2);
  static const bg2 = Color(0xff6e5f47);
  static const bg3 = Color(0xffcb9c30);
  static const bg4 = Color(0xFFa89984);

  static const fg = Color(0xFF3c3836);
  static const fg0 = Color(0xFF282828);
  static const fg1 = Color(0xFF3c3836);
  static const fg2 = Color(0xFF504945);
  static const fg3 = Color(0xFF665c54);
  static const fg4 = Color(0xFF7c6f64);

  static const darkRed = Color(0xFF9d0006);
  static const lightRed = Color(0xFFcc241d);
  static const darkGreen = Color(0xFF79740e);
  static const lightGreen = Color(0xFF98971a);
  static const darkYellow = Color(0xFFb57614);
  static const lightYellow = Color(0xFFd79921);
  static const darkBlue = Color(0xFF076678);
  static const lightBlue = Color(0xFF458588);
  static const darkPurple = Color(0xFF8f3f71);
  static const lightPurple = Color(0xFFb16286);
  static const darkAqua = Color(0xFF427b58);
  static const lightAqua = Color(0xFF689d6a);
  static const darkGrey = Color(0xFF7c6f64);
  static const lightGrey = Color(0xFF928374);
  static const darkOrange = Color(0xFFaf3a03);
  static const lightOrange = Color(0xFFd65d0e);
}

const ColorScheme lightColorScheme = ColorScheme(
  primary: GruvboxLightPalette.darkBlue,
  onPrimary: GruvboxLightPalette.bg0h,
  primaryContainer: GruvboxLightPalette.darkBlue,
  onPrimaryContainer: GruvboxLightPalette.bg0h,
  secondary: GruvboxLightPalette.fg1,
  onSecondary: GruvboxLightPalette.bg0s,
  secondaryContainer: GruvboxLightPalette.darkBlue,
  onSecondaryContainer: GruvboxLightPalette.bg0h,
  tertiary: GruvboxLightPalette.bg2,
  onTertiary: GruvboxLightPalette.fg4,
  background: GruvboxLightPalette.bg,
  onBackground: GruvboxLightPalette.lightBlue,
  error: GruvboxLightPalette.darkRed,
  onError: GruvboxLightPalette.bg0h,
  surface: GruvboxLightPalette.bg1,
  onSurface: GruvboxLightPalette.fg,
  outline: GruvboxLightPalette.bg2,
  brightness: Brightness.light,
);
