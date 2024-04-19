import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../zeta_flutter.dart';

/// [ZetaSearchBar] size
enum ZetaSearchBarSize {
  /// [large] 48 pixels height of the input field.
  large,

  /// [medium] 40 pixels height of the input field.
  medium,

  /// [small] 32 pixels height of the input field.
  small,
}

/// [ZetaSearchBar] shape
enum ZetaSearchBarShape {
  /// [rounded]
  rounded,

  /// [full]
  full,

  /// [sharp]
  sharp,
}

/// ZetaSearchBar provides input field for searching.
class ZetaSearchBar extends StatefulWidget {
  /// Constructor for [ZetaSearchBar].
  const ZetaSearchBar({
    super.key,
    this.size,
    this.shape,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.onSpeechToText,
    this.enabled = true,
  });

  /// Determines the size of the input field.
  /// Default is `ZetaSearchBarSize.large`
  final ZetaSearchBarSize? size;

  /// Determines the shape of the input field.
  /// Default is `ZetaSearchBarShape.rounded`
  final ZetaSearchBarShape? shape;

  /// If provided, displays a hint below the input field.
  final String? hint;

  /// The initial value.
  final String? initialValue;

  /// A callback, which provides the entered text.
  final void Function(String?)? onChanged;

  /// A callback, which is invoked when the microphone button is pressed.
  final Future<String?> Function()? onSpeechToText;

  /// Determines if the input field should be enabled (default) or disabled.
  final bool enabled;

  @override
  State<ZetaSearchBar> createState() => _ZetaSearchBarState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<ZetaSearchBarSize>('size', size))
      ..add(EnumProperty<ZetaSearchBarShape>('shape', shape))
      ..add(StringProperty('hint', hint))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(ObjectFlagProperty<void Function(String? p1)?>.has('onChanged', onChanged))
      ..add(StringProperty('initialValue', initialValue))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onSpeechToText', onSpeechToText));
  }
}

class _ZetaSearchBarState extends State<ZetaSearchBar> {
  late final TextEditingController _controller;
  late ZetaSearchBarSize _size;
  late ZetaSearchBarShape _shape;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _size = widget.size ?? ZetaSearchBarSize.large;
    _shape = widget.shape ?? ZetaSearchBarShape.rounded;
  }

  @override
  void didUpdateWidget(ZetaSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _size = widget.size ?? ZetaSearchBarSize.large;
    _shape = widget.shape ?? ZetaSearchBarShape.rounded;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);
    final sharp = widget.shape == ZetaSearchBarShape.sharp;
    final iconSize = _iconSize(_size);

    return TextFormField(
      enabled: widget.enabled,
      controller: _controller,
      keyboardType: TextInputType.text,
      onChanged: (value) => setState(() => widget.onChanged?.call(value)),
      style: ZetaTextStyles.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: _inputVerticalPadding(_size),
        ),
        hintText: widget.hint ?? 'Search',
        hintStyle: ZetaTextStyles.bodyMedium.copyWith(
          color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: ZetaSpacing.x2_5, right: ZetaSpacing.xs),
          child: Icon(
            sharp ? ZetaIcons.search_sharp : ZetaIcons.search_round,
            color: widget.enabled ? zeta.colors.cool.shade70 : zeta.colors.cool.shade50,
            size: iconSize,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: ZetaSpacing.m,
          minWidth: ZetaSpacing.m,
        ),
        suffixIcon: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty && widget.enabled) ...[
                IconButton(
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                  onPressed: () {
                    setState(_controller.clear);
                    widget.onChanged?.call('');
                  },
                  icon: Icon(
                    sharp ? ZetaIcons.cancel_sharp : ZetaIcons.cancel_round,
                    color: zeta.colors.cool.shade70,
                    size: iconSize,
                  ),
                ),
                SizedBox(
                  height: iconSize,
                  child: VerticalDivider(
                    color: zeta.colors.cool.shade40,
                    width: 5,
                    thickness: 1,
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(right: ZetaSpacing.xxs),
                child: IconButton(
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                  onPressed: widget.onSpeechToText == null
                      ? null
                      : () async {
                          final text = await widget.onSpeechToText!.call();
                          if (text != null) {
                            setState(() => _controller.text = text);
                            widget.onChanged?.call(text);
                          }
                        },
                  icon: Icon(
                    sharp ? ZetaIcons.microphone_sharp : ZetaIcons.microphone_round,
                    size: iconSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: ZetaSpacing.m,
          minWidth: ZetaSpacing.m,
        ),
        filled: widget.enabled ? null : true,
        fillColor: widget.enabled ? null : zeta.colors.cool.shade30,
        enabledBorder: _defaultInputBorder(zeta, shape: _shape),
        focusedBorder: _focusedInputBorder(zeta, shape: _shape),
        disabledBorder: _defaultInputBorder(zeta, shape: _shape),
      ),
    );
  }

  double _inputVerticalPadding(ZetaSearchBarSize size) => switch (size) {
        ZetaSearchBarSize.large => ZetaSpacing.x3,
        ZetaSearchBarSize.medium => ZetaSpacing.x2,
        ZetaSearchBarSize.small => ZetaSpacing.x1,
      };

  double _iconSize(ZetaSearchBarSize size) => switch (size) {
        ZetaSearchBarSize.large => ZetaSpacing.x6,
        ZetaSearchBarSize.medium => ZetaSpacing.x5,
        ZetaSearchBarSize.small => ZetaSpacing.x4,
      };

  OutlineInputBorder _defaultInputBorder(
    Zeta zeta, {
    required ZetaSearchBarShape shape,
  }) =>
      OutlineInputBorder(
        borderRadius: _borderRadius(shape),
        borderSide: BorderSide(color: zeta.colors.cool.shade40),
      );

  OutlineInputBorder _focusedInputBorder(
    Zeta zeta, {
    required ZetaSearchBarShape shape,
  }) =>
      OutlineInputBorder(
        borderRadius: _borderRadius(shape),
        borderSide: BorderSide(color: zeta.colors.blue.shade50),
      );

  BorderRadius _borderRadius(ZetaSearchBarShape shape) => switch (shape) {
        ZetaSearchBarShape.rounded => ZetaRadius.minimal,
        ZetaSearchBarShape.full => ZetaRadius.full,
        _ => ZetaRadius.none,
      };
}
