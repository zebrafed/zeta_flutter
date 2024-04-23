import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// Class for [ZetaSelectInput]
class ZetaSelectInput extends StatefulWidget {
  ///Constructor of [ZetaSelectInput]
  const ZetaSelectInput({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.size,
    this.label,
    this.hint,
    this.enabled = true,
    this.required = false,
    this.rounded = true,
    this.hasError = false,
    this.errorText,
  });

  /// Input items as list of [ZetaSelectInputItem]
  final List<ZetaSelectInputItem> items;

  /// Currently selected item
  final ZetaSelectInputItem? selectedItem;

  /// Handles changes of select menu
  final ValueSetter<ZetaSelectInputItem> onChanged;

  /// Determines the size of the input field.
  /// Default is `ZetaDateInputSize.large`
  final ZetaWidgetSize? size;

  /// If provided, displays a label above the input field.
  final String? label;

  /// If provided, displays a hint below the input field.
  final String? hint;

  /// Determines if the input field should be enabled (default) or disabled.
  final bool enabled;

  /// Determines if the input field is required or not (default).
  final bool required;

  /// Determines if the input field should be displayed in error style.
  /// Default is `false`.
  /// If `enabled` is `false`, this has no effect.
  final bool hasError;

  /// In combination with `hasError: true`, provides the error message
  /// to be displayed below the input field.
  final String? errorText;

  /// {@macro zeta-component-rounded}
  final bool rounded;

  @override
  State<ZetaSelectInput> createState() => _ZetaSelectInputState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(
        ObjectFlagProperty<ValueSetter<ZetaSelectInputItem>>.has(
          'onChanged',
          onChanged,
        ),
      )
      ..add(EnumProperty<ZetaWidgetSize?>('size', size))
      ..add(StringProperty('label', label))
      ..add(StringProperty('hint', hint))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DiagnosticsProperty<bool>('hasError', hasError))
      ..add(StringProperty('errorText', errorText))
      ..add(DiagnosticsProperty<bool>('required', required));
  }
}

class _ZetaSelectInputState extends State<ZetaSelectInput> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final _link = LayerLink();
  late String? _selectedValue;
  late List<ZetaSelectInputItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedItem?.value;
    _menuItems = List.from(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomLeft,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: _ZetaSelectInputMenu(
                items: _menuItems,
                selected: _selectedValue,
                onSelected: (item) {
                  if (item != null) {
                    _selectedValue = item.value;
                    widget.onChanged(item);
                  }
                  _overlayController.hide();
                },
                rounded: widget.rounded,
              ),
            ),
          );
        },
        child: _InputComponent(
          size: widget.size,
          label: widget.label,
          hint: widget.hint,
          enabled: widget.enabled,
          required: widget.required,
          rounded: widget.rounded,
          hasError: widget.hasError,
          errorText: widget.errorText,
          initialValue: _selectedValue,
          onToggleMenu: widget.items.isEmpty ? null : () => setState(_overlayController.toggle),
          menuIsShowing: _overlayController.isShowing,
          onChanged: (value) {
            _selectedValue = value;
            _menuItems = widget.items
                .where(
                  (item) => item.value.toLowerCase().contains(value.toLowerCase()),
                )
                .toList();
            final item = widget.items.firstWhereOrNull(
              (item) => item.value.toLowerCase() == value.toLowerCase(),
            );
            if (item != null) {
              widget.onChanged(item);
            }
            setState(() {});
          },
        ),
      ),
    );
  }
}

class _InputComponent extends StatefulWidget {
  const _InputComponent({
    this.size,
    this.label,
    this.hint,
    this.enabled = true,
    this.required = false,
    this.rounded = true,
    this.hasError = false,
    this.errorText,
    this.initialValue,
    this.onChanged,
    this.onToggleMenu,
    this.menuIsShowing = false,
  });

  final ZetaWidgetSize? size;
  final String? label;
  final String? hint;
  final bool enabled;
  final bool required;
  final bool rounded;
  final bool hasError;
  final String? errorText;
  final String? initialValue;
  final void Function(String)? onChanged;
  final VoidCallback? onToggleMenu;
  final bool menuIsShowing;

