import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class NavigationRailExample extends StatefulWidget {
  static const String name = 'NavigationRail';

  const NavigationRailExample({Key? key}) : super(key: key);

  @override
  State<NavigationRailExample> createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<NavigationRailExample> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: 'Navigation Rail',
      child: Row(
        children: [
          ZetaNavigationRail(
            selectedIndex: _selectedIndex,
            onSelect: (index) => setState(() => _selectedIndex = index),
            items: [
              ZetaNavigationRailItem(
                label: Text('Label'),
                icon: Icon(ZetaIcons.star_round),
              ),
              ZetaNavigationRailItem(
                label: Text('Account\nSettings'),
                icon: Icon(ZetaIcons.star_round),
              ),
              ZetaNavigationRailItem(
                label: Text('Account Settings'),
                icon: Icon(ZetaIcons.star_round),
              ),
              ZetaNavigationRailItem(
                label: Text('Label'),
                icon: Icon(ZetaIcons.star_round),
                disabled: true,
              ),
            ],
          ),
          Expanded(child: const SizedBox()),
        ],
      ),
    );
  }
}
