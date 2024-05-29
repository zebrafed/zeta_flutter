import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class NotificationListItemExample extends StatefulWidget {
  static const String name = 'NotificationListItem';

  const NotificationListItemExample({super.key});

  @override
  State<NotificationListItemExample> createState() => _NotificationListItemExampleState();
}

class _NotificationListItemExampleState extends State<NotificationListItemExample> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: "NotificationListItem",
      child: Expanded(
        child: Container(
          child: Center(
              child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZetaNotificationListItem(
                  message: "New urgent message from Phil Starr that spans multiple lines but line count caps ...",
                  title: 'Urgent Message',
                  notificationBadge: ZetaNotificationBadge.icon(icon: ZetaIcons.check_circle_round),
                  notificationTime: "Just now",
                  linkOnClick: () {
                    print("Dounloading PDF");
                  },
                  linkText: "Spring-Donation-Drive.pdf",
                  buttonOnClick: () {
                    print("Button CLick");
                  },
                ),
                ZetaNotificationListItem(
                  message: "Message that is less then word limit",
                  title: 'Urgent Message',
                  notificationBadge: ZetaNotificationBadge.avatar(
                    avatar: ZetaAvatar.initials(
                      initials: "AO",
                    ),
                  ),
                  notificationTime: "5 minutes ago",
                  buttonOnClick: () {
                    print("Button CLick");
                  },
                  hasMore: true,
                ),
                ZetaNotificationListItem(
                  message: "New urgent message from Phil Starr that spans multiple lines but line count caps ...",
                  title: 'Urgent Message',
                  notificationBadge: ZetaNotificationBadge.image(
                    image: Image.network('https://picsum.photos/250?image=9'),
                  ),
                  linkOnClick: () {
                    print("Dounloading PDF");
                  },
                  linkText: "Spring-Donation-Drive.pdf",
                  buttonOnClick: () {
                    print("Button CLick");
                  },
                ),
              ].gap(ZetaSpacing.l),
            ),
          )),
        ),
      ),
    );
  }
}
