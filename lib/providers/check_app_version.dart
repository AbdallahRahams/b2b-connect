import 'dart:convert';
import 'package:b2b_connect/models/response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AppVersionProvider extends ChangeNotifier {
  bool? _activeVersion;
  bool _isLoading = true;
  bool? get isActive => _activeVersion;
  bool get loading => _isLoading;

  ///
  /// Check version
  ///
  Future<ResponseMessage> verifyVersion({required String localVersion}) async {
    late ResponseMessage responseMessage;
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response;
      response = await http.post(
        Uri.parse('$baseURL/api/v1/check/mobile/application/version/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({"version": localVersion}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('VERSION') &&
            responseData.containsKey('STATUS')) {
          if (responseData["STATUS"] == "ACTIVE") {
            _activeVersion = true;
            responseMessage = ResponseMessage(
              error: false,
              message: "ACTIVE",
              unauthorized: false,
            );
          } else {
            _activeVersion = false;
            responseMessage = ResponseMessage(
              error: false,
              message: "DISABLED",
              unauthorized: false,
            );
          }
        } else {
          responseMessage = ResponseMessage(
            error: true,
            message: "Failed to get version",
            unauthorized: false,
          );
        }
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<dynamic> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            message: "Fetching failed",
            unauthorized: false,
          );
        }
      }

      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return ResponseMessage(
        error: true,
        message: "Something went wrong",
        unauthorized: false,
      );
    }
  }
}
