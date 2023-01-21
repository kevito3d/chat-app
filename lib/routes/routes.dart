import 'package:chat_real_time/pages/chat_page.dart';
import 'package:chat_real_time/pages/login_page.dart';
import 'package:chat_real_time/pages/register_page.dart';
import 'package:chat_real_time/pages/splash_page.dart';
import 'package:chat_real_time/pages/user_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> app_routes = {
  '/users': ( _ ) => UserPage(),
  '/chat': ( _ ) => ChatPage(),
  '/login': ( _ ) => LoginPage(),
  '/register': ( _ ) => RegisterPage(),
  '/splash': ( _ ) => SplashPage(),
};

