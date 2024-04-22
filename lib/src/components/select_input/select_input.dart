import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// Class for [ZetaSelectInput]
class ZetaSelectInput extends StatefulWidget {
  ///Constructor of [ZetaSelectInput]
  const ZetaSelectInput({
    super.key,
    required this.items,
    required this.onChange,
    required this.selectedItem,
    this.rounded = true,
    this.leadingType = LeadingStyle.none,
  });

  /// Input items as list of [ZetaSelectInputItem]
  final List<ZetaSelectInputItem> items;

  /// Currently selected item
  final ZetaSelectInputItem selectedItem;

  /// Handles changes of select menu
  final ValueSetter<ZetaSelectInputItem> onChange;

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// The style for the leading widget. Can be a checkbox or radio button
  final LeadingStyle leadingType;

  @override
  State<ZetaSelectInput> createState() => _ZetaSelectInputState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<LeadingStyle>('leadingType', leadingType))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(
        ObjectFlagProperty<ValueSetter<ZetaSelectInputItem>>.has(
          'onChange',
          onChange,
        ),
      );
  }
}

class _ZetaSelectInputState extends State<ZetaSelectInput> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final _link = LayerLink();
  final _menuKey = GlobalKey(); // declare a global key

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _tooltipController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomLeft,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: ZetaSelectInputMenu(
                items: widget.items,
                selected: widget.selectedItem.value,
                boxType: widget.leadingType,
                onPress: (item) {
                  if (item != null) {
                    widget.onChange(item);
                  }
                  _tooltipController.hide();
                },
              ),
            ),
          );
        },
        child: _InputComponent(
          onMenuOpen: widget.items.isEmpty ? null : _tooltipController.toggle,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>(
        'menuKey',
        _menuKey,
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
    this.rounded = true,
    this.hasError = false,
    this.errorText,
    this.onChanged,
    this.onMenuOpen,
  });

  /// Determines the size of the input field.
  /// Default is `ZetaInputComponentSize.large`
  final ZetaInputComponentSize? size;

  /// If provided, displays a label above the input field.
  final String? label;

  /// If provided, displays a hint below the input field.
  final String? hint;

  /// Determines if the input field should be enabled (default) or disabled.
  final bool enabled;

  /// Determines if the input field corners are rounded (default) or sharp.
  final bool rounded;

  /// Determines if the input field should be displayed in error style.
  /// Default is `false`.
  /// If `enabled` is `false`, this has no effect.
  final bool hasError;

  /// In combination with `hasError: true`, provides the error message
  /// to be displayed below the input field.
  final String? errorText;

  /// A callback, which provides the entered text.
  final void Function(String)? onChanged;

  /// A callback, which opens the menu.
  final VoidCallback? onMenuOpen;

  @override
  State<_InputComponent> createState() => _InputComponentState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZetaInputComponentSize>('size', size))
      ..add(StringProperty('label', label))
      ..add(StringProperty('hint', hint))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('hasError', hasError))
      ..add(StringProperty('errorText', errorText))
      ..add(ObjectFlagProperty<void Function(String p1)?>.has('onChanged', onChanged))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onMenuOpen', onMenuOpen));
  }
}

