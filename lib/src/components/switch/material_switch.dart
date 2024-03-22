// ignore_for_file: prefer_asserts_with_message, diagnostic_describe_all_properties, public_member_api_docs

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;

class MaterialSwitch extends StatefulWidget {
  const MaterialSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.size,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
  })  : assert(activeThumbImage != null || onActiveThumbImageError == null),
        assert(inactiveThumbImage != null || onInactiveThumbImageError == null);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider? activeThumbImage;
  final ImageErrorListener? onActiveThumbImageError;
  final ImageProvider? inactiveThumbImage;
  final ImageErrorListener? onInactiveThumbImageError;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final MaterialStateProperty<Color?>? trackOutlineColor;
  final MaterialStateProperty<double?>? trackOutlineWidth;
  final MaterialStateProperty<Icon?>? thumbIcon;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final Size size;

  @override
  State<StatefulWidget> createState() => _MaterialSwitchState();
}

class _MaterialSwitchState extends State<MaterialSwitch> with TickerProviderStateMixin, ToggleableStateMixin {
  final _SwitchPainter _painter = _SwitchPainter();
  late final Size _size;
  late final _SwitchConfig switchConfig;

  @override
  void initState() {
    super.initState();
    switchConfig = _SwitchConfigM3(size: widget.size);
    _size = Size(switchConfig.switchWidth, switchConfig.switchHeightCollapsed);
  }

