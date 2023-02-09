import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_real_time/services/auth_service.dart';

class ChatMessage extends StatelessWidget {

  final String uid;
  final String text;
  final AnimationController animationController;

  const ChatMessage({Key? key, required this.uid, required this.text, required this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService= Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == authService.user!.uid
              ? _myMessage()
              : _notMyMessage(),
        ),
      ),
    );
  }
  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(
          right: 5,
          bottom: 5,
          left: 50,
        ),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.start,),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(
          right: 50,
          bottom: 5,
          left: 5,
        ),
        decoration:  BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 20), textAlign: TextAlign.start, ),
      ),
    );
  }
}
