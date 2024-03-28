import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class DateInputExample extends StatefulWidget {
  static const String name = 'DateInput';

  const DateInputExample({Key? key}) : super(key: key);

  @override
  State<DateInputExample> createState() => _DateInputExampleState();
}

class _DateInputExampleState extends State<DateInputExample> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: 'Date Input',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Rounded', style: ZetaTextStyles.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaDateInput(
                label: 'Label',
                hint: 'Default hint text',
                errorText: 'Oops! Error hint text',
              ),
            ),
            Divider(color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Sharp', style: ZetaTextStyles.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaDateInput(
                label: 'Label',
                hint: 'Default hint text',
                errorText: 'Oops! Error hint text',
                rounded: false,
              ),
            ),
            Divider(color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Disabled', style: ZetaTextStyles.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaDateInput(
                label: 'Label',
                hint: 'Default hint text',
                enabled: false,
              ),
            ),
            Divider(color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Medium', style: ZetaTextStyles.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaDateInput(
                label: 'Label',
                hint: 'Default hint text',
                errorText: 'Oops! Error hint text',
                size: ZetaDateInputSize.medium,
              ),
            ),
            Divider(color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Small', style: ZetaTextStyles.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaDateInput(
                label: 'Label',
                hint: 'Default hint text',
                errorText: 'Oops! Error hint text',
                size: ZetaDateInputSize.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