  @override
  void didUpdateWidget(MaterialSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      // During a drag we may have modified the curve, reset it if its possible
      // to do without visual discontinuation.
      if (position.value == 0.0 || position.value == 1.0) {
        updateCurve();
      }
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  void updateCurve() {
    if (Theme.of(context).useMaterial3) {
      position
        ..curve = Curves.easeOutBack
        ..reverseCurve = Curves.easeOutBack.flipped;
    } else {
      position
        ..curve = Curves.easeIn
        ..reverseCurve = Curves.easeOut;
    }
  }

  MaterialStateProperty<Color?> get _widgetThumbColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return widget.inactiveThumbColor;
      }
      if (states.contains(MaterialState.selected)) {
        return widget.activeColor;
      }
      return widget.inactiveThumbColor;
    });
  }

  MaterialStateProperty<Color?> get _widgetTrackColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return widget.activeTrackColor;
      }
      return widget.inactiveTrackColor;
    });
  }

  double get _trackInnerLength {
    return _size.width - _kSwitchMinSize;
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) {
      reactionController.forward();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / _trackInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          positionController.value -= delta;
        case TextDirection.ltr:
          positionController.value += delta;
      }
    }
  }

  bool _needsPositionAnimation = false;

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged?.call(!widget.value);
      // Wait with finishing the animation until widget.value has changed to
      // !widget.value as part of the widget.onChanged call above.
      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }
    reactionController.reverse();
  }

  void _handleChanged(bool? value) {
    assert(value != null);
    assert(widget.onChanged != null);
    widget.onChanged?.call(value!);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final ThemeData theme = Theme.of(context);
    final SwitchThemeData switchTheme = SwitchTheme.of(context);
    final SwitchThemeData defaults = _SwitchDefaultsM3(context, size: widget.size);

    positionController.duration = Duration(milliseconds: switchConfig.toggleDuration);

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states..remove(MaterialState.selected);

    final Color? activeThumbColor = widget.thumbColor?.resolve(activeStates) ??
        _widgetThumbColor.resolve(activeStates) ??
        switchTheme.thumbColor?.resolve(activeStates);
    final Color effectiveActiveThumbColor = activeThumbColor ?? defaults.thumbColor!.resolve(activeStates)!;
    final Color? inactiveThumbColor = widget.thumbColor?.resolve(inactiveStates) ??
        _widgetThumbColor.resolve(inactiveStates) ??
        switchTheme.thumbColor?.resolve(inactiveStates);
    final Color effectiveInactiveThumbColor = inactiveThumbColor ?? defaults.thumbColor!.resolve(inactiveStates)!;
    final Color effectiveActiveTrackColor = widget.trackColor?.resolve(activeStates) ??
        _widgetTrackColor.resolve(activeStates) ??
        switchTheme.trackColor?.resolve(activeStates) ??
        _widgetThumbColor.resolve(activeStates)?.withAlpha(0x80) ??
        defaults.trackColor!.resolve(activeStates)!;
    final Color? effectiveActiveTrackOutlineColor = widget.trackOutlineColor?.resolve(activeStates) ??
        switchTheme.trackOutlineColor?.resolve(activeStates) ??
        defaults.trackOutlineColor!.resolve(activeStates);
    final double? effectiveActiveTrackOutlineWidth = widget.trackOutlineWidth?.resolve(activeStates) ??
        switchTheme.trackOutlineWidth?.resolve(activeStates) ??
        defaults.trackOutlineWidth?.resolve(activeStates);

    final Color effectiveInactiveTrackColor = widget.trackColor?.resolve(inactiveStates) ??
        _widgetTrackColor.resolve(inactiveStates) ??
        switchTheme.trackColor?.resolve(inactiveStates) ??
        defaults.trackColor!.resolve(inactiveStates)!;
    final Color? effectiveInactiveTrackOutlineColor = widget.trackOutlineColor?.resolve(inactiveStates) ??
        switchTheme.trackOutlineColor?.resolve(inactiveStates) ??
        defaults.trackOutlineColor?.resolve(inactiveStates);
    final double? effectiveInactiveTrackOutlineWidth = widget.trackOutlineWidth?.resolve(inactiveStates) ??
        switchTheme.trackOutlineWidth?.resolve(inactiveStates) ??
        defaults.trackOutlineWidth?.resolve(inactiveStates);

    final Icon? effectiveActiveIcon =
        widget.thumbIcon?.resolve(activeStates) ?? switchTheme.thumbIcon?.resolve(activeStates);
    final Icon? effectiveInactiveIcon =
        widget.thumbIcon?.resolve(inactiveStates) ?? switchTheme.thumbIcon?.resolve(inactiveStates);

    final Color effectiveActiveIconColor = effectiveActiveIcon?.color ?? effectiveActiveThumbColor;
    final Color effectiveInactiveIconColor = effectiveInactiveIcon?.color ?? effectiveInactiveThumbColor;

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor = widget.overlayColor?.resolve(focusedStates) ??
        widget.focusColor ??
        switchTheme.overlayColor?.resolve(focusedStates) ??
        defaults.overlayColor!.resolve(focusedStates)!;

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor = widget.overlayColor?.resolve(hoveredStates) ??
        widget.hoverColor ??
        switchTheme.overlayColor?.resolve(hoveredStates) ??
        defaults.overlayColor!.resolve(hoveredStates)!;

    final Set<MaterialState> activePressedStates = activeStates..add(MaterialState.pressed);
    final Color effectiveActivePressedThumbColor = widget.thumbColor?.resolve(activePressedStates) ??
        _widgetThumbColor.resolve(activePressedStates) ??
        switchTheme.thumbColor?.resolve(activePressedStates) ??
        defaults.thumbColor!.resolve(activePressedStates)!;
    final Color effectiveActivePressedOverlayColor = widget.overlayColor?.resolve(activePressedStates) ??
        switchTheme.overlayColor?.resolve(activePressedStates) ??
        activeThumbColor?.withAlpha(kRadialReactionAlpha) ??
        defaults.overlayColor!.resolve(activePressedStates)!;

    final Set<MaterialState> inactivePressedStates = inactiveStates..add(MaterialState.pressed);
    final Color effectiveInactivePressedThumbColor = widget.thumbColor?.resolve(inactivePressedStates) ??
        _widgetThumbColor.resolve(inactivePressedStates) ??
        switchTheme.thumbColor?.resolve(inactivePressedStates) ??
        defaults.thumbColor!.resolve(inactivePressedStates)!;
    final Color effectiveInactivePressedOverlayColor = widget.overlayColor?.resolve(inactivePressedStates) ??
        switchTheme.overlayColor?.resolve(inactivePressedStates) ??
        inactiveThumbColor?.withAlpha(kRadialReactionAlpha) ??
        defaults.overlayColor!.resolve(inactivePressedStates)!;

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor =
        MaterialStateProperty.resolveWith<MouseCursor>((Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, states) ??
          switchTheme.mouseCursor?.resolve(states) ??
          defaults.mouseCursor!.resolve(states)!;
    });

    final double effectiveActiveThumbRadius =
        effectiveActiveIcon == null ? switchConfig.activeThumbRadius : switchConfig.thumbRadiusWithIcon;
    final double effectiveInactiveThumbRadius = effectiveInactiveIcon == null && widget.inactiveThumbImage == null
        ? switchConfig.inactiveThumbRadius
        : switchConfig.thumbRadiusWithIcon;
    final double effectiveSplashRadius = widget.splashRadius ?? switchTheme.splashRadius ?? defaults.splashRadius!;

    return Semantics(
      toggled: widget.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        dragStartBehavior: widget.dragStartBehavior,
        child: buildToggleable(
          mouseCursor: effectiveMouseCursor,
          focusNode: widget.focusNode,
          onFocusChange: widget.onFocusChange,
          autofocus: widget.autofocus,
          size: _size,
          painter: _painter
            ..position = position
            ..reaction = reaction
            ..reactionFocusFade = reactionFocusFade
            ..reactionHoverFade = reactionHoverFade
            ..inactiveReactionColor = effectiveInactivePressedOverlayColor
            ..reactionColor = effectiveActivePressedOverlayColor
            ..hoverColor = effectiveHoverOverlayColor
            ..focusColor = effectiveFocusOverlayColor
            ..splashRadius = effectiveSplashRadius
            ..downPosition = downPosition
            ..isFocused = states.contains(MaterialState.focused)
            ..isHovered = false //states.contains(MaterialState.hovered)
            ..activeColor = effectiveActiveThumbColor
            ..inactiveColor = effectiveInactiveThumbColor
            ..activePressedColor = effectiveActivePressedThumbColor
            ..inactivePressedColor = effectiveInactivePressedThumbColor
            ..activeThumbImage = widget.activeThumbImage
            ..onActiveThumbImageError = widget.onActiveThumbImageError
            ..inactiveThumbImage = widget.inactiveThumbImage
            ..onInactiveThumbImageError = widget.onInactiveThumbImageError
            ..activeTrackColor = effectiveActiveTrackColor
            ..activeTrackOutlineColor = effectiveActiveTrackOutlineColor
            ..activeTrackOutlineWidth = effectiveActiveTrackOutlineWidth
            ..inactiveTrackColor = effectiveInactiveTrackColor
            ..inactiveTrackOutlineColor = effectiveInactiveTrackOutlineColor
            ..inactiveTrackOutlineWidth = effectiveInactiveTrackOutlineWidth
            ..configuration = createLocalImageConfiguration(context)
            ..isInteractive = isInteractive
            ..trackInnerLength = _trackInnerLength
            ..textDirection = Directionality.of(context)
            ..surfaceColor = theme.colorScheme.surface
            ..inactiveThumbRadius = effectiveInactiveThumbRadius
            ..activeThumbRadius = effectiveActiveThumbRadius
            ..pressedThumbRadius = switchConfig.pressedThumbRadius
            ..thumbOffset = switchConfig.thumbOffset
            ..trackHeight = switchConfig.trackHeight
            ..trackWidth = switchConfig.trackWidth
            ..activeIconColor = effectiveActiveIconColor
            ..inactiveIconColor = effectiveInactiveIconColor
            ..activeIcon = effectiveActiveIcon
            ..inactiveIcon = effectiveInactiveIcon
            ..iconTheme = IconTheme.of(context)
            ..thumbShadow = switchConfig.thumbShadow
            ..positionController = positionController,
        ),
      ),
    );
  }
}

