import 'dart:async';
import 'package:githubflutters/model/contact.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactService {
  static String _url = "https://api.github.com/users?language=flutter";

  static Future browse() async {
    try {
      http.Response response = await http.get(_url);
      if (response.statusCode == 200) {
        String content = response.body;
        List collection = json.decode(content).cast<Map<String, dynamic>>();
        List<Contact> _contacts =
            collection.map((json) => Contact.fromJson(json)).toList();

        return _contacts;
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
