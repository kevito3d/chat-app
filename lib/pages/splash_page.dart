import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_real_time/pages/login_page.dart';
import 'package:chat_real_time/pages/user_page.dart';
import 'package:chat_real_time/services/auth_service.dart';
import 'package:chat_real_time/services/socket_service.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return const Center(
            child: Text('Loading...'),
          );
        },
        future: checkLoginState(context),

      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authServise = Provider.of<AuthService>(context, listen: false);
    final socketService= Provider.of<SocketService>(
      context,listen: false
    );
    final autenticado = await authServise.isLoggedIn();
    if (autenticado) {
      socketService.connect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) =>  const UserPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) =>  const LoginPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}