class _SwitchPainter extends ToggleablePainter {
  AnimationController get positionController => _positionController!;
  AnimationController? _positionController;
  set positionController(AnimationController? value) {
    assert(value != null);
    if (value == _positionController) {
      return;
    }
    _positionController = value;
    notifyListeners();
  }

  Icon? get activeIcon => _activeIcon;
  Icon? _activeIcon;
  set activeIcon(Icon? value) {
    if (value == _activeIcon) {
      return;
    }
    _activeIcon = value;
    notifyListeners();
  }

  Icon? get inactiveIcon => _inactiveIcon;
  Icon? _inactiveIcon;
  set inactiveIcon(Icon? value) {
    if (value == _inactiveIcon) {
      return;
    }
    _inactiveIcon = value;
    notifyListeners();
  }

  IconThemeData? get iconTheme => _iconTheme;
  IconThemeData? _iconTheme;
  set iconTheme(IconThemeData? value) {
    if (value == _iconTheme) {
      return;
    }
    _iconTheme = value;
    notifyListeners();
  }

  Color get activeIconColor => _activeIconColor!;
  Color? _activeIconColor;
  set activeIconColor(Color value) {
    if (value == _activeIconColor) {
      return;
    }
    _activeIconColor = value;
    notifyListeners();
  }

