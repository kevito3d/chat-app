import 'package:chat_real_time/helpers/alerts.dart';
import 'package:chat_real_time/services/auth_service.dart';
import 'package:chat_real_time/services/socket_service.dart';
import 'package:chat_real_time/widgets/btn_blue.dart';
import 'package:chat_real_time/widgets/custom_input.dart';
import 'package:chat_real_time/widgets/labels_widget.dart';
import 'package:chat_real_time/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  LogoWidget(
                    title: "Login",
                  ),
                  _Form(),
                  LabelsWidget(
                    isLogin: true,
                  ),
                  Text('terminos y condiciones de uso',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthService>(
      context,
    );
    final socketService = Provider.of<SocketService>(
      context,
    );
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomInput(
            icon: Icons.alternate_email,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            keyboardType: TextInputType.text,
            isPassword: true,
            controller: passwordController,
          ),

          // const CustomInput(),
          const SizedBox(
            height: 10,
          ),
          BtnBlue(
            text: "Igresar",
            onPressed: authProvider.autenticando
                ? () {}
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authProvider.login(
                        emailController.text.trim(),
                        passwordController.text.trim());
                    if (loginOk) {
                      // navegar a otra pantalla
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, '/users');
                    } else {
                      showAlert(
                          context, "Login Incorrecto", "revise sus datos");
                    }
                  },
          ),
          const SizedBox(height: 10),
          Text('¿Olvidaste tu contraseña?',
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
