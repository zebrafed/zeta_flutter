import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../zeta_flutter.dart';

/// A typedef for the ZetaAppBuilder function which passes [BuildContext], light [ThemeData],
/// dark [ThemeData] and [ThemeMode] and returns a [Widget].
typedef ZetaAppBuilder = Widget Function(
  BuildContext context,
  ThemeData light,
  ThemeData dark,
  ThemeMode themeMode,
);

/// A widget that provides Zeta theming and contrast data down the widget tree.
/// {@category Utils}
class ZetaProvider extends StatefulWidget with Diagnosticable {
  /// Constructs a [ZetaProvider] widget.
  ///
  /// The [builder] argument is required. The [initialThemeMode], [initialContrast],
  ZetaProvider({
    super.key,
    required this.builder,
    this.initialThemeMode,
    this.initialContrast,
    this.themeService = const ZetaDefaultThemeService(),
    this.initialRounded = true,
    this.customPrimary,
    this.customPrimaryDark,
    this.customSecondary,
    this.customSecondaryDark,
  });

  /// Specifies the initial theme mode for the app.
  ///
  /// It can be one of the values: [ThemeMode.system], [ThemeMode.light], or [ThemeMode.dark].
  /// Defaults to [ThemeMode.system].
  final ThemeMode? initialThemeMode;

  /// Specifies the initial contrast setting for the app.
  ///
  /// Defaults to [ZetaContrast.aa].
  final ZetaContrast? initialContrast;

  /// A builder function to construct the widget tree using the provided theming information.
  final ZetaAppBuilder builder;

  /// A `ZetaThemeService`
  ///
  /// It provides the structure for loading and saving themes in Zeta application.
  final ZetaThemeService themeService;

  /// Sets whether app should start with components in their rounded or sharp variants.
  final bool initialRounded;

  /// Custom primary color for the app.
  /// {@template zeta-custom-color}
  /// To define every shade of the color, provide a [ZetaColorSwatch] or a [MaterialColor].
  /// If only a [Color] is provided, a [ZetaColorSwatch] will be automatically generated.
  /// {@endtemplate}
  final Color? customPrimary;

  /// Custom primary color used for dark mode.
  /// [customPrimary] must be provided for this to be applied.
  /// If this is null, the [customPrimary] will be inverted to generate the dark variant.
  final Color? customPrimaryDark;

  /// Custom secondary color for the app.
  /// {@macro zeta-custom-color}
  final Color? customSecondary;

  /// [customSecondary] must be provided for this to be applied.
  /// If this is null, the [customSecondary] will be inverted to generate the dark variant.
  final Color? customSecondaryDark;

  @override
  State<ZetaProvider> createState() => ZetaProviderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<ZetaAppBuilder>.has('builder', builder))
      ..add(EnumProperty<ThemeMode>('initialThemeMode', initialThemeMode))
      ..add(EnumProperty<ZetaContrast>('initialContrast', initialContrast))
      ..add(DiagnosticsProperty<ZetaThemeService?>('themeService', themeService))
      ..add(DiagnosticsProperty<bool?>('initialRounded', initialRounded))
      ..add(ColorProperty('primary', customPrimary))
      ..add(ColorProperty('primaryDark', customPrimaryDark))
      ..add(ColorProperty('secondary', customSecondary))
      ..add(ColorProperty('secondaryDark', customSecondaryDark));
  }

  /// Retrieves the [ZetaProviderState] from the provided context.
  static ZetaProviderState of(BuildContext context) {
    final zetaState = context.findAncestorStateOfType<ZetaProviderState>();
    if (zetaState != null) {
      return zetaState;
    } else {
      throw FlutterError.fromParts(
        [
          ErrorDescription('Unable to find ZetaProviderState in the widget tree.'),
          ErrorHint(
            'Ensure that the context passed to ZetaProvider.of() is a descendant of a ZetaProvider widget. This usually means that ZetaProviderState should be an ancestor of the widget which uses this context.',
          ),
          ErrorSpacer(),
          ErrorDescription('The widget for the context used was:'),
          DiagnosticsProperty<Widget>('widget', context.widget, showName: false),
          ErrorSpacer(),
          ErrorHint(
            'If you recently changed the type of that widget, or the widget tree, ensure the ZetaProvider widget is still an ancestor.',
          ),
        ],
      );
    }
  }
}

