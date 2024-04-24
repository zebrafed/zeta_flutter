import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class SelectInputExample extends StatefulWidget {
  static const String name = 'SelectInput';
  const SelectInputExample({super.key});

  @override
  State<SelectInputExample> createState() => _SelectInputExampleState();
}

class _SelectInputExampleState extends State<SelectInputExample> {
  String? _errorText;
  ZetaSelectInputItem? selectedItem = ZetaSelectInputItem(
    value: 'Item 1',
  );

  @override
  Widget build(BuildContext context) {
    final zeta = Zeta.of(context);

    return ExampleScaffold(
      name: 'Select Input',
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 320,
            child: Column(
              children: [
                ZetaSelectInput(
                  label: Row(
                    children: [
                      Text('Label'),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          '*',
                          style: TextStyle(color: zeta.colors.red.shade60),
                        ),
                      ),
                    ],
                  ),
                  hint: 'Default hint text',
                  leadingIcon: Icon(ZetaIcons.star_round),
                  hasError: _errorText != null,
                  errorText: _errorText,
                  onChanged: (item) {
                    setState(() {
                      selectedItem = item;
                      if (item?.value == 'Item 3') {
                        _errorText = 'Item 3 is not allowed!';
                      } else {
                        _errorText = null;
                      }
                    });
                  },
                  selectedItem: selectedItem,
                  items: [
                    ZetaSelectInputItem(
                      value: 'Item 1',
                    ),
                    ZetaSelectInputItem(
                      value: 'Item 2',
                    ),
                    ZetaSelectInputItem(
                      value: 'Item 3',
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
