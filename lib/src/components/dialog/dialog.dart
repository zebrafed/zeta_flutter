import 'package:flutter/material.dart';
import '../../../zeta_flutter.dart';

enum ZetaDialogSize {
  small,
  large,
}

enum ZetaDialogHeaderAlignment {
  left,
  center,
}

Future<bool?> showZetaDialog<T>(
  BuildContext context, {
  ZetaDialogSize size = ZetaDialogSize.small,
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
  bool barrierDismissible = true,
}) {
  final zeta = Zeta.of(context);
  return showDialog<bool?>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog(
      surfaceTintColor: zeta.colors.surfacePrimary,
      title: icon != null || title != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: switch (headerAlignment) {
                ZetaDialogHeaderAlignment.left => CrossAxisAlignment.start,
                ZetaDialogHeaderAlignment.center => CrossAxisAlignment.center,
              },
              children: [
                if (icon != null) icon,
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
      contentTextStyle: zetaTextTheme.bodyMedium?.copyWith(
        color: zeta.colors.textDefault,
      ),
      // actions: [],
    ),
  );
}
