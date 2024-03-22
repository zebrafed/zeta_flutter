import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';
import 'material_switch.dart';

const _sizeAndroid = Size(48, 24);
const _sizeIOS = Size(56, 32);

/// Zeta Switch.
///
/// Switch can turn an option on or off.
class ZetaSwitch extends StatelessWidget {
  /// Constructor for [ZetaSwitch].
  const ZetaSwitch({
    super.key,
    this.value = false,
    this.onChanged,
    this.size,
  });

  /// Constructor for [ZetaSwitch] for the platform Android.
  const ZetaSwitch.android({
    super.key,
    this.value,
    this.onChanged,
  }) : size = _sizeAndroid;

  /// Constructor for [ZetaSwitch] for the platform Android.
  const ZetaSwitch.ios({
    super.key,
    this.value,
    this.onChanged,
  }) : size = _sizeIOS;

  /// Determines whether the switch is on or off.
  final bool? value;

  /// Called when the value of the switch should change.
  final ValueChanged<bool?>? onChanged;

  /// Determines the size of the switch.
  /// If not specified, the size will be determined
  /// depending on the Platform and predefined constants.
  final Size? size;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('value', value: value, ifTrue: 'on', ifFalse: 'off', showName: true))
      ..add(ObjectFlagProperty<ValueChanged<bool>>('onChanged', onChanged, ifNull: 'disabled'))
      ..add(DiagnosticsProperty<Size>('size', size));
  }

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;
    return MaterialSwitch(
      size: size == null
          ? Platform.isIOS
              ? _sizeIOS
              : _sizeAndroid
          : size!,
      trackOutlineWidth: const MaterialStatePropertyAll(0),
      trackOutlineColor: const MaterialStatePropertyAll(Colors.transparent),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return zetaColors.cool.shade30;
        } else {
          return states.contains(MaterialState.selected) ? zetaColors.primary : zetaColors.cool.shade50;
        }
      }),
      thumbColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.disabled) ? zetaColors.cool.shade50 : zetaColors.cool.shade20,
      ),
      value: value ?? false,
      onChanged: onChanged,
    );
  }
}
