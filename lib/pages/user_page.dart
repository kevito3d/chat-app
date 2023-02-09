import 'package:flutter/material.dart';
import 'package:chat_real_time/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_real_time/services/auth_service.dart';
import 'package:chat_real_time/services/chat_service.dart';
import 'package:chat_real_time/services/socket_service.dart';
import 'package:chat_real_time/services/user_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<User> users = [];

  final userService = UserService();
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    _cargarUsuarios();

    socketService.socket.on("user-writting", _listenWritting);
  }

  void _listenWritting(dynamic payload) {
    if (payload["to"] == authService.user!.uid) {
      setState(() {
        for (var user in users) {
          if (user.uid == payload["from"]) {
            user.writting = payload["writting"];
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authServise = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(authServise.user!.name),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, '/login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
                ? const Icon(Icons.check_circle, color: Colors.lightGreen)
                : const Icon(Icons.offline_bolt, color: Colors.red),
            // child: Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      backgroundColor: Colors.black54,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue),
          waterDropColor: Colors.blue,
        ),
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          completeDuration: Duration(milliseconds: 500),
        ),
        onRefresh: _cargarUsuarios,
        child: _listViewUsers(),
        // onLoading: _onLoading,
      ),
    );
  }

  void _cargarUsuarios() async {
    // monitor network fetch
    // await Future.delayed(const Duration(milliseconds: 1000));
    users = await userService.getUsers();
    setState(() {});

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  ListView _listViewUsers() {
    return ListView.separated(
        itemBuilder: (_, i) => tileUser(users[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: users.length);
  }

  ListTile tileUser(User user) {
    return ListTile(
      title: Text(user.name,
          style: const TextStyle(color: Colors.white, fontSize: 20)),
      subtitle: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(user.email,
                  style: const TextStyle(color: Colors.white54))),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: user.writting
                ? Container(
                  // color: Colors.green.shade100,
                  child: const Text(
                      "escribiendo",
                      style: TextStyle(color: Colors.white54),
                      textAlign: TextAlign.end ,
                    ),
                )
                : const SizedBox.shrink(),
          )
        ],
      ),
      leading: CircleAvatar(
        child: Text(
          user.name.substring(0, 2).toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(
          context,
          listen: false,
        );
        chatService.userTo = user;
        Navigator.pushNamed(context, '/chat');
      },
    );
  }
}
