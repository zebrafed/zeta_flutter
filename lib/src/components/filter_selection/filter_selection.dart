import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// Component [ZetaFilterSelection]
class ZetaFilterSelection extends StatelessWidget {
  /// Constructor for the component [ZetaFilterSelection]
  const ZetaFilterSelection({
    super.key,
    required this.items,
    this.rounded = true,
    this.onPressed,
  });

  /// The filter items - list of [ZetaFilterChip].
  final List<ZetaFilterChip> items;

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// Called on filter button pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ZetaSpacing.x11,
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPressed,
            icon: Icon(
              rounded ? ZetaIcons.filter_round : ZetaIcons.filter_sharp,
              size: ZetaSpacing.m,
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(ZetaSpacing.xxs),
              children: [
                for (int i = 0; i < items.length; i++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (i > 0) const SizedBox(width: 6),
                      items[i].copyWith(rounded: rounded),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}
