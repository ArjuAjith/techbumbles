// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:techbumbles/model/auth_data.dart';
import 'package:techbumbles/model/product_data.dart';

class DataService {
  Future<AuthData?> doLogin(
      {required String username, required String password}) async {
    var url = 'https://dummyjson.com/auth/login';
    var body = jsonEncode({"username": username, "password": password});

    http.Response response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    // print(response.request);
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return AuthData.fromJson(json);
    }
  }

  Future<Map<String, dynamic>> getProducts() async {
    var url = "https://dummyjson.com/products";

    http.Response response = await http.get(Uri.parse(url));
    // print(response.request);
    print(response.statusCode);
    print(response.body);
    // if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json;
    // }
  }
}

// Future<http.Response> postRequest() async {
//   var url =
//       'https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
//   var body = jsonEncode({
//     'data': {'apikey': '12345678901234567890'}
//   });

//   print("Body: " + body);

//   http
//       .post(url, headers: {"Content-Type": "application/json"}, body: body)
//       .then((http.Response response) {
//     print("Response status: ${response.statusCode}");
//     print("Response body: ${response.contentLength}");
//     print(response.headers);
//     print(response.request);
//   });
// }
