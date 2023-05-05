import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tracker/auth/auth_provider.dart';
import 'package:tracker/services/exception.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseClient {
//API URL
  var baseUrl = "https://golog-tracker-staging-8r3rq.ondigitalocean.app/api";
  
  //dotenv.get("API_URL", fallback: "");

  static const int timeOutDuration = 60;

  //GET
  Future<dynamic> get(String api, bool getToken) async {
    var uri = Uri.parse(baseUrl + api);
    var headers = {'Content-Type': 'application/json', 'Charset': 'utf-8'};
    if (getToken == true) {
      //var token = await SessionManager().get('token');
      var token = AuthProvider.token;

      headers.addAll({'Authorization': 'Bearer $token'});
    }
    try {
      var response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: timeOutDuration));

      return _processReponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //POST
  Future<dynamic> post(String api, dynamic bodyObj) async {
    var uri = Uri.parse(baseUrl + api);
    var body = json.encode(bodyObj);
    var headers = {'Content-Type': 'application/json', 'Charset': 'utf-8'};
    try {
      var response = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: timeOutDuration));
      return _processReponse(response);
    } on SocketException {
      throw FetchDataException('No internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //CATCH API RESPONSE
  dynamic _processReponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured with code: ${response.statusCode}',
            response.request!.url.toString());
    }
  }
}
