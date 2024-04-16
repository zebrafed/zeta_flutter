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
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: 'Navigation Rail',
      child: ZetaNavigationRail(
        items: [
          ZetaNavigationRailItem(
            label: Text('Label'),
            icon: Icon(ZetaIcons.star_round),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