  @override
  State<_InputComponent> createState() => _InputComponentState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZetaWidgetSize>('size', size))
      ..add(StringProperty('label', label))
      ..add(StringProperty('hint', hint))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('hasError', hasError))
      ..add(StringProperty('errorText', errorText))
      ..add(ObjectFlagProperty<void Function(String p1)?>.has('onChanged', onChanged))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onToggleMenu', onToggleMenu))
      ..add(DiagnosticsProperty<bool>('menuIsShowing', menuIsShowing))
      ..add(StringProperty('initialValue', initialValue))
      ..add(DiagnosticsProperty<bool>('required', required));
  }
}

class _InputComponentState extends State<_InputComponent> {
  final _controller = TextEditingController();
  late ZetaWidgetSize _size;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setParams();
  }

  @override
  void didUpdateWidget(_InputComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setParams();
  }

  void _setParams() {
    _controller.text = widget.initialValue ?? '';
    _size = widget.size ?? ZetaWidgetSize.large;
    _hasError = widget.hasError;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    final showError = _hasError && widget.errorText != null;
    final hintErrorColor = widget.enabled
        ? showError
            ? zeta.colors.red
            : zeta.colors.cool.shade70
        : zeta.colors.cool.shade50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.label!,
              style: ZetaTextStyles.bodyMedium.copyWith(
                color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
              ),
            ),
          ),
        TextFormField(
          enabled: widget.enabled,
          controller: _controller,
          onChanged: widget.onChanged,
          style: _size == ZetaWidgetSize.small ? ZetaTextStyles.bodyXSmall : ZetaTextStyles.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: _inputVerticalPadding(_size),
            ),
            suffixIcon: widget.onToggleMenu == null
                ? null
                : IconButton(
                    onPressed: widget.onToggleMenu,
                    icon: Icon(
                      widget.menuIsShowing
                          ? (widget.rounded ? ZetaIcons.expand_less_round : ZetaIcons.expand_less_sharp)
                          : (widget.rounded ? ZetaIcons.expand_more_round : ZetaIcons.expand_more_sharp),
                      color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
                      size: _iconSize(_size),
                    ),
                  ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: ZetaSpacing.m,
              minWidth: ZetaSpacing.m,
            ),
            hintStyle: _size == ZetaWidgetSize.small
                ? ZetaTextStyles.bodyXSmall.copyWith(
                    color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
                  )
                : ZetaTextStyles.bodyMedium.copyWith(
                    color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
                  ),
            filled: !widget.enabled || _hasError ? true : null,
            fillColor: widget.enabled
                ? _hasError
                    ? zeta.colors.red.shade10
                    : null
                : zeta.colors.cool.shade30,
            enabledBorder: _hasError
                ? _errorInputBorder(zeta, rounded: widget.rounded)
                : _defaultInputBorder(zeta, rounded: widget.rounded),
            focusedBorder: _hasError
                ? _errorInputBorder(zeta, rounded: widget.rounded)
                : _focusedInputBorder(zeta, rounded: widget.rounded),
            disabledBorder: _defaultInputBorder(zeta, rounded: widget.rounded),
            errorBorder: _errorInputBorder(zeta, rounded: widget.rounded),
            focusedErrorBorder: _errorInputBorder(zeta, rounded: widget.rounded),
          ),
        ),
        if (widget.hint != null || showError)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    showError && widget.enabled
                        ? (widget.rounded ? ZetaIcons.error_round : ZetaIcons.error_sharp)
                        : (widget.rounded ? ZetaIcons.info_round : ZetaIcons.info_sharp),
                    size: ZetaSpacing.b,
                    color: hintErrorColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    showError && widget.enabled ? widget.errorText! : widget.hint!,
                    style: ZetaTextStyles.bodyXSmall.copyWith(
                      color: hintErrorColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  double _inputVerticalPadding(ZetaWidgetSize size) => switch (size) {
        ZetaWidgetSize.large => ZetaSpacing.x3,
        ZetaWidgetSize.medium => ZetaSpacing.x2,
        ZetaWidgetSize.small => ZetaSpacing.x2,
      };

  double _iconSize(ZetaWidgetSize size) => switch (size) {
        ZetaWidgetSize.large => ZetaSpacing.x6,
        ZetaWidgetSize.medium => ZetaSpacing.x5,
        ZetaWidgetSize.small => ZetaSpacing.x4,
      };

  OutlineInputBorder _defaultInputBorder(
    Zeta zeta, {
    required bool rounded,
  }) =>
      OutlineInputBorder(
        borderRadius: rounded ? ZetaRadius.minimal : ZetaRadius.none,
        borderSide: BorderSide(color: zeta.colors.cool.shade40),
      );

  OutlineInputBorder _focusedInputBorder(
    Zeta zeta, {
    required bool rounded,
  }) =>
      OutlineInputBorder(
        borderRadius: rounded ? ZetaRadius.minimal : ZetaRadius.none,
        borderSide: BorderSide(color: zeta.colors.blue.shade50),
      );

  OutlineInputBorder _errorInputBorder(
    Zeta zeta, {
    required bool rounded,
  }) =>
      OutlineInputBorder(
        borderRadius: rounded ? ZetaRadius.minimal : ZetaRadius.none,
        borderSide: BorderSide(color: zeta.colors.red.shade50),
      );
}

