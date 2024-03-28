import 'package:flutter/material.dart';
import '../../../zeta_flutter.dart';

/// [ZetaDateInput] size
enum ZetaDateInputSize {
  /// [large] 48 pixels height of the input field
  large,

  /// [medium] 40 pixels height of the input field
  medium,

  /// [small] 32 pixels height of the input field
  small,
}

/// Zeta Date Input.
///
/// Date Input allows entering date.
class ZetaDateInput extends StatefulWidget {
  /// Constructor for [ZetaDateInput].
  const ZetaDateInput({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.rounded = true,
    this.size = ZetaDateInputSize.large,
  });

  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final bool rounded;
  final ZetaDateInputSize size;

  @override
  State<ZetaDateInput> createState() => _ZetaDateInputState();
}

class _ZetaDateInputState extends State<ZetaDateInput> {
  final _controller = TextEditingController();
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.label!,
              style: ZetaTextStyles.bodyLarge.copyWith(height: 1.4),
            ),
          ),
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          style: ZetaTextStyles.bodyLarge.copyWith(height: 1.5),
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: _inputVerticalPadding(widget.size),
            ),
            hintText: 'mm/dd/yyyy',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_controller.text.isNotEmpty)
                  IconButton(
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                    icon: Icon(
                      widget.rounded ? ZetaIcons.cancel_round : ZetaIcons.cancel_sharp,
                      color: zeta.colors.cool.shade70,
                      size: _iconSize(widget.size),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 10),
                  child: Icon(
                    widget.rounded ? ZetaIcons.calendar_3_day_round : ZetaIcons.calendar_3_day_sharp,
                    color: zeta.colors.textDefault,
                    size: _iconSize(widget.size),
                  ),
                ),
              ],
            ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
            hintStyle: ZetaTextStyles.bodyLarge.copyWith(
              color: zeta.colors.cool.shade70,
              height: 1.5,
            ),
            filled: widget.enabled ? null : true,
            fillColor: widget.enabled ? null : zeta.colors.cool.shade30,
            enabledBorder: _defaultInputBorder(zeta, rounded: widget.rounded),
            focusedBorder: _focusedInputBorder(zeta, rounded: widget.rounded),
            disabledBorder: _defaultInputBorder(zeta, rounded: widget.rounded),
            errorBorder: _errorInputBorder(zeta, rounded: widget.rounded),
            focusedErrorBorder: _errorInputBorder(zeta, rounded: widget.rounded),
          ),
        ),
        if (widget.hint != null || (_hasError && widget.errorText != null))
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.info_rounded,
                    size: 16,
                    color: _hasError ? zeta.colors.red : zeta.colors.cool.shade70,
                  ),
                ),
                Expanded(
                  child: Text(
                    _hasError ? widget.errorText! : widget.hint!,
                    style: ZetaTextStyles.bodySmall.copyWith(
                      color: _hasError ? zeta.colors.red : zeta.colors.cool.shade70,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  double _inputVerticalPadding(ZetaDateInputSize size) => switch (size) {
        ZetaDateInputSize.large => 12,
        ZetaDateInputSize.medium => 8,
        ZetaDateInputSize.small => 4,
      };

  double _iconSize(ZetaDateInputSize size) => switch (size) {
        ZetaDateInputSize.large => 24,
        ZetaDateInputSize.medium => 20,
        ZetaDateInputSize.small => 16,
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
