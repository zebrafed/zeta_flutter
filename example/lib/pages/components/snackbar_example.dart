import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class SnackBarExample extends StatelessWidget {
  static const String name = 'SnackBar';

  const SnackBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: SnackBarExample.name,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                // Standard Rounded
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: ZetaSpacing.x4),
                      child: ZetaButton.primary(
                        label: "Standard Rounded SnackBar",
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            ZetaSnackBar(
                              context: context,
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                              actionLabel: "Action",
                              content: Text('This is a snackbar'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Standard Sharp
                Padding(
                  padding: const EdgeInsets.only(top: ZetaSpacing.x4),
                  child: ZetaButton.primary(
                    label: "Standard Sharp SnackBar",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        ZetaSnackBar(
                          context: context,
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          actionLabel: "Action",
                          rounded: false,
                          content: Text('This is a snackbar'),
                        ),
                      );
                    },
                  ),
                ),

                // Default
                Padding(
                  padding: const EdgeInsets.only(top: ZetaSpacing.x4),
                  child: ZetaButton.primary(
                    label: "Contectual Default",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        ZetaSnackBar(
                          context: context,
                          type: ZetaSnackBarType.defaultType,
                          leadingIcon: Icon(Icons.mood_rounded),
                          content: Text('Message with icon'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum ZetaSnackBarType {
  defaultType,
  action,
  positive,
  info,
  warning,
  error,
  deletion,
  view,
}

class ZetaSnackBar extends SnackBar {
  ZetaSnackBar({
    required BuildContext context,
    required Widget content,
    VoidCallback? onPressed,
    ZetaSnackBarType? type,
    Icon? leadingIcon,
    bool rounded = true,
    EdgeInsetsGeometry? margin,
    String? actionLabel,
    SnackBarBehavior? behavior = SnackBarBehavior.floating,
  }) : super(
          padding: EdgeInsets.zero,
          backgroundColor: _getBackgroundColorForType(context, type),
          margin: margin,
          shape: RoundedRectangleBorder(
            borderRadius: type != null
                ? ZetaRadius.full
                : rounded
                    ? ZetaRadius.minimal
                    : ZetaRadius.none,
          ),
          behavior: behavior,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    _LeadingIcon(type, leadingIcon),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: ZetaSpacing.s),
                        child: _Content(type: type, child: content),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ZetaSpacing.s),
                child: _Action(
                  type: type,
                  actionLabel: actionLabel,
                  onPressed: onPressed,
                ),
              )
            ],
          ),
        );

  static Color _getBackgroundColorForType(
    BuildContext context,
    ZetaSnackBarType? type,
  ) {
    final colors = Zeta.of(context).colors;

    return switch (type) {
      _ => colors.warm.shade100,
    };
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.child, required this.type});

  final Widget child;
  final ZetaSnackBarType? type;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: ZetaTextStyles.bodyMedium,
      child: child,
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.type,
    required this.actionLabel,
    required this.onPressed,
  });

  final ZetaSnackBarType? type;
  final String? actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;

    return switch (type) {
      ZetaSnackBarType.defaultType => _IconButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
          color: colors.iconInverse,
        ),
      ZetaSnackBarType.action => _ActionButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
          label: actionLabel,
          color: colors.blue.shade50,
        ),
      ZetaSnackBarType.positive ||
      ZetaSnackBarType.info ||
      ZetaSnackBarType.warning ||
      ZetaSnackBarType.error =>
        _IconButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
          color: colors.cool.shade90,
        ),
      ZetaSnackBarType.deletion || ZetaSnackBarType.error => _IconButton(
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
          color: colors.cool.shade90,
        ),
      _ => _ActionButton(
          onPressed: onPressed,
          label: actionLabel,
          color: colors.blue.shade50,
        ),
    };
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.onPressed,
    required this.color,
  });

  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: color,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          ZetaIcons.close_round,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.label,
    required this.color,
  });

  final VoidCallback? onPressed;
  final String? label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(
        label ?? '',
        style: ZetaTextStyles.labelLarge.copyWith(color: color),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon(this.type, this.icon);

  final ZetaSnackBarType? type;
  final Icon? icon;

  Color _getIconColor(ZetaColors colors, ZetaSnackBarType? type) {
    return switch (type) {
      _ => colors.iconInverse,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;

    return Padding(
      padding: type != null || icon != null
          ? const EdgeInsets.only(left: ZetaSpacing.s)
          : EdgeInsets.zero,
      child: IconTheme(
        data: IconThemeData(
          color: _getIconColor(colors, type),
        ),
        child: switch (type) {
          _ => icon ?? SizedBox(),
        },
      ),
    );
  }
}
