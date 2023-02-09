import 'package:chat_real_time/models/message_response.dart';
import 'package:chat_real_time/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_real_time/services/chat_service.dart';
import 'package:chat_real_time/services/socket_service.dart';

import 'package:chat_real_time/widgets/chat_message_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  List<ChatMessage> msm = [
    // const ChatMessage(uid: "123asd", text: "muy bien te cunto que hoy fue mi primer dia de gym"),
    // const ChatMessage(uid: "123", text: "Hola que tal como estas"),
    // const ChatMessage(uid: "123asd", text: "Hola que tal"),
    // const ChatMessage(uid: "123", text: "Hola"),
  ];

  final _textController = TextEditingController();

  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  bool _isWriting = false;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on("private-message", _listenMessage);
    socketService.socket.on("user-writting", _listenWritting);

    _loadHistory(chatService.userTo.uid);
  }

  void _listenWritting(dynamic payload) {
    if (payload["from"] == chatService.userTo.uid) {
      setState(() {
        chatService.userTo.writting = payload["writting"];
      });
    }
  }

  void _loadHistory(String userId) async {
    List<Message> messages = await chatService.getChat(userId);
    final history = messages.map((m) => ChatMessage(
        uid: m.from,
        text: m.message,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward()));
    setState(() {
      msm.insertAll(0, history);
    });
    _loading = false;
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
        uid: payload["from"],
        text: payload["message"],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));

    setState(() {
      msm.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userTo.name),
            Row(
              children: [
                Icon(
                  userTo.online
                      ? Icons.check_circle
                      : Icons.remove_circle_rounded,
                  color: userTo.online ? Colors.lightGreen : Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 3),
                Text(
                  userTo.online ? "Online" : "Offline",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 3),
                chatService.userTo.writting
                    ? const Text(
                        "escribiendo...",
                        style: TextStyle(fontSize: 12),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: Border(
        // top: BorderSide(color: Colors.black, width: 1),
        // ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      height: 55,
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              cursorHeight: 22,
              style: const TextStyle(color: Colors.black87, fontSize: 22),
              controller: _textController,
              onSubmitted: (_) => _handleSubmitted(_textController.text),
              onChanged: (value) {
                // if (value.trim().isNotEmpty && !_isWriting) {
                  
                // } else if (value.trim().isEmpty && _isWriting) {
                //   _handleWritting();
                // }
                setState(() {
                  var writtingOld = _isWriting;
                  _isWriting = value.trim().isNotEmpty;
                  _handleWritting( writtingOld );
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

    // print(text);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.user!.uid,
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
      msm.insert(0, newMessage);
    });

    socketService.socket.emit("private-message", {
      "from": authService.user!.uid,
      "to": chatService.userTo.uid,
      "message": text,
    });
    _handleWritting(true);
  }

  _handleWritting(bool writtingOld ) {
    if (writtingOld==_isWriting) return;
    socketService.socket.emit("user-writting", {
      "from": authService.user!.uid,
      "to": chatService.userTo.uid,
      "writting": _isWriting,
    });
  }

  @override
  void dispose() {
    // TODO: off sockets
    for (ChatMessage message in msm) {
      message.animationController.dispose();
    }
    socketService.socket.off("private-message");
    super.dispose();
  }
}
