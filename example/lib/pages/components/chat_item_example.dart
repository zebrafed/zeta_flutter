import 'package:flutter/material.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

class ChatItemExample extends StatefulWidget {
  static const String name = 'ChatItem';

  const ChatItemExample({Key? key}) : super(key: key);

  @override
  State<ChatItemExample> createState() => _ChatItemExampleState();
}

class _ChatItemExampleState extends State<ChatItemExample> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: 'Chat Item',
      child: SingleChildScrollView(
        child: Column(
          children: [
            ZetaChatItem(
              time: DateTime.now(),
              enabledWarningIcon: true,
              enabledNotificationIcon: true,
              leading: const ZetaAvatar(initials: 'AZ'),
              count: 100,
              onTap: () {},
              slidableActions: [
                ZetaSlidableAction.menuMore(onPressed: () {}),
                ZetaSlidableAction.call(onPressed: () {}),
                ZetaSlidableAction.ptt(onPressed: () {}),
                ZetaSlidableAction.delete(onPressed: () {}),
              ],
              title: Text("Chat name ID"),
              subtitle: Text(
                  "Dummy text to represent the first lines of most recent message dsadas dsa dsa ds dssd sd sdsd s ds"),
            ),
            ZetaChatItem(
              highlighted: true,
              time: DateTime.now(),
              count: 99,
              onTap: () {},
              slidableActions: [
                ZetaSlidableAction.menuMore(onPressed: () {}),
                ZetaSlidableAction.call(onPressed: () {}),
                ZetaSlidableAction.ptt(onPressed: () {}),
                ZetaSlidableAction.delete(onPressed: () {}),
              ],
              starred: true,
              leading: const ZetaAvatar(initials: 'ZA'),
              title: Text("Chat name ID"),
              subtitle: Text(
                "Dummy text to represent the first lines of most recent message",
              ),
            ),
          ].gap(ZetaSpacing.large),
        ),
      ),
    );
  }
}