  Color get inactiveIconColor => _inactiveIconColor!;
  Color? _inactiveIconColor;
  set inactiveIconColor(Color value) {
    if (value == _inactiveIconColor) {
      return;
    }
    _inactiveIconColor = value;
    notifyListeners();
  }

  Color get activePressedColor => _activePressedColor!;
  Color? _activePressedColor;
  set activePressedColor(Color? value) {
    assert(value != null);
    if (value == _activePressedColor) {
      return;
    }
    _activePressedColor = value;
    notifyListeners();
  }

  Color get inactivePressedColor => _inactivePressedColor!;
  Color? _inactivePressedColor;
  set inactivePressedColor(Color? value) {
    assert(value != null);
    if (value == _inactivePressedColor) {
      return;
    }
    _inactivePressedColor = value;
    notifyListeners();
  }

  double get activeThumbRadius => _activeThumbRadius!;
  double? _activeThumbRadius;
  set activeThumbRadius(double value) {
    if (value == _activeThumbRadius) {
      return;
    }
    _activeThumbRadius = value;
    notifyListeners();
  }

  double get inactiveThumbRadius => _inactiveThumbRadius!;
  double? _inactiveThumbRadius;
  set inactiveThumbRadius(double value) {
    if (value == _inactiveThumbRadius) {
      return;
    }
    _inactiveThumbRadius = value;
    notifyListeners();
  }

  double get pressedThumbRadius => _pressedThumbRadius!;
  double? _pressedThumbRadius;
  set pressedThumbRadius(double value) {
    if (value == _pressedThumbRadius) {
      return;
    }
    _pressedThumbRadius = value;
    notifyListeners();
  }

  double? get thumbOffset => _thumbOffset;
  double? _thumbOffset;
  set thumbOffset(double? value) {
    if (value == _thumbOffset) {
      return;
    }
    _thumbOffset = value;
    notifyListeners();
  }

  double get trackHeight => _trackHeight!;
  double? _trackHeight;
  set trackHeight(double value) {
    if (value == _trackHeight) {
      return;
    }
    _trackHeight = value;
    notifyListeners();
  }

  double get trackWidth => _trackWidth!;
  double? _trackWidth;
  set trackWidth(double value) {
    if (value == _trackWidth) {
      return;
    }
    _trackWidth = value;
    notifyListeners();
  }

  ImageProvider? get activeThumbImage => _activeThumbImage;
  ImageProvider? _activeThumbImage;
  set activeThumbImage(ImageProvider? value) {
    if (value == _activeThumbImage) {
      return;
    }
    _activeThumbImage = value;
    notifyListeners();
  }

  ImageErrorListener? get onActiveThumbImageError => _onActiveThumbImageError;
  ImageErrorListener? _onActiveThumbImageError;
  set onActiveThumbImageError(ImageErrorListener? value) {
    if (value == _onActiveThumbImageError) {
      return;
    }
    _onActiveThumbImageError = value;
    notifyListeners();
  }

  ImageProvider? get inactiveThumbImage => _inactiveThumbImage;
  ImageProvider? _inactiveThumbImage;
  set inactiveThumbImage(ImageProvider? value) {
    if (value == _inactiveThumbImage) {
      return;
    }
    _inactiveThumbImage = value;
    notifyListeners();
  }

