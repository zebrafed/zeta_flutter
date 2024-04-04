import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class DialogExample extends StatefulWidget {
  static const String name = 'Dialog';

  const DialogExample({Key? key}) : super(key: key);

  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: 'Dialog',
      child: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => showZetaDialog(
                context,
                title: 'Dialog Title',
                message:
                    'Lorem ipsum dolor sit amet, conse ctetur adipiscing elit, sed do eiusm od tempor incididunt ut labore et do lore magna aliqua.',
              ),
              child: Text('Show dialog'),
            ),
          ],
        ),
      ),
    );
  }
}
