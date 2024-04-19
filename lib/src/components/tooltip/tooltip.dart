import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// [ZetaTooltip]
class ZetaTooltip extends StatelessWidget {
  /// Constructor for [ZetaTooltip].
  const ZetaTooltip({
    super.key,
    required this.child,
    this.rounded = true,
  });

  /// The content of the tooltip.
  final Widget child;

  /// Determines if the tooltip should have rounded (default) ot sharp corners.
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: zeta.colors.textDefault,
                borderRadius: rounded ? ZetaRadius.minimal : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ZetaSpacing.xs,
                  vertical: ZetaSpacing.xxs,
                ),
                child: DefaultTextStyle(
                  style: ZetaTextStyles.bodyXSmall.copyWith(
                    color: zeta.colors.textInverse,
                    fontWeight: FontWeight.w500,
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('rounded', rounded));
  }
}
