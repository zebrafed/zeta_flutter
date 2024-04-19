import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class SearchBarExample extends StatefulWidget {
  static const String name = 'SearchBar';

  const SearchBarExample({Key? key}) : super(key: key);

  @override
  State<SearchBarExample> createState() => _SearchBarExampleState();
}

class _SearchBarExampleState extends State<SearchBarExample> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: 'Search Bar',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Rounded', style: ZetaTextStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaSearchBar(
                hint: 'Search',
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Stadium', style: ZetaTextStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaSearchBar(
                hint: 'Search',
                shape: ZetaSearchBarShape.stadium,
                onSpeechToText: () async => 'I wanted to say...',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Sharp', style: ZetaTextStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaSearchBar(
                hint: 'Search',
                initialValue: 'Initial value',
                shape: ZetaSearchBarShape.sharp,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Disabled', style: ZetaTextStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaSearchBar(
                hint: 'Search',
                enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Medium', style: ZetaTextStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaSearchBar(
                hint: 'Search',
                size: ZetaSearchBarSize.medium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Small', style: ZetaTextStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZetaSearchBar(
                hint: 'Search',
                size: ZetaSearchBarSize.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