  ImageErrorListener? get onInactiveThumbImageError => _onInactiveThumbImageError;
  ImageErrorListener? _onInactiveThumbImageError;
  set onInactiveThumbImageError(ImageErrorListener? value) {
    if (value == _onInactiveThumbImageError) {
      return;
    }
    _onInactiveThumbImageError = value;
    notifyListeners();
  }

  Color get activeTrackColor => _activeTrackColor!;
  Color? _activeTrackColor;
  set activeTrackColor(Color value) {
    if (value == _activeTrackColor) {
      return;
    }
    _activeTrackColor = value;
    notifyListeners();
  }

  Color? get activeTrackOutlineColor => _activeTrackOutlineColor;
  Color? _activeTrackOutlineColor;
  set activeTrackOutlineColor(Color? value) {
    if (value == _activeTrackOutlineColor) {
      return;
    }
    _activeTrackOutlineColor = value;
    notifyListeners();
  }

  Color? get inactiveTrackOutlineColor => _inactiveTrackOutlineColor;
  Color? _inactiveTrackOutlineColor;
  set inactiveTrackOutlineColor(Color? value) {
    if (value == _inactiveTrackOutlineColor) {
      return;
    }
    _inactiveTrackOutlineColor = value;
    notifyListeners();
  }

  double? get activeTrackOutlineWidth => _activeTrackOutlineWidth;
  double? _activeTrackOutlineWidth;
  set activeTrackOutlineWidth(double? value) {
    if (value == _activeTrackOutlineWidth) {
      return;
    }
    _activeTrackOutlineWidth = value;
    notifyListeners();
  }

  double? get inactiveTrackOutlineWidth => _inactiveTrackOutlineWidth;
  double? _inactiveTrackOutlineWidth;
  set inactiveTrackOutlineWidth(double? value) {
    if (value == _inactiveTrackOutlineWidth) {
      return;
    }
    _inactiveTrackOutlineWidth = value;
    notifyListeners();
  }

  Color get inactiveTrackColor => _inactiveTrackColor!;
  Color? _inactiveTrackColor;
  set inactiveTrackColor(Color value) {
    if (value == _inactiveTrackColor) {
      return;
    }
    _inactiveTrackColor = value;
    notifyListeners();
  }

  ImageConfiguration get configuration => _configuration!;
  ImageConfiguration? _configuration;
  set configuration(ImageConfiguration value) {
    if (value == _configuration) {
      return;
    }
    _configuration = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    notifyListeners();
  }

  Color get surfaceColor => _surfaceColor!;
  Color? _surfaceColor;
  set surfaceColor(Color value) {
    if (value == _surfaceColor) {
      return;
    }
    _surfaceColor = value;
    notifyListeners();
  }

  bool get isInteractive => _isInteractive!;
  bool? _isInteractive;
  set isInteractive(bool value) {
    if (value == _isInteractive) {
      return;
    }
    _isInteractive = value;
    notifyListeners();
  }

  double get trackInnerLength => _trackInnerLength!;
  double? _trackInnerLength;
  set trackInnerLength(double value) {
    if (value == _trackInnerLength) {
      return;
    }
    _trackInnerLength = value;
    notifyListeners();
  }

  List<BoxShadow>? get thumbShadow => _thumbShadow;
  List<BoxShadow>? _thumbShadow;
  set thumbShadow(List<BoxShadow>? value) {
    if (value == _thumbShadow) {
      return;
    }
    _thumbShadow = value;
    notifyListeners();
  }

  final TextPainter _textPainter = TextPainter();
  Color? _cachedThumbColor;
  ImageProvider? _cachedThumbImage;
  ImageErrorListener? _cachedThumbErrorListener;
  BoxPainter? _cachedThumbPainter;

  ShapeDecoration _createDefaultThumbDecoration(Color color, ImageProvider? image, ImageErrorListener? errorListener) {
    return ShapeDecoration(
      color: color,
      image: image == null ? null : DecorationImage(image: image, onError: errorListener),
      shape: const StadiumBorder(),
    );
  }

  bool _isPainting = false;

  void _handleDecorationChanged() {
    // If the image decoration is available synchronously, we'll get called here
    // during paint. There's no reason to mark ourselves as needing paint if we
    // are already in the middle of painting. (In fact, doing so would trigger
    // an assert).
    if (!_isPainting) {
      notifyListeners();
    }
  }