/// Class for [ZetaSelectInputItem]
class ZetaSelectInputItem extends StatelessWidget {
  ///Public constructor for [ZetaSelectInputItem]
  const ZetaSelectInputItem({
    super.key,
    required this.value,
  })  : rounded = true,
        selected = false,
        onPressed = null;

  const ZetaSelectInputItem._({
    super.key,
    required this.rounded,
    required this.selected,
    required this.value,
    this.onPressed,
  });

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// If [ZetaSelectInputItem] is selected
  final bool selected;

  /// Value of [ZetaSelectInputItem]
  final String value;

  /// Handles clicking for [ZetaSelectInputItem]
  final VoidCallback? onPressed;

  /// Returns copy of [ZetaSelectInputItem] with those private variables included
  ZetaSelectInputItem copyWith({
    bool? rounded,
    bool? selected,
    VoidCallback? onPressed,
  }) {
    return ZetaSelectInputItem._(
      rounded: rounded ?? this.rounded,
      selected: selected ?? this.selected,
      onPressed: onPressed ?? this.onPressed,
      value: value,
      key: key,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(StringProperty('value', value))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;

    return DefaultTextStyle(
      style: ZetaTextStyles.bodyMedium,
      child: OutlinedButton(
        onPressed: onPressed,
        style: _getStyle(colors),
        child: Text(value),
      ).paddingVertical(ZetaSpacing.x2_5),
    );
  }

  ButtonStyle _getStyle(ZetaColors colors) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return colors.surfaceHovered;
        }

        if (states.contains(MaterialState.pressed)) {
          return colors.surfaceSelected;
        }

        if (states.contains(MaterialState.disabled) || onPressed == null) {
          return colors.surfaceDisabled;
        }
        return colors.surfacePrimary;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return colors.textDisabled;
        }
        return colors.textDefault;
      }),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: rounded ? ZetaRadius.minimal : ZetaRadius.none,
        ),
      ),
      side: MaterialStatePropertyAll(
        selected ? BorderSide(color: colors.primary.shade60) : BorderSide.none,
      ),
      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
      elevation: const MaterialStatePropertyAll(0),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    );
  }
}

class _ZetaSelectInputMenu extends StatelessWidget {
  const _ZetaSelectInputMenu({
    required this.items,
    required this.onSelected,
    this.selected,
    this.rounded = true,
  });

  /// Input items for the menu
  final List<ZetaSelectInputItem> items;

  /// Handles selecting an item from the menu
  final ValueSetter<ZetaSelectInputItem?> onSelected;

  /// The value of the currently selected item
  final String? selected;

  /// {@macro zeta-component-rounded}
  final bool rounded;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<ValueSetter<ZetaSelectInputItem?>>.has(
          'onSelected',
          onSelected,
        ),
      )
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(StringProperty('selected', selected));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: rounded ? ZetaRadius.minimal : ZetaRadius.none,
        boxShadow: const [
          BoxShadow(blurRadius: 2, color: Color.fromRGBO(40, 51, 61, 0.04)),
          BoxShadow(
            blurRadius: 8,
            color: Color.fromRGBO(96, 104, 112, 0.16),
            blurStyle: BlurStyle.outer,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Builder(
        builder: (BuildContext bcontext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  item.copyWith(
                    rounded: rounded,
                    selected: selected == item.value,
                    onPressed: () {
                      onSelected(item);
                    },
                  ),
                  const SizedBox(height: ZetaSpacing.x1),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
