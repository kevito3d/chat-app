import 'dart:io';

class Enviroment{
  static String apiUrl = Platform.isAndroid ? 'http://192.168.100.138:3000/api' : 'http://10.0.2.2:3000/api';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.100.138:3000' : 'http://10.0.2.2:3000';
}