/// The state associated with [ZetaProvider].
/// {@category Utils}
class ZetaProviderState extends State<ZetaProvider> with Diagnosticable, WidgetsBindingObserver {
  bool _gotTheme = false;

  /// Represents the late initialization of the ZetaContrast value.
  late ZetaContrast _contrast;

  /// Represents the late initialization of the ThemeMode value.
  late ThemeMode _themeMode;

  ZetaColorSwatch? _customPrimary;

  ZetaColorSwatch? _customPrimaryDark;

  ZetaColorSwatch? _customSecondary;

  ZetaColorSwatch? _customSecondaryDark;

  /// Represents the late initialization of the system's current brightness (dark or light mode).
  late Brightness _platformBrightness;

  /// {@macro zeta-component-rounded}
  late bool _rounded;

  /// Represents a nullable brightness value to be used for brightness change debouncing.
  Brightness? _debounceBrightness;

  /// Timer used for debouncing brightness changes.
  Timer? _debounceTimer;

  /// Represents the duration for the debounce timer.
  static const _debounceDuration = Duration(milliseconds: 250);

  /// This method is called when this object is inserted into the tree.
  ///
  /// Here, it also adds this object as an observer in [WidgetsBinding] instance
  /// and initializes various fields related to the theme, contrast, and brightness of the app.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set the initial brightness with the system's current brightness from the first view of the platform dispatcher.
    _platformBrightness = MediaQueryData.fromView(PlatformDispatcher.instance.views.first).platformBrightness;

    // Sets the initial rounded.
    _rounded = widget.initialRounded;

    _setSwatches(
      primary: widget.customPrimary,
      primaryDark: widget.customPrimaryDark,
      secondary: widget.customSecondary,
      secondaryDark: widget.customSecondaryDark,
    );

