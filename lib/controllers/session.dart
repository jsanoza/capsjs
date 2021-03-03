// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class Session {
//   static Map<String, String> headers = {'Content-Type': 'application/json'};

//   static Future<dynamic> get(String url) =>
//       http.get(url, headers: headers).then((response) {
//         print('GET ' + url);
//         return response.body;
//       }).then(json.decode); // here is your map that return ['email'] on handleFacebookSignIn method
// }
