import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    required this.placeholder,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  final String placeholder;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData icon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 5))
          ]),
      child:  TextField(
        obscureText: isPassword ,
        
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        controller: controller ,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: placeholder,
          prefixIcon: Icon( icon ),
          // contentPadding: EdgeInsets.all(5),
        ),
      ),
    );
  }
}
