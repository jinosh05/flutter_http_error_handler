import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_response_handling/custom_exception.dart';

class ApiProvider {
  final String _baseUrl = "https://api.chucknorris.io/";

  Future get(String url) async {
    final response;
    try {
      response = await http.get(
        Uri.parse(_baseUrl + url),
      );
      print(response.body);
      ErrorHandler()._response(response);
    } on SocketException {
      throw FetchDataException("No internet");
    }
    return response;
  }
}

class ErrorHandler {
  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print("Connection Success");
        return true;
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorisedException(response.body);
      case 403:
        throw UnauthorisedException(response.body);

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
