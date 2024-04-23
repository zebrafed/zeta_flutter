import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class SelectInputExample extends StatefulWidget {
  static const String name = "SelectInput";
  const SelectInputExample({super.key});

  @override
  State<SelectInputExample> createState() => _SelectInputExampleState();
}

class _SelectInputExampleState extends State<SelectInputExample> {
  ZetaSelectInputItem selectedItem = ZetaSelectInputItem(
    value: "Item 1",
  );

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: "Select Input",
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 320,
            child: Column(
              children: [
                ZetaSelectInput(
                  label: 'Label',
                  hint: 'Default hint text',
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                  selectedItem: selectedItem,
                  items: [
                    ZetaSelectInputItem(
                      value: "Item 1",
                    ),
                    ZetaSelectInputItem(
                      value: "Item 2",
                    ),
                    ZetaSelectInputItem(
                      value: "Item 3",
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