  bool _stopPressAnimation = false;
  late double? _pressedThumbExtension;

  @override
  void paint(Canvas canvas, Size size) {
    final double currentValue = position.value;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
      case TextDirection.ltr:
        visualPosition = currentValue;
    }
    if (reaction.status == AnimationStatus.reverse && !_stopPressAnimation) {
      _stopPressAnimation = true;
    } else {
      _stopPressAnimation = false;
    }

    if (!_stopPressAnimation) {
      _pressedThumbExtension = 0;
    }

    Size? thumbSize = Size.fromRadius(pressedThumbRadius);

    // The thumb contracts slightly during the animation in Material 2.
    final double inset = thumbOffset == null ? 0 : 1.0 - (currentValue - thumbOffset!).abs() * 2.0;
    thumbSize = Size(thumbSize.width - inset, thumbSize.height - inset);

    final double colorValue =
        CurvedAnimation(parent: positionController, curve: Curves.easeOut, reverseCurve: Curves.easeIn).value;
    final Color trackColor = Color.lerp(inactiveTrackColor, activeTrackColor, colorValue)!;
    final Color? trackOutlineColor = inactiveTrackOutlineColor == null || activeTrackOutlineColor == null
        ? null
        : Color.lerp(inactiveTrackOutlineColor, activeTrackOutlineColor, colorValue);
    final double? trackOutlineWidth = lerpDouble(inactiveTrackOutlineWidth, activeTrackOutlineWidth, colorValue);
    Color lerpedThumbColor;
    if (!reaction.isDismissed) {
      lerpedThumbColor = Color.lerp(inactivePressedColor, activePressedColor, colorValue)!;
    } else if (positionController.status == AnimationStatus.forward) {
      lerpedThumbColor = Color.lerp(inactivePressedColor, activeColor, colorValue)!;
    } else if (positionController.status == AnimationStatus.reverse) {
      lerpedThumbColor = Color.lerp(inactiveColor, activePressedColor, colorValue)!;
    } else {
      lerpedThumbColor = Color.lerp(inactiveColor, activeColor, colorValue)!;
    }

    // Blend the thumb color against a `surfaceColor` background in case the
    // thumbColor is not opaque. This way we do not see through the thumb to the
    // track underneath.
    final Color thumbColor = Color.alphaBlend(lerpedThumbColor, surfaceColor);

    final Icon? thumbIcon = currentValue < 0.5 ? inactiveIcon : activeIcon;

    final ImageProvider? thumbImage = currentValue < 0.5 ? inactiveThumbImage : activeThumbImage;

    final ImageErrorListener? thumbErrorListener =
        currentValue < 0.5 ? onInactiveThumbImageError : onActiveThumbImageError;

    final Paint paint = Paint()..color = trackColor;

    final Offset trackPaintOffset = _computeTrackPaintOffset(size, trackWidth, trackHeight);
    final Offset thumbPaintOffset = _computeThumbPaintOffset(trackPaintOffset, thumbSize, visualPosition);
    final Offset radialReactionOrigin = Offset(thumbPaintOffset.dx + thumbSize.height / 2, size.height / 2);

