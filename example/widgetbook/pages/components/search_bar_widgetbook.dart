import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../test/test_components.dart';

const List<String> _items = [
  'The quick...',
  'The quick brown...',
  'The quick brown fox...',
  'The quick brown fox jumped...',
  'The quick brown fox jumped into...',
  'The quick brown fox jumped into the hole...',
];

Widget searchBarUseCase(BuildContext context) {
  List<String> items = List.from(_items);
  return WidgetbookTestWidget(
    widget: StatefulBuilder(
      builder: (context, setState) {
        final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
        final size = context.knobs.list<ZetaSearchBarSize>(
          label: 'Size',
          options: ZetaSearchBarSize.values,
          labelBuilder: (size) => size.name,
        );
        final shape = context.knobs.list<ZetaSearchBarShape>(
          label: 'Shape',
          options: ZetaSearchBarShape.values,
          labelBuilder: (shape) => shape.name,
        );

        return Padding(
          padding: const EdgeInsets.all(ZetaSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ZetaSearchBar(
                size: size,
                shape: shape,
                enabled: enabled,
                hint: 'Search',
                onChanged: (value) {
                  if (value == null) return;
                  setState(
                    () => items = _items
                        .where((item) => item.toLowerCase().contains(
                              value.toLowerCase(),
                            ))
                        .toList(),
                  );
                },
                onStartSpeak: () async => 'Please take my words',
              ),
              const SizedBox(height: ZetaSpacing.x5),
              ...items.map((item) => Text(item)).toList(),
            ],
          ),
        );
      },
    ),
  );
}
