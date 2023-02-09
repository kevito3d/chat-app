import 'package:chat_real_time/global/enviroment.dart';
import 'package:chat_real_time/models/message_response.dart';
import 'package:chat_real_time/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_real_time/models/user_model.dart';

class ChatService with ChangeNotifier {
  late User userTo;

  Future<List<Message>> getChat(String userID) async {
    var token = await AuthService.getToken();
    final resp = await http
        .get(Uri.parse('${Enviroment.apiUrl}/messages/$userID'), headers: {
      'Content-Type': 'application/json',
      'x-token': token!
    });
    
    final messagesResponse = messagesResponseFromJson(resp.body);
    return messagesResponse.messages;
  }
}
