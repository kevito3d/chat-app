import 'package:http/http.dart' as http;

import 'package:chat_real_time/global/enviroment.dart';
import 'package:chat_real_time/models/users_response.dart';
import 'package:chat_real_time/services/auth_service.dart';
import 'package:chat_real_time/models/user_model.dart';

class UserService {
  Future<List<User>> getUsers()async{
    try {
      var token = await AuthService.getToken();
      final resp = await http.get(Uri.parse('${Enviroment.apiUrl}/user'), headers: {
        'Content-Type': 'application/json',
        'x-token': token!,
      });
      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}