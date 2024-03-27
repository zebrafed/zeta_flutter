import 'package:flutter/material.dart';
import '../../../zeta_flutter.dart';

class ZetaDateInput extends StatefulWidget {
  const ZetaDateInput({
    super.key,
    this.label,
    this.hint,
    this.errorText,
  });

  final String? label;
  final String? hint;
  final String? errorText;

  @override
  State<ZetaDateInput> createState() => _ZetaDateInputState();
}

class _ZetaDateInputState extends State<ZetaDateInput> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              widget.label!,
              style: ZetaTextStyles.bodyLarge,
            ),
          ),
        TextFormField(),
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
                    color: _hasError ? zetaColors.red : zetaColors.cool.shade70,
                  ),
                ),
                Expanded(
                  child: Text(
                    _hasError ? widget.errorText! : widget.hint!,
                    style: ZetaTextStyles.bodySmall.copyWith(
                      color: _hasError ? zetaColors.red : zetaColors.cool.shade70,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
