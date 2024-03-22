import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../test/test_components.dart';

Widget androidSwitchUseCase(BuildContext context) {
  bool? isOn = false;

  return WidgetbookTestWidget(
    widget: StatefulBuilder(
      builder: (context, setState) {
        ValueChanged<bool?>? onChanged = context.knobs.boolean(label: 'Enabled', initialValue: true)
            ? (value) => setState(() => isOn = value)
            : null;
        return Padding(
          padding: const EdgeInsets.all(ZetaSpacing.x5),
          child: Column(
            children: [
              Text('Android Switch'),
              ZetaSwitch.android(
                value: isOn,
                onChanged: onChanged,
              ),
              Text(isOn == true ? 'On' : 'Off'),
            ],
          ),
        );
      },
    ),
  );
}

Widget iosSwitchUseCase(BuildContext context) {
  bool? isOn = false;

  return WidgetbookTestWidget(
    widget: StatefulBuilder(
      builder: (context, setState) {
        ValueChanged<bool?>? onChanged = context.knobs.boolean(label: 'Enabled', initialValue: true)
            ? (value) => setState(() => isOn = value)
            : null;
        return Padding(
          padding: const EdgeInsets.all(ZetaSpacing.x5),
          child: Column(
            children: [
              Text('iOS Switch'),
              ZetaSwitch.ios(
                value: isOn,
                onChanged: onChanged,
              ),
              Text(isOn == true ? 'On' : 'Off'),
            ],
          ),
        );
      },
    ),
  );
}
