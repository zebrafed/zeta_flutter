import 'package:flutter/material.dart';
import '../../zeta_flutter.dart';

/// Generic ZetaThemeService Class
/// Returns a ZetaThemeService that can be customized with optional theming.
class ZetaThemeServiceBase extends ZetaThemeService {
  /// Default constructor with custom colors passed in as parameters
  ZetaThemeServiceBase({
    Color? primary,
    Color? secondary,
    this.themeMode = ThemeMode.system,
    this.themeContrast = ZetaContrast.aa,
  }) : themeData = ZetaThemeData(primary: primary, secondary: secondary);

  /// TODO: Constructor that constructs theme service from json input
  ZetaThemeServiceBase.json({
    // JSON? themeJson,
    this.themeMode = ThemeMode.system,
    this.themeContrast = ZetaContrast.aa,
  }) : themeData = ZetaThemeData();

  /// TODO: Constructor that constructs theme service from Map
  ZetaThemeServiceBase.map({
    // Map<String, String>? themeMap,
    this.themeMode = ThemeMode.system,
    this.themeContrast = ZetaContrast.aa,
  }) : themeData = ZetaThemeData();

  /// Generate default theme service with no added changes
  ZetaThemeServiceBase.def()
      : themeData = ZetaThemeData(),
        themeMode = ThemeMode.system,
        themeContrast = ZetaContrast.aa;

  /// Theme data.
  ZetaThemeData themeData;

  /// Theme mode => Light or dark. Defaults to the systems mode.
  ThemeMode themeMode;

  /// Contrast => aa or aaa. defaults to aa.
  ZetaContrast themeContrast;

  /// Getters

  /// Returns theme data.
  ZetaThemeData get getData => themeData;

  /// Returns theme mode
  ThemeMode get getMode => themeMode;

  /// Returns theme
  ZetaContrast get getContrast => themeContrast;

  @override
  Future<(ZetaThemeData?, ThemeMode?, ZetaContrast?)> loadTheme() async {
    return (themeData, themeMode, themeContrast);
  }

  @override
  Future<void> saveTheme({
    required ZetaThemeData themeData,
    required ThemeMode themeMode,
    required ZetaContrast contrast,
  }) async {
    this.themeData = themeData;
    this.themeMode = themeMode;
    themeContrast = contrast;
  }
}
