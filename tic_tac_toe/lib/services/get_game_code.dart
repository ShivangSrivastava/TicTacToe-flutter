import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String?> getGameCode() async {
  String url = "http://192.168.212.10:8000/newGameCode";

  http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["code"];
  }
  return null;
  
}