    if (widget.initialThemeMode != null) {
      _themeMode = widget.initialThemeMode!;
    }
    if (widget.initialContrast != null) {
      _contrast = widget.initialContrast!;
    }
  }

  /// Retrieves the theme values from the shared preferences.
  Future<void> getThemeValuesFromPreferences() async {
    final (themeMode, contrast) = await widget.themeService.loadTheme();

    // Set the initial theme mode.
    _themeMode = themeMode ?? widget.initialThemeMode ?? ThemeMode.system;

    // Set the initial contrast.
    _contrast = contrast ?? widget.initialContrast ?? ZetaContrast.aa;

    // Ensure this is only triggered once.
    _gotTheme = true;
  }

  /// Clean up function to be called when this object is removed from the tree.
  ///
  /// This also removes this object as an observer from the [WidgetsBinding] instance.
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Overrides the [didChangePlatformBrightness] method from the parent class.
  ///
  /// This method gets information about the platform's brightness and updates the app if it ever changes.
  /// The changes are debounced with a timer to avoid them being too frequent.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    // Get the binding instance
    final binding = WidgetsFlutterBinding.ensureInitialized();

    // Get the platform brightness from the PlatformDispatcher
    // `_debounceBrightness` will then hold the new brightness
    _debounceBrightness = binding.platformDispatcher.platformBrightness;

    // If the current stored brightness value is different from the newly fetched value
    if (_platformBrightness != _debounceBrightness) {
      // If brightness has changed, cancel the existing timer and start a new one

      // Cancel existing timer if any
      _debounceTimer?.cancel();

      // Start a new timer with `_debounceDuration` delay
      _debounceTimer = Timer(_debounceDuration, () {
        // Once timer fires, check if brightness is still different and not null
        if (_debounceBrightness != null && _platformBrightness != _debounceBrightness) {
          // If brightness value has indeed changed, update the state
          setState(() {
            // Set the new brightness value
            _platformBrightness = _debounceBrightness!;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.initialContrast != null && widget.initialThemeMode != null) || _gotTheme) {
      return _getChild();
    }
    return FutureBuilder<dynamic>(
      // ignore: discarded_futures
      future: getThemeValuesFromPreferences(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return _getChild();
      },
    );
  }

  Widget _getChild() {
    return _InternalProvider(
      contrast: _contrast,
      themeMode: _themeMode,
      rounded: _rounded,
      platformBrightness: _platformBrightness,
      widget: widget.builder,
      customPrimary: _customPrimary,
      customSecondary: _customSecondary,
      customPrimaryDark: _customPrimaryDark,
      customSecondaryDark: _customSecondaryDark,
    );
  }

  @override
  void didUpdateWidget(ZetaProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialContrast != widget.initialContrast ||
        oldWidget.initialThemeMode != widget.initialThemeMode ||
        oldWidget.initialRounded != widget.initialRounded) {
      setState(() {
        _themeMode = widget.initialThemeMode ?? _themeMode;
        _contrast = widget.initialContrast ?? _contrast;
        _rounded = widget.initialRounded;
      });
    }
  }

  /// Updates the current theme mode.
  void updateThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      _saveThemeChange();
    });
  }

  /// Generates and sets swatches with the provided colors.
  void _setSwatches({
    Color? primary,
    Color? primaryDark,
    Color? secondary,
    Color? secondaryDark,
  }) {
    if (primary != null) {
      _customPrimary = _getSwatch(primary);

      if (primaryDark != null) {
        _customPrimaryDark = _getSwatch(primaryDark);
      } else {
        _customPrimaryDark = ZetaColorSwatch.inverse(_customPrimary!);
      }
    }
    if (secondary != null) {
      _customSecondary = _getSwatch(secondary);

      if (secondaryDark != null) {
        _customSecondaryDark = _getSwatch(secondaryDark);
      } else {
        _customSecondaryDark = ZetaColorSwatch.inverse(_customSecondary!);
      }
    }
  }

  ZetaColorSwatch _getSwatch(Color color) {
    if (color is ZetaColorSwatch) {
      return color;
    } else if (color is MaterialColor) {
      return ZetaColorSwatch.fromMaterialColor(color);
    }
    return ZetaColorSwatch.fromColor(color);
  }

  /// Updates the current theme data.
  /// {@macro zeta-custom-color}
  void updateThemeData({
    Color? primary,
    Color? primaryDark,
    Color? secondary,
    Color? secondaryDark,
  }) {
    setState(() {
      _setSwatches(
        primary: primary,
        primaryDark: primaryDark,
        secondary: secondary,
        secondaryDark: secondaryDark,
      );
    });
  }

  /// Updates the current contrast.
  void updateContrast(ZetaContrast contrast) {
    setState(() {
      _contrast = contrast;
      _saveThemeChange();
    });
  }

  /// Updates the current rounded.
  // ignore: avoid_positional_boolean_parameters
  void updateRounded(bool rounded) {
    setState(() {
      _rounded = rounded;
      _saveThemeChange();
    });
  }

  void _saveThemeChange() {
    unawaited(
      widget.themeService.saveTheme(
        themeMode: _themeMode,
        contrast: _contrast,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZetaContrast>('contrast', _contrast))
      ..add(EnumProperty<ThemeMode>('themeMode', _themeMode));
  }
}

class _InternalProvider extends StatefulWidget {
  const _InternalProvider({
    required this.contrast,
    required this.themeMode,
    required this.rounded,
    required this.platformBrightness,
    required this.widget,
    required this.customPrimary,
    required this.customSecondary,
    required this.customPrimaryDark,
    required this.customSecondaryDark,
  });

  final ZetaColorSwatch? customPrimary;
  final ZetaColorSwatch? customSecondary;
  final ZetaColorSwatch? customPrimaryDark;
  final ZetaColorSwatch? customSecondaryDark;

  /// Represents the late initialization of the ZetaContrast value.
  final ZetaContrast contrast;

