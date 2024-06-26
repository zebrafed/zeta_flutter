// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

void main() {
  group('ZetaColors', () {
    test('default constructor initializes correctly', () {
      final zetaColors = ZetaColors();

      expect(zetaColors.brightness, Brightness.light);
      expect(zetaColors.contrast, ZetaContrast.aa);
      expect(zetaColors.white, ZetaColorBase.white);
      expect(zetaColors.black, ZetaColorBase.black);
      expect(zetaColors.primary, isNotNull);
      expect(zetaColors.secondary, isNotNull);
      expect(zetaColors.error, isNotNull);
      expect(zetaColors.cool, isNotNull);
      expect(zetaColors.warm, isNotNull);
      expect(zetaColors.pure, isNotNull);
      expect(zetaColors.surfacePrimary, ZetaColorBase.white);
      expect(zetaColors.surfaceSecondary, isNotNull);
      expect(zetaColors.surfaceTertiary, isNotNull);
    });

    test('light constructor initializes correctly', () {
      final zetaColors = ZetaColors.light(
        warm: ZetaColorBase.warm,
        cool: ZetaColorBase.cool,
      );

      expect(zetaColors.brightness, Brightness.light);
      expect(zetaColors.contrast, ZetaContrast.aa);
      expect(zetaColors.white, ZetaColorBase.white);
      expect(zetaColors.black, ZetaColorBase.black);
      expect(zetaColors.primary, isNotNull);
      expect(zetaColors.secondary, isNotNull);
      expect(zetaColors.error, isNotNull);
      expect(zetaColors.cool, isNotNull);
      expect(zetaColors.warm, isNotNull);
      expect(zetaColors.pure, isNotNull);
      expect(zetaColors.surfacePrimary, ZetaColorBase.white);
      expect(zetaColors.surfaceSecondary, isNotNull);
      expect(zetaColors.surfaceTertiary, isNotNull);
    });

    test('dark constructor initializes correctly', () {
      final zetaColors = ZetaColors.dark(
        warm: ZetaColorBase.warm,
        cool: ZetaColorBase.cool,
      );

      expect(zetaColors.brightness, Brightness.dark);
      expect(zetaColors.contrast, ZetaContrast.aa);
      expect(zetaColors.white, ZetaColorBase.white);
      expect(zetaColors.black, ZetaColorBase.black);
      expect(zetaColors.primary, isNotNull);
      expect(zetaColors.secondary, isNotNull);
      expect(zetaColors.error, isNotNull);
      expect(zetaColors.cool, isNotNull);
      expect(zetaColors.warm, isNotNull);
      expect(zetaColors.pure, isNotNull);
      expect(zetaColors.surfacePrimary, ZetaColorBase.black);
      expect(zetaColors.surfaceSecondary, isNotNull);
      expect(zetaColors.surfaceTertiary, isNotNull);
    });

    test('copyWith creates a new instance with updated properties', () {
      final zetaColors = ZetaColors().copyWith();
      final newColors = zetaColors.copyWith(
        brightness: Brightness.dark,
        contrast: ZetaContrast.aaa,
        primary: ZetaColorBase.green,
        secondary: ZetaColorBase.orange,
      );

      expect(newColors.isDarkMode, true);
      expect(newColors.brightness, Brightness.dark);
      expect(newColors.contrast, ZetaContrast.aaa);
      expect(newColors.primary, ZetaColorBase.green.apply(brightness: Brightness.dark, contrast: ZetaContrast.aaa));
      expect(newColors.secondary, ZetaColorBase.orange.apply(brightness: Brightness.dark, contrast: ZetaContrast.aaa));
      expect(newColors.white, zetaColors.white);
      expect(newColors.black, zetaColors.black);
    });

    test('rainbow getters returns correct colors', () {
      final zetaColors = ZetaColors();
      expect(zetaColors.rainbow[0], zetaColors.red);
      expect(zetaColors.rainbow[1], zetaColors.orange);
      expect(zetaColors.rainbow[2], zetaColors.yellow);
      expect(zetaColors.rainbow[3], zetaColors.green);
      expect(zetaColors.rainbow[4], zetaColors.blue);
      expect(zetaColors.rainbow[5], zetaColors.teal);
      expect(zetaColors.rainbow[6], zetaColors.pink);

      expect(zetaColors.rainbowMap['red'], zetaColors.red);
      expect(zetaColors.rainbowMap['orange'], zetaColors.orange);
      expect(zetaColors.rainbowMap['yellow'], zetaColors.yellow);
      expect(zetaColors.rainbowMap['green'], zetaColors.green);
      expect(zetaColors.rainbowMap['blue'], zetaColors.blue);
      expect(zetaColors.rainbowMap['teal'], zetaColors.teal);
      expect(zetaColors.rainbowMap['pink'], zetaColors.pink);
    });

    test('apply returns a new instance with updated contrast', () {
      final zetaColors = ZetaColors();
      final newColors = zetaColors.apply(contrast: ZetaContrast.aaa);

      expect(newColors.contrast, ZetaContrast.aaa);
      expect(newColors.primary, isNotNull);
      expect(newColors.secondary, isNotNull);
      expect(newColors.error, isNotNull);
      expect(newColors.cool, isNotNull);
      expect(newColors.warm, isNotNull);
      expect(newColors.pure, isNotNull);
    });

    test('toScheme returns a ZetaColorScheme with correct values', () {
      final zetaColors = ZetaColors();
      final scheme = zetaColors.toScheme();

      expect(scheme.zetaColors, zetaColors);
      expect(scheme.brightness, zetaColors.brightness);
      expect(scheme.primary, zetaColors.primary.shade(zetaColors.contrast.primary));
      expect(scheme.secondary, zetaColors.secondary.shade(zetaColors.contrast.primary));
      expect(scheme.surface, zetaColors.surfacePrimary);
      expect(scheme.error, zetaColors.error);
    });

    test('Color getter returns correct values', () {
      final zetaColors = ZetaColors();

      expect(zetaColors.textDefault, ZetaColorBase.cool.shade90);
      expect(zetaColors.textSubtle, ZetaColorBase.cool.shade70);
      expect(zetaColors.textDisabled, ZetaColorBase.cool.shade50);
      expect(zetaColors.textInverse, ZetaColorBase.cool.shade20);
      expect(zetaColors.iconDefault, ZetaColorBase.cool.shade90);
      expect(zetaColors.iconSubtle, ZetaColorBase.cool.shade70);
      expect(zetaColors.iconDisabled, ZetaColorBase.cool.shade50);
      expect(zetaColors.iconInverse, ZetaColorBase.cool.shade20);
      expect(zetaColors.surfaceDefault, ZetaColorBase.pure.shade(0));
      expect(zetaColors.surfaceDefaultInverse, ZetaColorBase.warm.shade(100));
      expect(zetaColors.surfaceHover, ZetaColorBase.cool.shade(20));
      expect(zetaColors.surfaceSelected, ZetaColorBase.blue.shade(10));
      expect(zetaColors.surfaceSelectedHover, ZetaColorBase.blue.shade(20));
      expect(zetaColors.surfaceDisabled, ZetaColorBase.cool.shade(30));
      expect(zetaColors.surfaceCool, ZetaColorBase.cool.shade(10));
      expect(zetaColors.surfaceWarm, ZetaColorBase.warm.shade(10));
      expect(zetaColors.surfacePrimarySubtle, ZetaColorBase.blue.shade(10));
      expect(zetaColors.surfaceAvatarBlue, ZetaColorBase.blue.shade(80));
      expect(zetaColors.surfaceAvatarOrange, ZetaColorBase.orange.shade(50));
      expect(zetaColors.surfaceAvatarPink, ZetaColorBase.pink.shade(80));
      expect(zetaColors.surfaceAvatarPurple, ZetaColorBase.purple.shade(80));
      expect(zetaColors.surfaceAvatarTeal, ZetaColorBase.teal.shade(80));
      expect(zetaColors.surfaceAvatarYellow, ZetaColorBase.yellow.shade(50));
      expect(zetaColors.surfaceSecondarySubtle, ZetaColorBase.yellow.shade(10));
      expect(zetaColors.surfacePositiveSubtle, ZetaColorBase.green.shade(10));
      expect(zetaColors.surfaceWarningSubtle, ZetaColorBase.orange.shade(10));
      expect(zetaColors.surfaceNegativeSubtle, ZetaColorBase.red.shade(10));
      expect(zetaColors.surfaceInfoSubtle, ZetaColorBase.purple.shade(10));
      expect(zetaColors.borderDefault, ZetaColorBase.cool.shade(40));
      expect(zetaColors.borderSubtle, ZetaColorBase.cool.shade(30));
      expect(zetaColors.borderHover, ZetaColorBase.cool.shade(90));
      expect(zetaColors.borderSelected, ZetaColorBase.cool.shade(90));
      expect(zetaColors.borderDisabled, ZetaColorBase.cool.shade(20));
      expect(zetaColors.borderPure, ZetaColorBase.pure.shade(0));
      expect(zetaColors.borderPrimary, ZetaColorBase.blue.shade(50));
      expect(zetaColors.borderSecondary, ZetaColorBase.yellow.shade(50));
      expect(zetaColors.borderPositive, ZetaColorBase.green.shade(50));
      expect(zetaColors.borderWarning, ZetaColorBase.orange.shade(50));
      expect(zetaColors.borderNegative, ZetaColorBase.red.shade(50));
      expect(zetaColors.borderInfo, ZetaColorBase.purple.shade(50));
      expect(zetaColors.surfacePositive, ZetaColorBase.green);
      expect(zetaColors.surfaceWarning, ZetaColorBase.orange);
      expect(zetaColors.surfaceNegative, ZetaColorBase.red);
      expect(zetaColors.surfaceAvatarGreen, ZetaColorBase.green);
      expect(zetaColors.surfaceInfo, ZetaColorBase.purple);
      expect(zetaColors.borderPrimaryMain, ZetaColorBase.blue);
    });

    test('deprecated properties return correct values', () {
      final zetaColors = ZetaColors();

      expect(zetaColors.surfaceHovered, zetaColors.surfaceHover);
      expect(zetaColors.surfaceSelectedHovered, zetaColors.surfaceSelectedHover);
      expect(zetaColors.positive, zetaColors.surfacePositive);
      expect(zetaColors.negative, zetaColors.surfaceNegative);
      expect(zetaColors.warning, zetaColors.surfaceWarning);
      expect(zetaColors.info, zetaColors.surfaceInfo);
      expect(zetaColors.shadow, const Color(0x1A49505E));
      expect(zetaColors.link, ZetaColorBase.linkLight);
      expect(zetaColors.linkVisited, ZetaColorBase.linkVisitedLight);
    });

    test('props returns correct list of properties', () {
      final zetaColors = ZetaColors();

      expect(
        zetaColors.props,
        [
          zetaColors.brightness,
          zetaColors.contrast,
          zetaColors.primary,
          zetaColors.secondary,
          zetaColors.error,
          zetaColors.cool,
          zetaColors.warm,
          zetaColors.white,
          zetaColors.black,
          zetaColors.surfacePrimary,
          zetaColors.surfaceSecondary,
          zetaColors.surfaceTertiary,
        ],
      );
    });
  });

  group('ZetaColorGetters', () {
    test('ColorScheme extension getters should return correct colors when scheme is ZetaColorScheme', () {
      final zetaColors = ZetaColors();
      final themeData = ThemeData.light().copyWith(colorScheme: zetaColors.toScheme());
      expect(themeData.colorScheme.primarySwatch, zetaColors.primary);
      expect(themeData.colorScheme.secondarySwatch, zetaColors.secondary);
      expect(themeData.colorScheme.cool, zetaColors.cool);
      expect(themeData.colorScheme.warm, zetaColors.warm);
      expect(themeData.colorScheme.textDefault, zetaColors.textDefault);
      expect(themeData.colorScheme.textSubtle, zetaColors.textSubtle);
      expect(themeData.colorScheme.textDisabled, zetaColors.textDisabled);
      expect(themeData.colorScheme.textInverse, zetaColors.textInverse);
      expect(themeData.colorScheme.surfacePrimary, zetaColors.surfacePrimary);
      expect(themeData.colorScheme.surfaceSecondary, zetaColors.surfaceSecondary);
      expect(themeData.colorScheme.surfaceTertiary, zetaColors.surfaceTertiary);
      expect(themeData.colorScheme.surfaceDisabled, zetaColors.surfaceDisabled);
      expect(themeData.colorScheme.surfaceHover, zetaColors.surfaceHover);
      expect(themeData.colorScheme.surfaceSelected, zetaColors.surfaceSelected);
      expect(themeData.colorScheme.surfaceSelectedHover, zetaColors.surfaceSelectedHover);
      expect(themeData.colorScheme.borderDefault, zetaColors.borderDefault);
      expect(themeData.colorScheme.borderSubtle, zetaColors.borderSubtle);
      expect(themeData.colorScheme.borderDisabled, zetaColors.borderDisabled);
      expect(themeData.colorScheme.borderSelected, zetaColors.borderSelected);
      expect(themeData.colorScheme.blue, zetaColors.blue);
      expect(themeData.colorScheme.green, zetaColors.green);
      expect(themeData.colorScheme.red, zetaColors.red);
      expect(themeData.colorScheme.orange, zetaColors.orange);
      expect(themeData.colorScheme.purple, zetaColors.purple);
      expect(themeData.colorScheme.yellow, zetaColors.yellow);
      expect(themeData.colorScheme.teal, zetaColors.teal);
      expect(themeData.colorScheme.pink, zetaColors.pink);
      expect(themeData.colorScheme.positive, zetaColors.green);
      expect(themeData.colorScheme.negative, zetaColors.red);
      expect(themeData.colorScheme.warning, zetaColors.orange);
      expect(themeData.colorScheme.info, zetaColors.purple);
    });

    test('ColorScheme extension getters should return default colors when ZetaColorScheme scheme is not injected', () {
      final themeData = ThemeData.light();
      expect(themeData.colorScheme.primarySwatch, ZetaColorBase.blue);
      expect(themeData.colorScheme.secondarySwatch, ZetaColorBase.yellow);
      expect(themeData.colorScheme.cool, ZetaColorBase.cool);
      expect(themeData.colorScheme.warm, ZetaColorBase.warm);
      expect(themeData.colorScheme.textDefault, ZetaColorBase.cool.shade90);
      expect(themeData.colorScheme.textSubtle, ZetaColorBase.cool.shade70);
      expect(themeData.colorScheme.textDisabled, ZetaColorBase.cool.shade50);
      expect(themeData.colorScheme.textInverse, ZetaColorBase.cool.shade20);
      expect(themeData.colorScheme.surfacePrimary, ZetaColorBase.white);
      expect(themeData.colorScheme.surfaceSecondary, ZetaColorBase.cool.shade10);
      expect(themeData.colorScheme.surfaceTertiary, ZetaColorBase.warm.shade10);
      expect(themeData.colorScheme.surfaceDisabled, ZetaColorBase.cool.shade30);
      expect(themeData.colorScheme.surfaceHover, ZetaColorBase.cool.shade20);
      expect(themeData.colorScheme.surfaceSelected, ZetaColorBase.blue.shade10);
      expect(themeData.colorScheme.surfaceSelectedHover, ZetaColorBase.blue.shade20);
      expect(themeData.colorScheme.borderDefault, ZetaColorBase.cool.shade50);
      expect(themeData.colorScheme.borderSubtle, ZetaColorBase.cool.shade40);
      expect(themeData.colorScheme.borderDisabled, ZetaColorBase.cool.shade30);
      expect(themeData.colorScheme.borderSelected, ZetaColorBase.cool.shade90);
      expect(themeData.colorScheme.blue, ZetaColorBase.blue);
      expect(themeData.colorScheme.green, ZetaColorBase.green);
      expect(themeData.colorScheme.red, ZetaColorBase.red);
      expect(themeData.colorScheme.orange, ZetaColorBase.orange);
      expect(themeData.colorScheme.purple, ZetaColorBase.purple);
      expect(themeData.colorScheme.yellow, ZetaColorBase.yellow);
      expect(themeData.colorScheme.teal, ZetaColorBase.teal);
      expect(themeData.colorScheme.pink, ZetaColorBase.pink);
      expect(themeData.colorScheme.positive, ZetaColorBase.green);
      expect(themeData.colorScheme.negative, ZetaColorBase.red);
      expect(themeData.colorScheme.warning, ZetaColorBase.orange);
      expect(themeData.colorScheme.info, ZetaColorBase.purple);
    });
  });
}
