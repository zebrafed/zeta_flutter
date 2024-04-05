import 'package:flutter/material.dart';
import '../../../zeta_flutter.dart';

enum ZetaDialogHeaderAlignment {
  left,
  center,
}

Future<bool?> showZetaDialog<T>(
  BuildContext context, {
  ZetaDialogHeaderAlignment headerAlignment = ZetaDialogHeaderAlignment.center,
  Widget? icon,
  String? title,
  required String message,
  String? primaryButtonLabel,
  VoidCallback? onPrimaryButtonPressed,
  String? secondaryButtonLabel,
  VoidCallback? onSecondaryButtonPressed,
  String? tertiaryButtonLabel,
  VoidCallback? onTertiaryButtonPressed,
  bool rounded = true,
  bool barrierDismissible = true,
}) {
  final zeta = Zeta.of(context);
  return showDialog<bool?>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog(
      surfaceTintColor: zeta.colors.surfacePrimary,
      shape: const RoundedRectangleBorder(borderRadius: ZetaRadius.large),
      title: icon != null || title != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: switch (headerAlignment) {
                ZetaDialogHeaderAlignment.left => CrossAxisAlignment.start,
                ZetaDialogHeaderAlignment.center => CrossAxisAlignment.center,
              },
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: ZetaSpacing.s),
                    child: icon,
                  ),
                if (title != null)
                  Text(
                    title,
                    textAlign: switch (headerAlignment) {
                      ZetaDialogHeaderAlignment.left => TextAlign.left,
                      ZetaDialogHeaderAlignment.center => TextAlign.center,
                    },
                  ),
              ],
            )
          : null,
      titleTextStyle: zetaTextTheme.headlineSmall?.copyWith(
        color: zeta.colors.textDefault,
      ),
      content: Text(message),
      contentTextStyle: context.deviceType == DeviceType.mobilePortrait
          ? zetaTextTheme.bodySmall?.copyWith(
              color: zeta.colors.textDefault,
            )
          : zetaTextTheme.bodyMedium?.copyWith(
              color: zeta.colors.textDefault,
            ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (tertiaryButtonLabel == null)
              Row(
                children: [
                  if (secondaryButtonLabel != null)
                    Expanded(
                      child: ZetaButton(
                        type: ZetaButtonType.outlineSubtle,
                        label: secondaryButtonLabel,
                        onPressed: onSecondaryButtonPressed ?? () => Navigator.of(context).pop(false),
                        borderType: rounded ? ZetaWidgetBorder.rounded : ZetaWidgetBorder.sharp,
                      ),
                    ),
                  if (primaryButtonLabel != null && secondaryButtonLabel != null) const SizedBox(width: ZetaSpacing.m),
                  if (primaryButtonLabel != null)
                    Expanded(
                      child: ZetaButton(
                        label: primaryButtonLabel,
                        onPressed: onPrimaryButtonPressed ?? () => Navigator.of(context).pop(true),
                        borderType: rounded ? ZetaWidgetBorder.rounded : ZetaWidgetBorder.sharp,
                      ),
                    ),
                ],
              ),
            if (tertiaryButtonLabel != null) ...[
              if (primaryButtonLabel != null)
                ZetaButton(
                  label: primaryButtonLabel,
                  onPressed: onPrimaryButtonPressed ?? () => Navigator.of(context).pop(true),
                  borderType: rounded ? ZetaWidgetBorder.rounded : ZetaWidgetBorder.sharp,
                ),
              if (primaryButtonLabel != null && secondaryButtonLabel != null) const SizedBox(height: ZetaSpacing.s),
              if (secondaryButtonLabel != null)
                ZetaButton(
                  type: ZetaButtonType.outlineSubtle,
                  label: secondaryButtonLabel,
                  onPressed: onSecondaryButtonPressed ?? () => Navigator.of(context).pop(false),
                  borderType: rounded ? ZetaWidgetBorder.rounded : ZetaWidgetBorder.sharp,
                ),
              if (primaryButtonLabel != null || secondaryButtonLabel != null) const SizedBox(height: ZetaSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: onTertiaryButtonPressed,
                    child: Text(tertiaryButtonLabel),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
