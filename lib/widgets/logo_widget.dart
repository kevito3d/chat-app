import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 170,
        // margin: const EdgeInsets.only(top: 50),
        // padding: const EdgeInsets.all(30),
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(10),
        //     boxShadow: const [
        //       BoxShadow(
        //           color: Colors.black26, blurRadius: 5, offset: Offset(0, 5))
        //     ]),

        child: Column(children:  [
          const Image(image: AssetImage('assets/tag-logo.png')),
          const SizedBox(height: 20),
          const Text('Messenger', style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 30)),
        ]),
      ),
    );
  }
}
