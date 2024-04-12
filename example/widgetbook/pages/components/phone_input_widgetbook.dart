import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../test/test_components.dart';

Widget phoneInputUseCase(BuildContext context) {
  return WidgetbookTestWidget(
    widget: StatefulBuilder(
      builder: (context, setState) {
        final rounded = context.knobs.boolean(label: 'Rounded', initialValue: true);
        final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

        return Padding(
          padding: const EdgeInsets.all(ZetaSpacing.x5),
          child: ZetaPhoneInput(
            rounded: rounded,
            enabled: enabled,
            label: 'Phone number',
            hint: 'Enter your phone number',
          ),
        );
      },
    ),
  );
}
