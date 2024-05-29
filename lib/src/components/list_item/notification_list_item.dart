import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../zeta_flutter.dart';

/// List Item for notifications
class ZetaNotificationListItem extends StatefulWidget {
  /// Constructor for [ZetaNotificationListItem]
  const ZetaNotificationListItem({
    super.key,
    required this.notificationBadge,
    required this.message,
    required this.title,
    this.notificationTime,
    this.linkText,
    this.linkOnClick,
    required this.buttonOnClick,
    this.hasMore = false,
  });

  /// Notification Badge to indicate type of notification or who it's coming from
  final ZetaNotificationBadge notificationBadge;

  /// Notification message
  final String message;

  /// Notification title
  final String title;

  /// Time of notificaiton
  final String? notificationTime;

  /// Attached link text
  final String? linkText;

  /// Link onClick method
  final VoidCallback? linkOnClick;

  /// User actions button on click
  final VoidCallback buttonOnClick;

  /// If notification is a grouped and there are more notifications
  final bool? hasMore;

  @override
  State<ZetaNotificationListItem> createState() => _ZetaNotificationListItemState();

  /// Function that returns copy of a notification item with altered fields
  ZetaNotificationListItem copyWith(
      {ZetaNotificationBadge? notificationBadge,
      String? message,
      String? title,
      String? notificationTime,
      String? linkText,
      VoidCallback? linkOnClick,
      VoidCallback? buttonOnClick,
      bool? hasMore}) {
    return ZetaNotificationListItem(
      notificationBadge: notificationBadge ?? this.notificationBadge,
      message: message ?? this.message,
      title: title ?? this.title,
      notificationTime: notificationTime ?? this.notificationTime,
      linkText: linkText ?? this.linkText,
      linkOnClick: linkOnClick ?? this.linkOnClick,
      buttonOnClick: buttonOnClick ?? this.buttonOnClick,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('notificationTime', notificationTime))
      ..add(StringProperty('message', message))
      ..add(StringProperty('title', title))
      ..add(StringProperty('linkText', linkText))
      ..add(ObjectFlagProperty<VoidCallback?>.has('linkOnClick', linkOnClick))
      ..add(ObjectFlagProperty<VoidCallback>.has('buttonOnClick', buttonOnClick))
      ..add(DiagnosticsProperty<bool?>('hasMore', hasMore));
  }
}

class _ZetaNotificationListItemState extends State<ZetaNotificationListItem> {
  bool _notificationRead = false;

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return Container(
      width: 366,
      height: 160 + (widget.hasMore != null ? 4 : 0),
      decoration: _getStyle(colors),
      child: Column(
        children: [
          Row(
            children: [
              widget.notificationBadge,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (!_notificationRead)
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
                    SizedBox(
                      height: ZetaSpacing.x11,
                      child: Text(
                        widget.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ].gap(ZetaSpacing.x1),
                ),
              ),
            ].gap(ZetaSpacing.x2),
          ),
          if (widget.linkText != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(56, 0, 0, 0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _notificationRead = true;
                  });
                  widget.linkOnClick!.call();
                },
                child: Row(
                  children: [
                    Icon(
                      ZetaIcons.attachment_round,
                      size: ZetaSpacing.x3,
                      color: colors.primary,
                    ),
                    Text(
                      widget.linkText!,
                      style: TextStyle(fontSize: ZetaSpacing.x3, color: colors.primary),
                    )
                  ],
                ),
              ),
            )
          else
            const SizedBox.square(
              dimension: ZetaSpacing.x3,
            ),
          Container(
            alignment: Alignment.centerRight,
            child: ZetaButton(
              label: "User Action",
              size: ZetaWidgetSize.small,
              type: ZetaButtonType.outline,
              onPressed: () {
                setState(() {
                  _notificationRead = true;
                });
                widget.buttonOnClick.call();
              },
            ),
          )
        ].gap(ZetaSpacing.x2),
      ).paddingAll(ZetaSpacing.x2),
    );
  }

  BoxDecoration _getStyle(ZetaColors colors) {
    return BoxDecoration(
      color: _notificationRead ? colors.surfacePrimary : colors.surfaceSelected,
      borderRadius: ZetaRadius.rounded,
      border: (widget.hasMore ?? false) ? Border(bottom: BorderSide(width: ZetaSpacing.x1, color: colors.blue)) : null,
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
