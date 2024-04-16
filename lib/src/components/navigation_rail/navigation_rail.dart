import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// [ZetaNavigationRail]
class ZetaNavigationRail extends StatefulWidget {
  /// Constructor for [ZetaNavigationRail].
  const ZetaNavigationRail({
    super.key,
    required this.items,
    this.selectedIndex,
    this.onSelect,
    this.rounded = true,
  });

  /// Navigation items.
  final List<ZetaNavigationRailItem> items;

  /// Initially selected item form the list of `items`.
  final int? selectedIndex;

  /// Called when an item is selected.
  final void Function(int)? onSelect;

  /// Determines if the items are rounded (default) or sharp.
  final bool rounded;

  @override
  State<ZetaNavigationRail> createState() => _ZetaNavigationRailState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(ObjectFlagProperty<void Function(int p1)?>.has('onSelect', onSelect))
      ..add(IterableProperty<ZetaNavigationRailItem>('items', items));
  }
}

class _ZetaNavigationRailState extends State<ZetaNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          for (int i = 0; i < widget.items.length; i++)
            IntrinsicWidth(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: ZetaSpacing.xxs),
                    child: _ZetaNavigationRailItemContent(
                      label: widget.items[i].label,
                      icon: widget.items[i].icon,
                      selected: widget.selectedIndex == i,
                      disabled: widget.items[i].disabled,
                      onTap: () => widget.onSelect?.call(i),
                      rounded: widget.rounded,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ZetaNavigationRailItemContent extends StatelessWidget {
  const _ZetaNavigationRailItemContent({
    required this.label,
    this.icon,
    this.selected = false,
    this.disabled = false,
    this.onTap,
    this.rounded = true,
  });

  final Widget label;
  final Widget? icon;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: disabled ? null : onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: disabled
              ? null
              : selected
                  ? zeta.colors.blue.shade10
                  : null,
          borderRadius: rounded ? ZetaRadius.rounded : null,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 64,
            minHeight: 64,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ZetaSpacing.xs,
              vertical: ZetaSpacing.s,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  IconTheme(
                    data: IconThemeData(
                      color: disabled
                          ? zeta.colors.cool.shade50
                          : selected
                              ? zeta.colors.textDefault
                              : zeta.colors.cool.shade70,
                      size: 24,
                    ),
                    child: icon!,
                  ),
                DefaultTextStyle(
                  style: ZetaTextStyles.titleSmall.copyWith(
                    color: disabled
                        ? zeta.colors.cool.shade50
                        : selected
                            ? zeta.colors.textDefault
                            : zeta.colors.cool.shade70,
                  ),
                  child: label,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('disabled', disabled))
      ..add(DiagnosticsProperty<bool>('selected', selected));
  }
}

/// [ZetaNavigationRailItem]
class ZetaNavigationRailItem {
  /// Constructor for [ZetaNavigationRailItem].
  const ZetaNavigationRailItem({
    required this.label,
    this.icon,
    this.disabled = false,
  });

  /// Item's label.
  final Widget label;

  /// Optional item's icon.
  final Widget? icon;

  /// Indicates that this navigation item is inaccessible.
  final bool disabled;
}
