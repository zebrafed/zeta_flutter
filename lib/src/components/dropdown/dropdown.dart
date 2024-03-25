import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// Class for [ZetaDropDown]
class ZetaDropDown extends StatefulWidget {
  ///Constructor of [ZetaDropDown]
  const ZetaDropDown({
    super.key,
    required this.items,
    required this.onChange,
    required this.selectedItem,
    this.rounded = true,
    this.checkBoxType,
  });

  /// Input items as list of [ZetaDropdownItem]
  final List<ZetaDropdownItem> items;

  /// Currently selected item
  final ZetaDropdownItem selectedItem;

  /// Handles changes of dropdown menu
  final ValueSetter<ZetaDropdownItem> onChange;

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// If checkbox is to be shown and if its circular or square
  final CheckBoxType? checkBoxType;

  @override
  State<ZetaDropDown> createState() => _ZetaDropDownState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<CheckBoxType?>('checkBoxType', checkBoxType))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(ObjectFlagProperty<ValueSetter<ZetaDropdownItem>>.has(
          'onChange', onChange,),);
  }
}

class _ZetaDropDownState extends State<ZetaDropDown> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final _link = LayerLink();
  double? _buttonWidth;
  bool opened = false;

  GlobalKey menuKey = GlobalKey(); // declare a global key

  @override
  void initState() {
    super.initState();
  }

  /// Returns if click event position is within the header.
  bool isInHeader(
    Offset headerPosition,
    Size headerSize,
    Offset clickPosition,
  ) {
    return clickPosition.dx >= headerPosition.dx &&
        clickPosition.dx <= headerPosition.dx + headerSize.width &&
        clickPosition.dy >= headerPosition.dy &&
        clickPosition.dy <= headerPosition.dy + headerSize.height;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _tooltipController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment
                .bottomLeft, // Align overlay dropdown in its correct position
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: TapRegion(
                onTapOutside: (event) {
                  final headerBox =
                      menuKey.currentContext!.findRenderObject()! as RenderBox;

                  final headerPosition = headerBox.localToGlobal(Offset.zero);

                  if (!isInHeader(
                    headerPosition,
                    headerBox.size,
                    event.position,
                  )) _tooltipController.hide();
                },
                child: ZetaDropDownMenu(
                  items: widget.items,
                  selected: widget.selectedItem.value,
                  width: _buttonWidth,
                  boxType: widget.checkBoxType,
                  onPress: (item) {
                    if (item != null) {
                      widget.onChange(item);
                    }
                    _tooltipController.hide();
                  },
                ),
              ),
            ),
          );
        },
        child: widget.selectedItem.copyWith(
            round: widget.rounded,
            focus: _tooltipController.isShowing,
            press: onTap,
            itemKey: menuKey,),
      ),
    );
  }

  void onTap() {
    _buttonWidth = context.size?.width;
    if (!opened) {
      _tooltipController.toggle();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('opened', opened))
      ..add(
        DiagnosticsProperty<GlobalKey<State<StatefulWidget>>>(
          'menuKey',
          menuKey,
        ),
      );
  }
}

/// Checkbox enum for different checkbox types
enum CheckBoxType {
  /// Circular checkbox
  rounded,

  /// Square checkbox
  square
}

/// Class for [ZetaDropdownItem]
class ZetaDropdownItem extends StatefulWidget {
  ///Public constructor for [ZetaDropdownItem]
  const ZetaDropdownItem({
    super.key,
    required this.value,
    this.leadingIcon,
  })  : rounded = true,
        selected = false,
        checkBoxType = null,
        onPress = null;

  const ZetaDropdownItem._({
    super.key,
    required this.rounded,
    required this.selected,
    required this.value,
    this.leadingIcon,
    this.onPress,
    this.checkBoxType,
  });

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// If [ZetaDropdownItem] is selected
  final bool selected;

  /// Value of [ZetaDropdownItem]
  final String value;

  /// Leading icon for [ZetaDropdownItem]
  final Icon? leadingIcon;

  /// Handles clicking for [ZetaDropdownItem]
  final VoidCallback? onPress;

  /// If checkbox is to be shown, the type of it.
  final CheckBoxType? checkBoxType;

