import 'package:chat_real_time/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:chat_real_time/routes/routes.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: app_routes,
        
      ),
    );
  }
}
