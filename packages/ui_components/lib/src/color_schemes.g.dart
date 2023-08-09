import 'package:flutter/material.dart';
import 'package:ui_components/src/ui_colors.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF526600),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD3EE7F),
  onPrimaryContainer: Color(0xFF171E00),
  secondary: Color(0xFF5B6146),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE0E6C4),
  onSecondaryContainer: Color(0xFF191E08),
  tertiary: Color(0xFF3A665E),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFBCECE1),
  onTertiaryContainer: Color(0xFF00201B),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFEFCF4),
  onBackground: Color(0xFF1B1C17),
  surface: Color(0xFFFEFCF4),
  onSurface: Color(0xFF1B1C17),
  surfaceVariant: Color(0xFFE3E4D3),
  onSurfaceVariant: Color(0xFF46483C),
  outline: Color(0xFF76786B),
  onInverseSurface: Color(0xFFF3F1E9),
  inverseSurface: Color(0xFF30312B),
  inversePrimary: Color(0xFFB8D166),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF526600),
  outlineVariant: Color(0xFFC7C8B8),
  scrim: Color(0xFF000000),
);
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: UIColors.primary,
  primaryContainer: Colors.pink,
  secondary: UIColors.secondary,
  secondaryContainer: Colors.pink,
  surface: UIColors.overlay,
  surfaceTint: Colors.pink,
  surfaceVariant: UIColors.onOverlayCard,
  background: UIColors.background,
  error: UIColors.delete,
  onPrimary: UIColors.textDark,
  onSecondary: UIColors.textDark,
  onBackground: UIColors.textLight,
  onError: UIColors.delete,
  onErrorContainer: UIColors.textDark,
  onInverseSurface: Colors.pink,
  onPrimaryContainer: Colors.pink,
  onSecondaryContainer: Colors.pink,
  onSurface: UIColors.textLight,
  onSurfaceVariant: UIColors.textLight,
  onTertiary: Colors.pink,
  onTertiaryContainer: Colors.pink,
  outline: Colors.pink,
  outlineVariant: Colors.pink,
  shadow: Colors.pink,
  tertiary: Colors.pink,
  tertiaryContainer: Colors.pink,
  inversePrimary: Colors.pink,
  inverseSurface: Colors.pink,
  errorContainer: UIColors.delete,
  scrim: Colors.pink,
);

// const darkBlackAndWhiteColorScheme = ColorScheme(
//   brightness: Brightness.dark,
//   primary: Colors.black87,
//   onPrimary: Colors.white,
//   primaryContainer: Colors.black54,
//   onPrimaryContainer: Colors.white,
//   secondary: Colors.black45,
//   onSecondary: Colors.white,
//   secondaryContainer: Color(0xFF444930),
//   onSecondaryContainer: Color(0xFFE0E6C4),
//   tertiary: Color(0xFFA1D0C5),
//   onTertiary: Color(0xFF033730),
//   tertiaryContainer: Colors.black87,
//   onTertiaryContainer: Colors.white,
//   error: Color(0xFFFFB4AB),
//   errorContainer: Color(0xFF93000A),
//   onError: Color(0xFF690005),
//   onErrorContainer: Color(0xFFFFDAD6),
//   background: Colors.black87,
//   onBackground: Colors.white,
//   surface: Color(0xFF1B1C17),
//   onSurface: Color(0xFFE4E3DA),
//   surfaceVariant: Colors.black87,
//   onSurfaceVariant: Colors.white,
//   outline: Color(0xFF909283),
//   onInverseSurface: Color(0xFF1B1C17),
//   inverseSurface: Color(0xFFE4E3DA),
//   inversePrimary: Color(0xFF526600),
//   shadow: Color(0xFF000000),
//   surfaceTint: Color(0xFFB8D166),
//   outlineVariant: Color(0xFF46483C),
//   scrim: Color(0xFF000000),
// );

// const lightBlackAndWhiteColorScheme = ColorScheme(
//   brightness: Brightness.light,
//   primary: Colors.white,
//   onPrimary: Colors.black,
//   primaryContainer: Colors.white,
//   onPrimaryContainer: Colors.black,
//   secondary: Colors.white70,
//   onSecondary: Colors.black,
//   secondaryContainer: Color(0xFFE8E8E8),
//   onSecondaryContainer: Colors.black,
//   tertiary: Color(0xFFE0E6C4),
//   onTertiary: Colors.black,
//   tertiaryContainer: Colors.white,
//   onTertiaryContainer: Colors.black,
//   error: Color(0xFFB00020),
//   errorContainer: Color(0xFFFFEBEE),
//   onError: Color(0xFFB00020),
//   onErrorContainer: Color(0xFFFFEBEE),
//   background: Colors.white,
//   onBackground: Colors.black,
//   surface: Color(0xFFF5F5F5),
//   onSurface: Colors.black,
//   surfaceVariant: Colors.white,
//   onSurfaceVariant: Colors.black,
//   outline: Color(0xFFC4C4C4),
//   onInverseSurface: Colors.white,
//   inverseSurface: Colors.black,
//   inversePrimary: Colors.black,
//   shadow: Color(0xFF000000),
//   surfaceTint: Color(0xFFB8D166),
//   outlineVariant: Color(0xFF9E9E9E),
//   scrim: Color(0x99000000),
// );

final List<Color> defaultColors = [
  Colors.redAccent[100]!,
  Colors.orangeAccent[100]!,
  Colors.yellowAccent[100]!,
  Colors.greenAccent[100]!,
  Colors.blueAccent[100]!,
  Colors.deepPurpleAccent[100]!,
];
