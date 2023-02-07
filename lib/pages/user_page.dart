import 'package:chat_real_time/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_real_time/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final users = [
    User(online: true, name: "Kevin", email: "kevin@gmail.com", uid: "1"),
    User(online: false, name: "Juan", email: "juan@hotmail.com", uid: "2"),
    User(online: true, name: "Pedro", email: "peditro@outlook.com", uid: "3"),
  ];
  @override
  Widget build(BuildContext context) {
    final authServise = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(authServise.user!.name),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: const Icon(Icons.check_circle, color: Colors.lightGreen),
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
    await Future.delayed(const Duration(milliseconds: 1000));
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
      subtitle: Text(user.email, style: const TextStyle(color: Colors.white54)),
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
    );
  }
}
