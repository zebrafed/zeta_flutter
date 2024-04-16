import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// [ZetaNavigationRail]
class ZetaNavigationRail extends StatefulWidget {
  /// Constructor for [ZetaNavigationRail]
  const ZetaNavigationRail({
    super.key,
    required this.items,
    this.rounded = true,
  });

  /// Navigation items
  final List<ZetaNavigationRailItem> items;

  /// Determines if the items are rounded (default) or sharp.
  final bool rounded;

  @override
  State<ZetaNavigationRail> createState() => _ZetaNavigationRailState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('rounded', rounded));
  }
}

class _ZetaNavigationRailState extends State<ZetaNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: widget.items,
      ),
    );
  }
}

/// [ZetaNavigationRailItem]
class ZetaNavigationRailItem extends StatelessWidget {
  /// Constructor for [ZetaNavigationRailItem]
  const ZetaNavigationRailItem({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  });

  /// Item's label
  final Widget label;

  /// Optional item's icon.
  final Widget? icon;

  /// onTap callback
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 64,
        maxHeight: 64,
        minWidth: 64,
        minHeight: 64,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: zeta.colors.blue.shade10,
          borderRadius: ZetaRadius.rounded,
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                IconTheme(
                  data: IconThemeData(
                    color: zeta.colors.cool.shade70,
                    size: 24,
                  ),
                  child: icon!,
                ),
              DefaultTextStyle(
                style: ZetaTextStyles.titleSmall.copyWith(
                  color: zeta.colors.cool.shade70,
                ),
                child: label,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}
