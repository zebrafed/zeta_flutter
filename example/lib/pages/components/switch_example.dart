import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class SwitchExample extends StatefulWidget {
  static const String name = 'Switch';

  const SwitchExample({Key? key}) : super(key: key);

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool? isOnAndroid = false, isOnIOS = false;
  bool isEnabledAndroid = true, isEnabledIOS = true;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: 'Switch',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Android'),
                ZetaSwitch.android(
                  value: isOnAndroid,
                  onChanged: isEnabledAndroid ? (value) => setState(() => isOnAndroid = value) : null,
                ),
                ZetaButton(
                  label: isEnabledAndroid ? 'Disable' : 'Enable',
                  onPressed: () => setState(() => isEnabledAndroid = !isEnabledAndroid),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('iOS'),
                ZetaSwitch.ios(
                  value: isOnIOS,
                  onChanged: isEnabledIOS ? (value) => setState(() => isOnIOS = value) : null,
                ),
                ZetaButton(
                  label: isEnabledIOS ? 'Disable' : 'Enable',
                  onPressed: () => setState(() => isEnabledIOS = !isEnabledIOS),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