class _InputComponentState extends State<_InputComponent> {
  final _controller = TextEditingController();
  late ZetaInputComponentSize _size;
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
    _size = widget.size ?? ZetaInputComponentSize.large;
    _hasError = widget.hasError;
  }

  void _onChanged() {
    widget.onChanged?.call(_controller.text);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    final hasError = _hasError;
    final showError = hasError && widget.errorText != null;
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
          onChanged: (_) => _onChanged(),
          style: _size == ZetaInputComponentSize.small ? ZetaTextStyles.bodyXSmall : ZetaTextStyles.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: _inputVerticalPadding(_size),
            ),
            suffixIcon: widget.onMenuOpen == null
                ? null
                : IconButton(
                    onPressed: widget.onMenuOpen,
                    icon: Icon(
                      widget.rounded ? ZetaIcons.expand_more_round : ZetaIcons.expand_more_sharp,
                      color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
                      size: _iconSize(_size),
                    ),
                  ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: ZetaSpacing.m,
              minWidth: ZetaSpacing.m,
            ),
            hintStyle: _size == ZetaInputComponentSize.small
                ? ZetaTextStyles.bodyXSmall.copyWith(
                    color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
                  )
                : ZetaTextStyles.bodyMedium.copyWith(
                    color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
                  ),
            filled: !widget.enabled || hasError ? true : null,
            fillColor: widget.enabled
                ? hasError
                    ? zeta.colors.red.shade10
                    : null
                : zeta.colors.cool.shade30,
            enabledBorder: hasError
                ? _errorInputBorder(zeta, rounded: widget.rounded)
                : _defaultInputBorder(zeta, rounded: widget.rounded),
            focusedBorder: hasError
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

  double _inputVerticalPadding(ZetaInputComponentSize size) => switch (size) {
        ZetaInputComponentSize.large => ZetaSpacing.x3,
        ZetaInputComponentSize.medium => ZetaSpacing.x2,
        ZetaInputComponentSize.small => ZetaSpacing.x2,
      };

  double _iconSize(ZetaInputComponentSize size) => switch (size) {
        ZetaInputComponentSize.large => ZetaSpacing.x6,
        ZetaInputComponentSize.medium => ZetaSpacing.x5,
        ZetaInputComponentSize.small => ZetaSpacing.x4,
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

/// [ZetaInputComponentSize] size
enum ZetaInputComponentSize {
  /// [large] 48 pixels height of the input field.
  large,

  /// [medium] 40 pixels height of the input field.
  medium,

  /// [small] 32 pixels height of the input field.
  small,
}

/// Class for [ZetaSelectInputItem]
class ZetaSelectInputItem extends StatefulWidget {
  ///Public constructor for [ZetaSelectInputItem]
  const ZetaSelectInputItem({
    super.key,
    required this.value,
    this.leadingIcon,
  })  : rounded = true,
        selected = false,
        itemKey = null,
        onPress = null;

  const ZetaSelectInputItem._({
    super.key,
    required this.rounded,
    required this.selected,
    required this.value,
    this.leadingIcon,
    this.onPress,
    this.itemKey,
  });

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// If [ZetaSelectInputItem] is selected
  final bool selected;

  /// Value of [ZetaSelectInputItem]
  final String value;

  /// Leading icon for [ZetaSelectInputItem]
  final Icon? leadingIcon;

  /// Handles clicking for [ZetaSelectInputItem]
  final VoidCallback? onPress;

  /// Key for item
  final GlobalKey? itemKey;

  /// Returns copy of [ZetaSelectInputItem] with those private variables included
  ZetaSelectInputItem copyWith({
    bool? round,
    bool? focus,
    VoidCallback? press,
    GlobalKey? inputKey,
  }) {
    return ZetaSelectInputItem._(
      rounded: round ?? rounded,
      selected: focus ?? selected,
      onPress: press ?? onPress,
      itemKey: inputKey ?? itemKey,
      value: value,
      leadingIcon: leadingIcon,
      key: key,
    );
  }

  @override
  State<ZetaSelectInputItem> createState() => _ZetaSelectInputItemState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(StringProperty('value', value))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPress', onPress))
      ..add(
        DiagnosticsProperty<GlobalKey<State<StatefulWidget>>?>(
          'itemKey',
          itemKey,
        ),
      );
  }
}

class _ZetaSelectInputItemState extends State<ZetaSelectInputItem> {
  final controller = MaterialStatesController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (context.mounted && mounted && !controller.value.contains(MaterialState.disabled)) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;

    return DefaultTextStyle(
      style: ZetaTextStyles.bodyMedium,
      child: OutlinedButton(
        key: widget.itemKey,
        onPressed: widget.onPress,
        style: _getStyle(colors),
        child: Text(widget.value),
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

        if (states.contains(MaterialState.disabled) || widget.onPress == null) {
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
          borderRadius: widget.rounded ? ZetaRadius.minimal : ZetaRadius.none,
        ),
      ),
      side: MaterialStatePropertyAll(
        widget.selected ? BorderSide(color: colors.primary.shade60) : BorderSide.none,
      ),
      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
      elevation: const MaterialStatePropertyAll(0),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<MaterialStatesController>(
        'controller',
        controller,
      ),
    );
  }
}

///Class for [ZetaSelectInputMenu]
class ZetaSelectInputMenu extends StatefulWidget {
  ///Constructor for [ZetaSelectInputMenu]
  const ZetaSelectInputMenu({
    super.key,
    required this.items,
    required this.onPress,
    required this.selected,
    this.rounded = false,
    this.boxType,
  });

  /// Input items for the menu
  final List<ZetaSelectInputItem> items;

  ///Handles clicking of item in menu
  final ValueSetter<ZetaSelectInputItem?> onPress;

  /// If item in menu is the currently selected item
  final String selected;

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// If items have checkboxes, the type of that checkbox.
  final LeadingStyle? boxType;

  @override
  State<ZetaSelectInputMenu> createState() => _ZetaSelectInputMenuState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<ValueSetter<ZetaSelectInputItem?>>.has(
          'onPress',
          onPress,
        ),
      )
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(EnumProperty<LeadingStyle?>('boxType', boxType))
      ..add(StringProperty('selected', selected));
  }
}

class _ZetaSelectInputMenuState extends State<ZetaSelectInputMenu> {
  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: widget.rounded ? ZetaRadius.minimal : ZetaRadius.none,
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
            children: widget.items.map((item) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  item.copyWith(
                    round: widget.rounded,
                    focus: widget.selected == item.value,
                    press: () {
                      widget.onPress(item);
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
