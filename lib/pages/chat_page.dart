import 'package:chat_real_time/widgets/chat_message_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  List<ChatMessage> msm = [
    // const ChatMessage(uid: "123asd", text: "muy bien te cunto que hoy fue mi primer dia de gym"),
    // const ChatMessage(uid: "123", text: "Hola que tal como estas"),
    // const ChatMessage(uid: "123asd", text: "Hola que tal"),
    // const ChatMessage(uid: "123", text: "Hola"),
  ];

  final _textController = TextEditingController();

  final _focusNode = FocusNode();

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kevin'),
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.lightGreen, size: 12),
                SizedBox(width: 3),
                Text('Online', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: msm.length,
                reverse: true,
                itemBuilder: (_, i) => msm[i],
              ),
            ),
            const Divider(height: 1, color: Colors.black),
            _boxInput(),
          ],
        ),
      ),
    );
  }

  Container _boxInput() {
    return Container(
      color: Colors.white,
      height: 50,
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: (_) => _handleSubmitted(_textController.text),
              onChanged: (value) {
                setState(() {
                  _isWriting = value.trim().isNotEmpty;
                });
              },
              focusNode: _focusNode,
              decoration: const InputDecoration.collapsed(
                hintText: 'Escribe un mensaje',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: IconTheme(
              data: const IconThemeData(color: Colors.blue),
              child: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.send,
                ),
                onPressed: _isWriting
                    ? () => _handleSubmitted(_textController.text.trim())
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _handleSubmitted(String text) {

    if (text.isEmpty) return;

    print(text);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: "123",
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400
        ),
      ),
    );
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
      msm.insert(0, newMessage);
    });
  }

  @override
  void dispose() {
    // TODO: off sockets
    for (ChatMessage message in msm) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
