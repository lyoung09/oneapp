// @dart=2.9
import 'package:flutter/material.dart';

class MessageNotification extends StatelessWidget {
  final VoidCallback onReply;

  final String title;
  final String message;

  const MessageNotification({
    Key key,
    @required this.onReply,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(child: Image.asset('assets/img/Logo.png'))),
          title: Text(title),
          subtitle: Text(message),
          trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                if (onReply != null) onReply();
              }),
        ),
      ),
    );
  }
}
