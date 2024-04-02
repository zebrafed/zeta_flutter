import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../test/test_components.dart';

Widget dateInputUseCase(BuildContext context) {
  String? _errorText;

  return WidgetbookTestWidget(
    widget: StatefulBuilder(
      builder: (context, setState) {
        final rounded = context.knobs.boolean(label: 'Rounded', initialValue: true);
        final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
        final size = context.knobs.listOrNull<ZetaDateInputSize>(
          label: 'Size',
          options: ZetaDateInputSize.values,
          labelBuilder: (type) => type?.name ?? '',
        );

        return Padding(
          padding: const EdgeInsets.all(ZetaSpacing.x5),
          child: ZetaDateInput(
            size: size,
            rounded: rounded,
            enabled: enabled,
            label: 'Birthdate',
            hint: 'Enter birthdate',
            hasError: _errorText != null,
            errorText: _errorText ?? 'Invalid date',
            onChanged: (value) {
              if (value == null) return setState(() => _errorText = null);
              setState(() => _errorText =
                  value.difference(DateTime.now()).inDays > 0 ? 'Birthdate cannot be in the future' : null);
            },
          ),
        );
      },
    ),
  );
}
