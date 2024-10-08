import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../utils/scaffold.dart';
import '../../utils/utils.dart';

Widget selectInputUseCase(BuildContext context) {
  final items = [
    ZetaDropdownItem(
      value: "Item 1",
      icon: ZetaIcon(ZetaIcons.star),
    ),
    ZetaDropdownItem(
      value: "Item 2",
      icon: ZetaIcon(ZetaIcons.star_half),
    ),
    ZetaDropdownItem(
      value: "Item 3",
    ),
  ];
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Label',
  );
  final errorText = context.knobs.stringOrNull(
    label: 'Error message',
    initialValue: 'Oops! Error hint text',
  );
  final hintText = context.knobs.string(
    label: 'Hint',
    initialValue: 'Default hint text',
  );
  final disabled = disabledKnob(context);

  final size = context.knobs.list<ZetaWidgetSize>(
    label: 'Size',
    options: ZetaWidgetSize.values,
    labelBuilder: (size) => enumLabelBuilder(size),
  );

  final requirementLevel = context.knobs.list<ZetaFormFieldRequirement>(
    label: 'Requirement Level',
    options: ZetaFormFieldRequirement.values,
    labelBuilder: (requirementLevel) => enumLabelBuilder(requirementLevel),
  );

  return WidgetbookScaffold(
    builder: (context, _) => StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.all(Zeta.of(context).spacing.xl_2),
          child: ZetaSelectInput(
            disabled: disabled,
            size: size,
            items: items,
            label: label,
            hintText: hintText,
            requirementLevel: requirementLevel,
            errorText: errorText,
          ),
        );
      },
    ),
  );
}