  /// Represents the late initialization of the ThemeMode value.
  final ThemeMode themeMode;

  final bool rounded;

  final Brightness platformBrightness;

  final ZetaAppBuilder widget;

  @override
  State<_InternalProvider> createState() => _InternalProviderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ThemeMode>('themeMode', themeMode))
      ..add(EnumProperty<ZetaContrast>('contrast', contrast))
      ..add(EnumProperty<Brightness>('platformBrightness', platformBrightness))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(ObjectFlagProperty<ZetaAppBuilder>.has('widget', widget))
      ..add(ColorProperty('customPrimary', customPrimary))
      ..add(ColorProperty('customSecondary', customSecondary))
      ..add(ColorProperty('customPrimaryDark', customPrimaryDark))
      ..add(ColorProperty('customSecondaryDark', customSecondaryDark));
  }
}

class _InternalProviderState extends State<_InternalProvider> {
  @override
  Widget build(BuildContext context) {
    return Zeta(
      themeMode: widget.themeMode,
      contrast: widget.contrast,
      rounded: widget.rounded,
      customPrimitives: widget.themeMode == ThemeMode.light
          ? ZetaPrimitivesLight(
              primary: widget.customPrimary,
              secondary: widget.customSecondary,
            )
          : ZetaPrimitivesDark(
              primary: widget.customPrimaryDark,
              secondary: widget.customSecondaryDark,
            ),
      child: Builder(
        builder: (context) {
          return widget.widget(
            context,
            generateZetaTheme(brightness: Brightness.light, colorScheme: Zeta.of(context).colors.toColorScheme),
            generateZetaTheme(brightness: Brightness.dark, colorScheme: Zeta.of(context).colors.toColorScheme),
            widget.themeMode,
          );
        },
      ),
    );
  }
}

