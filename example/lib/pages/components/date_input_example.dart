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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaDateInput(
                label: 'Label',
                hint: 'Default hint text',
                errorText: 'Oops! Error hint text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
