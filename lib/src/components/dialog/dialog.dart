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
  final primaryButton = primaryButtonLabel == null
      ? null
      : ZetaButton(
          label: primaryButtonLabel,
          onPressed: onPrimaryButtonPressed ?? () => Navigator.of(context).pop(true),
          borderType: rounded ? ZetaWidgetBorder.rounded : ZetaWidgetBorder.sharp,
        );
  final secondaryButton = secondaryButtonLabel == null
      ? null
      : ZetaButton(
          type: ZetaButtonType.outlineSubtle,
          label: secondaryButtonLabel,
          onPressed: onSecondaryButtonPressed ?? () => Navigator.of(context).pop(false),
          borderType: rounded ? ZetaWidgetBorder.rounded : ZetaWidgetBorder.sharp,
        );
  final tertiaryButton = tertiaryButtonLabel == null
      ? null
      : TextButton(
          onPressed: onTertiaryButtonPressed,
          child: Text(tertiaryButtonLabel),
        );
  final hasButton = primaryButton != null || secondaryButton != null || tertiaryButton != null;
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
      titlePadding: context.deviceType == DeviceType.mobilePortrait
          ? null
          : const EdgeInsets.only(
              left: ZetaSpacing.x10,
              right: ZetaSpacing.x10,
              top: ZetaSpacing.m,
            ),
      titleTextStyle: zetaTextTheme.headlineSmall?.copyWith(
        color: zeta.colors.textDefault,
      ),
      content: Text(message),
      contentPadding: context.deviceType == DeviceType.mobilePortrait
          ? null
          : const EdgeInsets.only(
              left: ZetaSpacing.x10,
              right: ZetaSpacing.x10,
              top: ZetaSpacing.s,
              bottom: ZetaSpacing.m,
            ),
      contentTextStyle: context.deviceType == DeviceType.mobilePortrait
          ? zetaTextTheme.bodySmall?.copyWith(color: zeta.colors.textDefault)
          : zetaTextTheme.bodyMedium?.copyWith(color: zeta.colors.textDefault),
      actions: [
        if (context.deviceType == DeviceType.mobilePortrait)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasButton) const SizedBox(height: ZetaSpacing.m),
              if (tertiaryButton == null)
                Row(
                  children: [
                    if (secondaryButton != null) Expanded(child: secondaryButton),
                    if (primaryButton != null && secondaryButton != null) const SizedBox(width: ZetaSpacing.b),
                    if (primaryButton != null) Expanded(child: primaryButton),
                  ],
                )
              else ...[
                if (primaryButton != null) primaryButton,
                if (primaryButton != null && secondaryButton != null) const SizedBox(height: ZetaSpacing.s),
                if (secondaryButton != null) secondaryButton,
                if (primaryButton != null || secondaryButton != null) const SizedBox(height: ZetaSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [tertiaryButton],
                ),
              ],
            ],
          )
        else
          Row(
            children: [
              if (tertiaryButton != null) tertiaryButton,
              if (primaryButton != null || secondaryButton != null) ...[
                const SizedBox(width: ZetaSpacing.m),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (secondaryButton != null) secondaryButton,
                      if (primaryButton != null && secondaryButton != null) const SizedBox(width: ZetaSpacing.b),
                      if (primaryButton != null) primaryButton,
                      // const SizedBox(width: ZetaSpacing.s),
                    ],
                  ),
                ),
              ],
            ],
          ),
      ],
      actionsPadding: context.deviceType == DeviceType.mobilePortrait
          ? null
          : const EdgeInsets.symmetric(
              horizontal: ZetaSpacing.x10,
              vertical: ZetaSpacing.m,
            ),
    ),
  );
}