    _paintTrackWith(canvas, paint, trackPaintOffset, trackOutlineColor, trackOutlineWidth);
    paintRadialReaction(canvas: canvas, origin: radialReactionOrigin);
    _paintThumbWith(
      thumbPaintOffset,
      canvas,
      colorValue,
      thumbColor,
      thumbImage,
      thumbErrorListener,
      thumbIcon,
      thumbSize,
      inset,
    );
  }

  /// Computes canvas offset for track's upper left corner
  Offset _computeTrackPaintOffset(Size canvasSize, double trackWidth, double trackHeight) {
    final double horizontalOffset = (canvasSize.width - trackWidth) / 2.0;
    final double verticalOffset = (canvasSize.height - trackHeight) / 2.0;

    return Offset(horizontalOffset, verticalOffset);
  }

  /// Computes canvas offset for thumb's upper left corner as if it were a
  /// square
  Offset _computeThumbPaintOffset(Offset trackPaintOffset, Size thumbSize, double visualPosition) {
    // How much thumb radius extends beyond the track
    final double trackRadius = trackHeight / 2;
    final double additionalThumbRadius = thumbSize.height / 2 - trackRadius;

    final double horizontalProgress = visualPosition * (trackInnerLength - _pressedThumbExtension!);
    final double thumbHorizontalOffset =
        trackPaintOffset.dx + trackRadius + (_pressedThumbExtension! / 2) - thumbSize.width / 2 + horizontalProgress;
    final double thumbVerticalOffset = trackPaintOffset.dy - additionalThumbRadius;
    return Offset(thumbHorizontalOffset, thumbVerticalOffset);
  }

  void _paintTrackWith(
    Canvas canvas,
    Paint paint,
    Offset trackPaintOffset,
    Color? trackOutlineColor,
    double? trackOutlineWidth,
  ) {
    final Rect trackRect = Rect.fromLTWH(
      trackPaintOffset.dx,
      trackPaintOffset.dy,
      trackWidth,
      trackHeight,
    );
    final double trackRadius = trackHeight / 2;
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRadius),
    );

    canvas.drawRRect(trackRRect, paint);

    // paint track outline
    if (trackOutlineColor != null) {
      final Rect outlineTrackRect = Rect.fromLTWH(
        trackPaintOffset.dx + 1,
        trackPaintOffset.dy + 1,
        trackWidth - 2,
        trackHeight - 2,
      );
      final RRect outlineTrackRRect = RRect.fromRectAndRadius(
        outlineTrackRect,
        Radius.circular(trackRadius),
      );

      final Paint outlinePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackOutlineWidth ?? 2.0
        ..color = trackOutlineColor;

      canvas.drawRRect(outlineTrackRRect, outlinePaint);
    }
  }

  void _paintThumbWith(
    Offset thumbPaintOffset,
    Canvas canvas,
    double currentValue,
    Color thumbColor,
    ImageProvider? thumbImage,
    ImageErrorListener? thumbErrorListener,
    Icon? thumbIcon,
    Size thumbSize,
    double inset,
  ) {
    try {
      _isPainting = true;
      if (_cachedThumbPainter == null ||
          thumbColor != _cachedThumbColor ||
          thumbImage != _cachedThumbImage ||
          thumbErrorListener != _cachedThumbErrorListener) {
        _cachedThumbColor = thumbColor;
        _cachedThumbImage = thumbImage;
        _cachedThumbErrorListener = thumbErrorListener;
        _cachedThumbPainter?.dispose();
        _cachedThumbPainter = _createDefaultThumbDecoration(thumbColor, thumbImage, thumbErrorListener)
            .createBoxPainter(_handleDecorationChanged);
      }
      _cachedThumbPainter!.paint(
        canvas,
        thumbPaintOffset,
        configuration.copyWith(size: thumbSize),
      );

      if (thumbIcon != null && thumbIcon.icon != null) {
        final Color iconColor = Color.lerp(inactiveIconColor, activeIconColor, currentValue)!;
        final double iconSize = thumbIcon.size ?? thumbSize.height;
        final IconData iconData = thumbIcon.icon!;
        final double? iconWeight = thumbIcon.weight ?? iconTheme?.weight;
        final double? iconFill = thumbIcon.fill ?? iconTheme?.fill;
        final double? iconGrade = thumbIcon.grade ?? iconTheme?.grade;
        final double? iconOpticalSize = thumbIcon.opticalSize ?? iconTheme?.opticalSize;
        final List<Shadow>? iconShadows = thumbIcon.shadows ?? iconTheme?.shadows;

        final TextSpan textSpan = TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontVariations: <FontVariation>[
              if (iconFill != null) FontVariation('FILL', iconFill),
              if (iconWeight != null) FontVariation('wght', iconWeight),
              if (iconGrade != null) FontVariation('GRAD', iconGrade),
              if (iconOpticalSize != null) FontVariation('opsz', iconOpticalSize),
            ],
            color: iconColor,
            fontSize: iconSize,
            inherit: false,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            shadows: iconShadows,
          ),
        );
        _textPainter
          ..textDirection = textDirection
          ..text = textSpan
          ..layout();
        final double additionalHorizontalOffset = (thumbSize.width - iconSize) / 2;
        final double additionalVerticalOffset = (thumbSize.height - iconSize) / 2;
        final Offset offset = thumbPaintOffset + Offset(additionalHorizontalOffset, additionalVerticalOffset);

        _textPainter.paint(canvas, offset);
      }
    } finally {
      _isPainting = false;
    }
  }

  @override
  void dispose() {
    _textPainter.dispose();
    _cachedThumbPainter?.dispose();
    _cachedThumbPainter = null;
    _cachedThumbColor = null;
    _cachedThumbImage = null;
    _cachedThumbErrorListener = null;
    super.dispose();
  }
}