  /// Returns copy of [ZetaDropdownItem] with those private variables included
  ZetaDropdownItem copyWith({
    bool? round,
    bool? focus,
    CheckBoxType? boxType,
    VoidCallback? press,
    GlobalKey? itemKey,
  }) {
    return ZetaDropdownItem._(
      rounded: round ?? rounded,
      selected: focus ?? selected,
      onPress: press ?? onPress,
      checkBoxType: boxType ?? checkBoxType,
      value: value,
      leadingIcon: leadingIcon,
      key: itemKey ?? key,
    );
  }

  @override
  State<ZetaDropdownItem> createState() => _ZetaDropdownMenuItemState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('selected', selected))
      ..add(StringProperty('value', value))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPress', onPress))
      ..add(EnumProperty<CheckBoxType?>('checkBoxType', checkBoxType));
  }
}

class _ZetaDropdownMenuItemState extends State<ZetaDropdownItem> {
  final controller = MaterialStatesController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (context.mounted &&
          mounted &&
          !controller.value.contains(MaterialState.disabled)) {
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
        key: widget.key,
        onPressed: widget.onPress,
        style: _getStyle(colors),
        child: Row(
          children: [
            const SizedBox(width: ZetaSpacing.x3),
            if (widget.checkBoxType != null)
              Checkbox(
                value: widget.selected,
                shape: RoundedRectangleBorder(
                  borderRadius: widget.checkBoxType == CheckBoxType.square
                      ? ZetaRadius.none
                      : ZetaRadius.full,
                ),
                onChanged: (val) {
                  widget.onPress!.call();
                },
              ),
            const SizedBox(width: ZetaSpacing.x3),
            widget.leadingIcon ?? const SizedBox(width: 24),
            const SizedBox(width: ZetaSpacing.x3),
            Text(
              widget.value,
            ),
          ],
        ).paddingVertical(ZetaSpacing.x2_5),
      ),
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
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: widget.rounded ? ZetaRadius.minimal : ZetaRadius.none,
      ),),
      side: MaterialStatePropertyAll(
        widget.selected
            ? BorderSide(color: colors.primary.shade60)
            : BorderSide.none,
      ),
      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
      elevation: const MaterialStatePropertyAll(0),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialStatesController>(
        'controller', controller,),);
  }
}

///Class for [ZetaDropDownMenu]
class ZetaDropDownMenu extends StatefulWidget {
  ///Constructor for [ZetaDropDownMenu]
  const ZetaDropDownMenu(
      {super.key,
      required this.items,
      required this.onPress,
      required this.selected,
      this.rounded = false,
      this.width,
      this.boxType,});

  /// Input items for the menu
  final List<ZetaDropdownItem> items;

  ///Handles clicking of item in menu
  final ValueSetter<ZetaDropdownItem?> onPress;

  /// If item in menu is the currently selected item
  final String selected;

  /// {@macro zeta-component-rounded}
  final bool rounded;

  /// Width for menu
  final double? width;

  /// If items have checkboxes, the type of that checkbox.
  final CheckBoxType? boxType;

  @override
  State<ZetaDropDownMenu> createState() => _ZetaDropDownMenuState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<ValueSetter<ZetaDropdownItem?>>.has(
          'onPress', onPress,),)
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DoubleProperty('width', width))
      ..add(EnumProperty<CheckBoxType?>('boxType', boxType))
      ..add(StringProperty('selected', selected));
  }
}

class _ZetaDropDownMenuState extends State<ZetaDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: widget.rounded ? ZetaRadius.minimal : ZetaRadius.none,
        boxShadow: const [
          BoxShadow(blurRadius: 2, color: Color.fromRGBO(40, 51, 61, 0.04)),
          BoxShadow(
              blurRadius: 8,
              color: Color.fromRGBO(96, 104, 112, 0.16),
              blurStyle: BlurStyle.outer,
              offset: Offset(0, 4),),
        ],
      ),
      width: widget.width,
      child: Builder(builder: (BuildContext bcontext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.items.map((item) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              item.copyWith(
                round: widget.rounded,
                focus: widget.selected == item.value,
                boxType: widget.boxType,
                press: () {
                  widget.onPress(item);
                },
              ),
              const SizedBox(height: ZetaSpacing.x3),
            ],);
          }).toList(),
        );
      },),
    );
  }
}
