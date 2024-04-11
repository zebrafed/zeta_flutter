import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../zeta_flutter.dart';

/// ZetaPhoneInput allows entering phone numbers.
class ZetaPhoneInput extends StatefulWidget {
  /// Constructor for [ZetaPhoneInput].
  const ZetaPhoneInput({
    super.key,
    this.label,
    this.hint,
    this.enabled = true,
    this.rounded = true,
    this.hasError = false,
    this.errorText,
    this.onChanged,
    this.countryDialCode,
    this.phoneNumber,
  });

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

  /// A callback, which provides the entered phone number.
  final void Function(String?)? onChanged;

  /// The initial value for the country dial code including leading +
  final String? countryDialCode;

  /// The initial value for the phone number
  final String? phoneNumber;

  @override
  State<ZetaPhoneInput> createState() => _ZetaPhoneInputState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(StringProperty('hint', hint))
      ..add(DiagnosticsProperty<bool>('enabled', enabled))
      ..add(DiagnosticsProperty<bool>('rounded', rounded))
      ..add(DiagnosticsProperty<bool>('hasError', hasError))
      ..add(StringProperty('errorText', errorText))
      ..add(ObjectFlagProperty<void Function(String? p1)?>.has('onChanged', onChanged))
      ..add(StringProperty('countryDialCode', countryDialCode))
      ..add(StringProperty('phoneNumber', phoneNumber));
  }
}

class _ZetaPhoneInputState extends State<ZetaPhoneInput> {
  final _controller = TextEditingController();
  bool _hasError = false;
  late final List<ZetaDropdownItem> _countries;
  final _separator = ' ' * 12;
  late ZetaDropdownItem _selectedCountry;
  late String _phoneNumber;

  String _getCountryDialCode(ZetaDropdownItem item) => item.value.split(RegExp(r'\s+')).first;

  @override
  void initState() {
    super.initState();
    _countries = _allCountries.keys
        .map(
          (key) => ZetaDropdownItem(value: '$key$_separator${_allCountries[key]}'),
        )
        .toList();
    _selectedCountry = _countries.firstWhereOrNull(
          (item) => _getCountryDialCode(item) == widget.countryDialCode,
        ) ??
        _countries.first;
    _phoneNumber = widget.phoneNumber ?? '';
    _hasError = widget.hasError;
  }

  @override
  void didUpdateWidget(ZetaPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    _hasError = widget.hasError;
  }

  void _onChanged({ZetaDropdownItem? selectedCountry, String? phoneNumber}) {
    setState(() {
      if (selectedCountry != null) _selectedCountry = selectedCountry;
      if (phoneNumber != null) _phoneNumber = phoneNumber;
    });
    widget.onChanged?.call(
      _phoneNumber.isEmpty ? '' : '${_getCountryDialCode(_selectedCountry)} $_phoneNumber',
    );
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
        SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              ZetaDropdown(
                items: _countries,
                selectedItem: _selectedCountry,
                onChange: (value) => _onChanged(selectedCountry: value),
              ),
              Row(
                children: [
                  const SizedBox(width: 63),
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.phoneNumber,
                      enabled: widget.enabled,
                      controller: _controller,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]'))],
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => _onChanged(phoneNumber: value),
                      style: ZetaTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        hintStyle: ZetaTextStyles.bodyMedium.copyWith(
                          color: widget.enabled ? zeta.colors.textDefault : zeta.colors.cool.shade50,
                        ),
                        filled: true,
                        fillColor: widget.enabled
                            ? _hasError
                                ? zeta.colors.red.shade10
                                : zeta.colors.surfacePrimary
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
                  ),
                ],
              ),
            ],
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

  OutlineInputBorder _defaultInputBorder(
    Zeta zeta, {
    required bool rounded,
  }) =>
      OutlineInputBorder(
        borderRadius: rounded
            ? const BorderRadius.only(
                topRight: Radius.circular(ZetaSpacing.xxs),
                bottomRight: Radius.circular(ZetaSpacing.xxs),
              )
            : ZetaRadius.none,
        borderSide: BorderSide(color: zeta.colors.cool.shade40),
      );

  OutlineInputBorder _focusedInputBorder(
    Zeta zeta, {
    required bool rounded,
  }) =>
      OutlineInputBorder(
        borderRadius: rounded
            ? const BorderRadius.only(
                topRight: Radius.circular(ZetaSpacing.xxs),
                bottomRight: Radius.circular(ZetaSpacing.xxs),
              )
            : ZetaRadius.none,
        borderSide: BorderSide(color: zeta.colors.blue.shade50),
      );

  OutlineInputBorder _errorInputBorder(
    Zeta zeta, {
    required bool rounded,
  }) =>
      OutlineInputBorder(
        borderRadius: rounded
            ? const BorderRadius.only(
                topRight: Radius.circular(ZetaSpacing.xxs),
                bottomRight: Radius.circular(ZetaSpacing.xxs),
              )
            : ZetaRadius.none,
        borderSide: BorderSide(color: zeta.colors.red.shade50),
      );
}

final _allCountries = {
  '+1': 'USA',
  '+359': 'Bulgaria',
};
