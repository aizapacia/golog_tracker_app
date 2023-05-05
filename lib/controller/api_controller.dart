import 'dart:convert';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:tracker/auth/auth_provider.dart';
import 'package:tracker/controller/base_controller.dart';

import '../services/base_client.dart';

class ApiController with BaseController {
  var sessionManager = SessionManager();

  get http => null;

  //
  getData(String url, bool getToken) async {
    try {
      var response =
          await BaseClient().get(url, getToken).catchError(handleError);
      if (response == null) return;
      return jsonDecode(response);
    } catch (e) {
      return null;
    }
  }

  getToken(String url, dynamic bodyObj) async {
    try {
      //showLoading();
      var response =
          await BaseClient().post(url, bodyObj).catchError(handleError);

      if (response == null) return null;
      var jsonData = json.decode(response);
      await sessionManager.set("userProfile", jsonData['profile'].toString());
      await sessionManager.set("userName", jsonData['user']['name']);
      await sessionManager.set("userID", jsonData['user']['id']);
      await sessionManager.set("userAddress", jsonData['user']['address']);
      await sessionManager.set("userPhone", jsonData['user']['phone']);
      await sessionManager.set("token", jsonData['token']);
      AuthProvider.userName = jsonData['user']['name'].toString();
      AuthProvider.userId = jsonData['user']['id'].toString();
      AuthProvider.userProfile = jsonData['profile'].toString();
      AuthProvider.userAddress = jsonData['user']['address'].toString();
      AuthProvider.userPhone = jsonData['user']['phone'].toString();
      AuthProvider.token = jsonData['token'].toString();

      // hideLoading();
      return response;
    } catch (e) {
      return null;
    }
  }

  getSpecificOrder(String url) async {
    try {
      var response = await BaseClient().get(url, true).catchError(handleError);
      if (response == null) return;
      return jsonDecode(response);
    } catch (e) {
      return null;
    }
  }

  logout() async {
    try {
      var response =
          await BaseClient().get('/logout', true).catchError(handleError);
      if (response == null) return;
      return jsonDecode(response);
    } catch (e) {
      return null;
    }
  }
}
