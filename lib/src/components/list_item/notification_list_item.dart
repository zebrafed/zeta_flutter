import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// List Item for notifications
class ZetaNotificationListItem extends StatefulWidget {
  /// Constructor for [ZetaNotificationListItem]
  const ZetaNotificationListItem({
    super.key,
    required this.leading,
    required this.body,
    required this.title,
    this.notificationRead = false,
    this.notificationTime,
    required this.action,
    this.showDivider = false,
  });

  /// Notification Badge to indicate type of notification or who it's coming from
  final ZetaNotificationBadge leading;

  /// Body of notification item
  final Widget body;

  /// Notification title
  final String title;

  /// If notification has been read
  final bool notificationRead;

  /// Time of notificaiton
  final String? notificationTime;

  /// If notification is a grouped and there are more notifications show divider.
  final bool? showDivider;

  /// Pass in a action widget to handle action functionality.
  final Widget action;

  @override
  State<ZetaNotificationListItem> createState() => _ZetaNotificationListItemState();

  /// Function that returns copy of a notification item with altered fields
  ZetaNotificationListItem copyWith(
      {ZetaNotificationBadge? leading,
      Widget? body,
      String? title,
      String? notificationTime,
      String? linkText,
      VoidCallback? linkOnClick,
      Widget? actionWidget,
      bool? showDivider}) {
    return ZetaNotificationListItem(
      leading: leading ?? this.leading,
      body: body ?? this.body,
      title: title ?? this.title,
      notificationTime: notificationTime ?? this.notificationTime,
      action: actionWidget ?? this.action,
      showDivider: showDivider ?? this.showDivider,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('notificationTime', notificationTime))
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<bool>('notificationRead', notificationRead))
      ..add(DiagnosticsProperty<bool?>('showDivider', showDivider));
  }
}

class _ZetaNotificationListItemState extends State<ZetaNotificationListItem> {
  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return DecoratedBox(
      decoration: _getStyle(colors),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.leading,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (!widget.notificationRead)
                              ZetaIndicator(
                                color: colors.blue,
                                size: ZetaWidgetSize.small,
                              ),
                            Text(
                              widget.title,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (widget.notificationTime != null) Text(widget.notificationTime!),
                            Container(
                              padding: const EdgeInsets.all(ZetaSpacing.x0_5),
                              decoration: BoxDecoration(color: colors.negative, borderRadius: ZetaRadius.full),
                              child: Icon(
                                ZetaIcons.important_notification_round,
                                color: colors.white,
                                size: ZetaSpacing.x3,
                              ),
                            )
                          ].gap(ZetaSpacing.x1),
                        )
                      ],
                    ),
                    widget.body
                  ].gap(ZetaSpacing.x1),
                ),
              ),
            ].gap(ZetaSpacing.x2),
          ),
          Container(alignment: Alignment.centerRight, child: widget.action)
        ],
      ).paddingAll(ZetaSpacing.x2),
    );
  }

  BoxDecoration _getStyle(ZetaColors colors) {
    return BoxDecoration(
      color: widget.notificationRead ? colors.surfacePrimary : colors.surfaceSelected,
      borderRadius: ZetaRadius.rounded,
      border:
          (widget.showDivider ?? false) ? Border(bottom: BorderSide(width: ZetaSpacing.x1, color: colors.blue)) : null,
    );
  }
}

extension on Image {
  /// Return copy of image with altered height and width
  Image copyWith({double? height, double? width, BoxFit? fit}) {
    return Image(
      height: height ?? this.height,
      width: width ?? this.width,
      fit: fit ?? this.fit,
      image: image,
    );
  }
}

/// Badge item for notification list items. Can be an avatar, icon or image
class ZetaNotificationBadge extends StatelessWidget {
  /// Constructs a notification badge with an avatar.
  const ZetaNotificationBadge.avatar({
    super.key,
    required this.avatar,
  })  : icon = null,
        iconColor = null,
        image = null;

  /// Constructs a notification badge with an icon.
  const ZetaNotificationBadge.icon({
    super.key,
    required this.icon,
    this.iconColor,
  })  : avatar = null,
        image = null;

  /// Constructs a notification badge with an image.
  const ZetaNotificationBadge.image({
    super.key,
    required this.image,
  })  : icon = null,
        iconColor = null,
        avatar = null;

  /// Avatar to display as notification badge.
  final ZetaAvatar? avatar;

  /// Image to display as notification badge.
  final Image? image;

  /// Icon to display as notification badge.
  final IconData? icon;

  /// Icon color for notification badge.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return avatar != null
        ? avatar!.copyWith(
            size: ZetaAvatarSize.m,
            lowerBadge: ZetaAvatarBadge.icon(icon: ZetaIcons.check_mark_round, color: colors.green),
            backgroundColor: colors.purple.shade80,
          )
        : icon != null
            ? Icon(
                icon,
                size: ZetaSpacing.x12,
                color: iconColor,
              )
            : ClipRRect(
                borderRadius: ZetaRadius.rounded,
                child: SizedBox.fromSize(
                  size: const Size.square(ZetaSpacing.x12), // Image radius
                  child: image!.copyWith(fit: BoxFit.cover),
                ),
              );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData?>('icon', icon))
      ..add(ColorProperty('iconColor', iconColor));
  }
}
