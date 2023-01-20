import 'package:flutter/material.dart';

class BtnBlue extends StatelessWidget {
  const BtnBlue({super.key, required this.text, required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue[600],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
      onPressed: onPressed as void Function()?,
      child: const SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text('Ingresar',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}