mixin _SwitchConfig {
  double get trackHeight;
  double get trackWidth;
  double get switchWidth;
  double get switchHeight;
  double get switchHeightCollapsed;
  double get activeThumbRadius;
  double get inactiveThumbRadius;
  double get pressedThumbRadius;
  double get thumbRadiusWithIcon;
  List<BoxShadow>? get thumbShadow;
  double? get thumbOffset;
  int get toggleDuration;
}

// BEGIN GENERATED TOKEN PROPERTIES - Switch

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _SwitchDefaultsM3 extends SwitchThemeData {
  _SwitchDefaultsM3(this.context, {required this.size});

  final BuildContext context;
  final Size size;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  MaterialStateProperty<Color> get thumbColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return _colors.surface.withOpacity(1);
        }
        return _colors.onSurface.withOpacity(0.38);
      }
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.primaryContainer;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primaryContainer;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primaryContainer;
        }
        return _colors.onPrimary;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurfaceVariant;
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurfaceVariant;
      }
      return _colors.outline;
    });
  }

  @override
  MaterialStateProperty<Color> get trackColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        if (states.contains(MaterialState.selected)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        return _colors.surfaceVariant.withOpacity(0.12);
      }
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primary;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary;
        }
        return _colors.primary;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.surfaceVariant;
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.surfaceVariant;
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.surfaceVariant;
      }
      return _colors.surfaceVariant;
    });
  }

  @override
  MaterialStateProperty<Color?> get trackOutlineColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.transparent;
      }
      if (states.contains(MaterialState.disabled)) {
        return _colors.onSurface.withOpacity(0.12);
      }
      return _colors.outline;
    });
  }

  @override
  MaterialStateProperty<Color?> get overlayColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primary.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary.withOpacity(0.12);
        }
        return null;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.onSurface.withOpacity(0.12);
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurface.withOpacity(0.12);
      }
      return null;
    });
  }

  @override
  MaterialStateProperty<MouseCursor> get mouseCursor {
    return MaterialStateProperty.resolveWith(
      (Set<MaterialState> states) => MaterialStateMouseCursor.clickable.resolve(states),
    );
  }

  @override
  MaterialStatePropertyAll<double> get trackOutlineWidth => const MaterialStatePropertyAll<double>(2);

  @override
  double get splashRadius => size.height / 2 + 8;
}

class _SwitchConfigM3 with _SwitchConfig {
  _SwitchConfigM3({
    required this.size,
  });

  final Size size;

  @override
  double get activeThumbRadius => (size.height - 4) / 2;

  @override
  double get inactiveThumbRadius => (size.height - 4) / 2;

  @override
  double get pressedThumbRadius => (size.height - 4) / 2;

  @override
  double get switchHeight => _kSwitchMinSize + 8;

  @override
  double get switchHeightCollapsed => _kSwitchMinSize;

  @override
  double get switchWidth => trackWidth - 2 * (trackHeight / 2) + _kSwitchMinSize;

  @override
  double get thumbRadiusWithIcon => (size.height - 4) / 2;

  @override
  List<BoxShadow>? get thumbShadow => kElevationToShadow[0];

  @override
  double get trackHeight => size.height;

  @override
  double get trackWidth => size.width;

  // Hand coded default based on the animation specs.
  @override
  int get toggleDuration => 300;

  // Hand coded default based on the animation specs.
  @override
  double? get thumbOffset => null;
}

// END GENERATED TOKEN PROPERTIES - Switch
