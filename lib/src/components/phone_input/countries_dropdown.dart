import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// Class for [CountriesDropdown]
class CountriesDropdown<T> extends StatefulWidget {
  ///Constructor of [CountriesDropdown]
  const CountriesDropdown({
    super.key,
    required this.button,
    this.buttonSize = const Size(64, 48),
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  /// The button, which opens the dropdown.
  final Widget button;

  /// The size of the button.
  final Size? buttonSize;

  /// List of [DropdownMenuItem]
  final List<DropdownMenuItem<T>> items;

  /// Called when an item is selected.
  final ValueSetter<T?> onChanged;

  /// Determines if the dropdown should be enabled (default) or disabled.
  final bool enabled;

  @override
  State<CountriesDropdown<T>> createState() => _CountriesDropdownState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<DropdownMenuItem<T>>('items', items))
      ..add(ObjectFlagProperty<ValueSetter<T?>>.has('onChanged', onChanged))
      ..add(DiagnosticsProperty<Size?>('buttonSize', buttonSize))
      ..add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class _CountriesDropdownState<T> extends State<CountriesDropdown<T>> {
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.items.isEmpty
          ? null
          : () {
              final box = context.findRenderObject() as RenderBox?;
              final offset = box == null
                  ? Offset.zero
                  : box.size.centerRight(
                      box.localToGlobal(Offset.zero),
                    );
              _toggleItemsList(
                context,
                offset,
                box == null ? widget.buttonSize : box.size,
              );
            },
      child: widget.button,
    );
  }

  void _toggleItemsList(
    BuildContext context, [
    Offset? offset,
    Size? btnSize,
  ]) {
    if (widget.items.isEmpty || !widget.enabled) return;
    if (_isOpen) {
      _overlayEntry.remove();
    } else {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          final zeta = Zeta.of(context);
          return GestureDetector(
            onTap: () => _toggleItemsList(context),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(ZetaSpacing.x10),
                child: GestureDetector(
                  onTap: () {},
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: zeta.colors.surfaceSecondary,
                      borderRadius: ZetaRadius.minimal,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 3),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(.1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ZetaSpacing.s,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.items.map(
                            (item) {
                              return InkWell(
                                onTap: () {
                                  widget.onChanged(item.value);
                                  _toggleItemsList(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: ZetaSpacing.xs,
                                  ),
                                  child: item.child,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry);
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }
}
