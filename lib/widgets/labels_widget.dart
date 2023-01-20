import 'package:flutter/material.dart';
class LabelsWidget extends StatelessWidget {
  const LabelsWidget({
    super.key,
    required this.isLogin,
  });

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
           Text(isLogin?'¿No tienes cuenta?':'¿Ya tienes cuenta?',
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w300)),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, isLogin? '/register': '/login');
            },
            child: Text(isLogin? 'Crea una ahora!': 'Ingresar',
                style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}