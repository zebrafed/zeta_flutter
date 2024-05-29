import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

import '../../test/test_components.dart';

Widget notificationListItemUseCase(BuildContext context) => WidgetbookTestWidget(
      widget: ZetaNotificationListItem(
        message: context.knobs.string(label: "Message", initialValue: "Message"),
        title: context.knobs.string(label: "Title", initialValue: "Urgent Notification"),
        notificationTime: context.knobs.stringOrNull(label: "Notification Time", initialValue: "Just Now"),
        notificationBadge: context.knobs.list(
          label: 'Badge',
          options: [
            ZetaNotificationBadge.avatar(avatar: ZetaAvatar.initials(initials: "AO")),
            ZetaNotificationBadge.icon(icon: ZetaIcons.check_circle_round),
            ZetaNotificationBadge.image(
                image: Image.network(
                    "https://www.google.com/url?sa=i&url=https%3A%2F%2Fgithub.com%2Fzebratechnologies&psig=AOvVaw0fBPVE5gUkkpFw8mVf6B8G&ust=1717073069230000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPCwn-XxsoYDFQAAAAAdAAAAABAE"))
          ],
          labelBuilder: (value) => value.avatar != null
              ? "Avatar"
              : value.icon != null
                  ? "Icon"
                  : "Image",
        ),
        buttonOnClick: () {},
        linkText: context.knobs.stringOrNull(label: "Link Text"),
        linkOnClick: context.knobs.boolean(label: "Link Clickable") ? () {} : null,
        hasMore: context.knobs.booleanOrNull(label: "Has More"),
      ),
    );