/// Creates a variant of [ThemeData] with added [Zeta] styles.
ThemeData generateZetaTheme({
  required Brightness brightness,
  required ColorScheme colorScheme,
  ThemeData? existingTheme,
  String? fontFamily,
}) {
  if (existingTheme != null) {
    final baseThemeData = ThemeData();

    // Apply the Zeta styles to the existing theme, ignoring fields that are the same as the default ThemeData.
    return ThemeData(
      brightness: brightness,
      useMaterial3: existingTheme.useMaterial3,
      fontFamily: fontFamily ??
          (existingTheme.textTheme.bodyMedium?.fontFamily == baseThemeData.textTheme.bodyMedium?.fontFamily
              ? kZetaFontFamily
              : existingTheme.textTheme.bodyMedium?.fontFamily),
      scaffoldBackgroundColor: existingTheme.scaffoldBackgroundColor,
      colorScheme:
          ((existingTheme.colorScheme == baseThemeData.colorScheme ? null : existingTheme.colorScheme) ?? colorScheme)
              .copyWith(brightness: brightness),
      textTheme: (existingTheme.textTheme == baseThemeData.textTheme ? null : existingTheme.textTheme) ?? zetaTextTheme,
      iconTheme: (existingTheme.iconTheme == baseThemeData.iconTheme ? null : existingTheme.iconTheme) ??
          const IconThemeData(size: kZetaIconSize),
      actionIconTheme: existingTheme.actionIconTheme,
      applyElevationOverlayColor: existingTheme.applyElevationOverlayColor,
      cupertinoOverrideTheme: existingTheme.cupertinoOverrideTheme,
      inputDecorationTheme: existingTheme.inputDecorationTheme,
      materialTapTargetSize: existingTheme.materialTapTargetSize,
      pageTransitionsTheme: existingTheme.pageTransitionsTheme,
      platform: existingTheme.platform,
      scrollbarTheme: existingTheme.scrollbarTheme,
      splashFactory: existingTheme.splashFactory,
      visualDensity: existingTheme.visualDensity,
      canvasColor: existingTheme.canvasColor,
      cardColor: existingTheme.cardColor,
      dialogBackgroundColor: existingTheme.dialogBackgroundColor,
      disabledColor: existingTheme.disabledColor,
      dividerColor: existingTheme.dividerColor,
      focusColor: existingTheme.focusColor,
      highlightColor: existingTheme.highlightColor,
      hintColor: existingTheme.hintColor,
      hoverColor: existingTheme.hoverColor,
      indicatorColor: existingTheme.indicatorColor,
      primaryColor: existingTheme.primaryColor,
      primaryColorDark: existingTheme.primaryColorDark,
      primaryColorLight: existingTheme.primaryColorLight,
      secondaryHeaderColor: existingTheme.secondaryHeaderColor,
      shadowColor: existingTheme.shadowColor,
      splashColor: existingTheme.splashColor,
      unselectedWidgetColor: existingTheme.unselectedWidgetColor,
      primaryIconTheme: existingTheme.primaryIconTheme,
      primaryTextTheme: existingTheme.primaryTextTheme,
      typography: existingTheme.typography,
      appBarTheme: existingTheme.appBarTheme,
      badgeTheme: existingTheme.badgeTheme,
      bannerTheme: existingTheme.bannerTheme,
      bottomAppBarTheme: existingTheme.bottomAppBarTheme,
      bottomNavigationBarTheme: existingTheme.bottomNavigationBarTheme,
      bottomSheetTheme: existingTheme.bottomSheetTheme,
      buttonTheme: existingTheme.buttonTheme,
      cardTheme: existingTheme.cardTheme,
      checkboxTheme: existingTheme.checkboxTheme,
      chipTheme: existingTheme.chipTheme,
      dataTableTheme: existingTheme.dataTableTheme,
      datePickerTheme: existingTheme.datePickerTheme,
      dialogTheme: existingTheme.dialogTheme,
      dividerTheme: existingTheme.dividerTheme,
      drawerTheme: existingTheme.drawerTheme,
      dropdownMenuTheme: existingTheme.dropdownMenuTheme,
      elevatedButtonTheme: existingTheme.elevatedButtonTheme,
      expansionTileTheme: existingTheme.expansionTileTheme,
      filledButtonTheme: existingTheme.filledButtonTheme,
      floatingActionButtonTheme: existingTheme.floatingActionButtonTheme,
      iconButtonTheme: existingTheme.iconButtonTheme,
      listTileTheme: existingTheme.listTileTheme,
      menuBarTheme: existingTheme.menuBarTheme,
      menuButtonTheme: existingTheme.menuButtonTheme,
      menuTheme: existingTheme.menuTheme,
      navigationBarTheme: existingTheme.navigationBarTheme,
      navigationDrawerTheme: existingTheme.navigationDrawerTheme,
      navigationRailTheme: existingTheme.navigationRailTheme,
      outlinedButtonTheme: existingTheme.outlinedButtonTheme,
      popupMenuTheme: existingTheme.popupMenuTheme,
      progressIndicatorTheme: existingTheme.progressIndicatorTheme,
      radioTheme: existingTheme.radioTheme,
      searchBarTheme: existingTheme.searchBarTheme,
      searchViewTheme: existingTheme.searchViewTheme,
      segmentedButtonTheme: existingTheme.segmentedButtonTheme,
      sliderTheme: existingTheme.sliderTheme,
      snackBarTheme: existingTheme.snackBarTheme,
      switchTheme: existingTheme.switchTheme,
      tabBarTheme: existingTheme.tabBarTheme,
      textButtonTheme: existingTheme.textButtonTheme,
      textSelectionTheme: existingTheme.textSelectionTheme,
      timePickerTheme: existingTheme.timePickerTheme,
      toggleButtonsTheme: existingTheme.toggleButtonsTheme,
      tooltipTheme: existingTheme.tooltipTheme,
    );
  }
  return ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily ?? kZetaFontFamily,
    brightness: brightness,
    colorScheme: colorScheme.copyWith(brightness: brightness),
    textTheme: zetaTextTheme,
    iconTheme: IconThemeData(
      size: kZetaIconSize,
      color: brightness == Brightness.light ? colorScheme.onPrimary : colorScheme.onSurface,
    ),
  );
}
