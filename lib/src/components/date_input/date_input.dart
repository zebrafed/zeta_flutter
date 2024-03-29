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
    this.hasError = false,
    this.size = ZetaDateInputSize.large,
  });

  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final bool rounded;
  final bool hasError;
  final ZetaDateInputSize size;

  @override
  State<ZetaDateInput> createState() => _ZetaDateInputState();
}

class _ZetaDateInputState extends State<ZetaDateInput> {
  final _controller = TextEditingController();
  bool _invalidDate = false;

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
              style: ZetaTextStyles.bodyLarge.copyWith(
                height: 1.33,
                color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
              ),
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
                    color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
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
              color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
              height: 1.5,
            ),
            filled: !widget.enabled || _invalidDate || widget.hasError ? true : null,
            fillColor: widget.enabled
                ? _invalidDate || widget.hasError
                    ? zeta.colors.red.shade10
                    : null
                : zeta.colors.cool.shade30,
            enabledBorder: _invalidDate || widget.hasError
                ? _errorInputBorder(zeta, rounded: widget.rounded)
                : _defaultInputBorder(zeta, rounded: widget.rounded),
            focusedBorder: _invalidDate || widget.hasError
                ? _errorInputBorder(zeta, rounded: widget.rounded)
                : _focusedInputBorder(zeta, rounded: widget.rounded),
            disabledBorder: _defaultInputBorder(zeta, rounded: widget.rounded),
            errorBorder: _errorInputBorder(zeta, rounded: widget.rounded),
            focusedErrorBorder: _errorInputBorder(zeta, rounded: widget.rounded),
          ),
        ),
        if (widget.hint != null || ((_invalidDate || widget.hasError) && widget.errorText != null))
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    (_invalidDate || widget.hasError) && widget.enabled
                        ? (widget.rounded ? ZetaIcons.error_round : ZetaIcons.error_sharp)
                        : (widget.rounded ? ZetaIcons.info_round : ZetaIcons.info_sharp),
                    size: 16,
                    color: widget.enabled
                        ? (_invalidDate || widget.hasError)
                            ? zeta.colors.red
                            : zeta.colors.cool.shade70
                        : zeta.colors.cool.shade50,
                  ),
                ),
                Expanded(
                  child: Text(
                    (_invalidDate || widget.hasError) && widget.enabled ? widget.errorText ?? '' : widget.hint!,
                    style: ZetaTextStyles.bodySmall.copyWith(
                      color: widget.enabled
                          ? (_invalidDate || widget.hasError) && widget.enabled
                              ? zeta.colors.red
                              : zeta.colors.cool.shade70
                          : zeta.colors.cool.shade50,
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
