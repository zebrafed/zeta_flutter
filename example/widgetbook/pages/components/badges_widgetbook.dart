import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../test/test_components.dart';
import '../../utils/utils.dart';

Widget statusLabelUseCase(BuildContext context) {
  final bool rounded = roundedKnob(context);

  return WidgetbookTestWidget(
    widget: Padding(
      padding: const EdgeInsets.all(ZetaSpacing.m),
      child: ZetaStatusLabel(
        label: context.knobs.string(label: 'Label', initialValue: 'Label'),
        rounded: rounded,
        status: context.knobs.list(
          label: 'Status',
          labelBuilder: enumLabelBuilder,
          options: ZetaWidgetStatus.values,
        ),
        customIcon: iconKnob(context, rounded: rounded),
      ),
    ),
  );
}

Widget priorityPillUseCase(BuildContext context) => WidgetbookTestWidget(
      widget: Padding(
        padding: const EdgeInsets.all(ZetaSpacing.m),
        child: ZetaPriorityPill(
          index: context.knobs.string(label: 'Index'),
          priority: context.knobs.string(label: 'Label'),
          size: context.knobs.list<ZetaWidgetSize>(
            label: 'Size',
            options: ZetaWidgetSize.values,
            labelBuilder: (value) => value.name.capitalize(),
          ),
          type: context.knobs.list<ZetaPriorityPillType>(
            label: 'Priority',
            options: ZetaPriorityPillType.values,
            labelBuilder: (value) => value.name.capitalize(),
          ),
          rounded: context.knobs.boolean(label: 'Rounded', initialValue: true),
          isBadge: context.knobs.boolean(label: 'Badge'),
        ),
      ),
    );

Widget badgeUseCase(BuildContext context) => WidgetbookTestWidget(
      widget: Padding(
        padding: const EdgeInsets.all(ZetaSpacing.m),
        child: ZetaBadge(
          label: context.knobs.string(label: 'Label', initialValue: 'Label'),
          rounded: roundedKnob(context),
          status: context.knobs.list(
            label: 'Status',
            options: ZetaWidgetStatus.values,
            labelBuilder: enumLabelBuilder,
          ),
        ),
      ),
    );

Widget indicatorsUseCase(BuildContext context) {
  final bool rounded = roundedKnob(context);

  return WidgetbookTestWidget(
    widget: Padding(
      padding: const EdgeInsets.all(ZetaSpacing.m),
      child: ZetaIndicator(
        type: context.knobs.list(
          label: 'Type',
          options: ZetaIndicatorType.values,
          labelBuilder: enumLabelBuilder,
        ),
        icon: iconKnob(context, rounded: rounded),
        inverse: context.knobs.boolean(label: 'Inverse Border'),
        size: context.knobs.list(
          label: 'Size',
          labelBuilder: enumLabelBuilder,
          options: ZetaWidgetSize.values,
        ),
        value: context.knobs.int.slider(label: 'Value'),
      ),
    ),
  );
}

Widget tagsUseCase(BuildContext context) => WidgetbookTestWidget(
      widget: Padding(
        padding: const EdgeInsets.all(ZetaSpacing.m),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZetaTag(
              label: context.knobs.string(label: 'Label', initialValue: 'Tag'),
              rounded: roundedKnob(context),
              direction: context.knobs.list(
                label: 'Direction',
                options: ZetaTagDirection.values,
                labelBuilder: enumLabelBuilder,
              ),
            ),
          ],
        ),
      ),
    );

Widget workcloudIndicatorsUseCase(BuildContext context) {
  final bool rounded = roundedKnob(context);

  return WidgetbookTestWidget(
    widget: Padding(
      padding: const EdgeInsets.all(ZetaSpacing.m),
      child: ZetaWorkcloudIndicator(
        index: context.knobs.string(label: 'Index', initialValue: '1'),
        label: context.knobs.string(label: 'Label', initialValue: 'Label'),
        prioritySize: context.knobs.list(
          label: 'Size',
          labelBuilder: enumLabelBuilder,
          options: ZetaWidgetSize.values,
        ),
        priorityType: context.knobs.list(
          label: 'Type',
          labelBuilder: enumLabelBuilder,
          options: ZetaWorkcloudIndicatorType.values,
        ),
        icon: iconKnob(context, rounded: rounded, nullable: true),
      ),
    ),
  );
}
