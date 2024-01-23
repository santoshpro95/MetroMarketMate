import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mmm/model/api_response_message.dart';
import 'package:mmm/utils/api_constants.dart';

class HttpService {
  // region Get Api Call
  Future<Map<String, dynamic>> getApiCall(String apiUrl) async {
    Map<String, dynamic> jsonResponse;

    // http header
    var header = {"content-type": "application/json", "X-Master-Key": ApiConstants.masterKey};

    //  parsed Url
    var url = Uri.parse(apiUrl);
    //  Timeout duration
    var duration = const Duration(seconds: ApiConstants.apiTimeOutInSecond);

    try {
      //  Execute Http Post
      var response = await http.get(url, headers: header).timeout(duration);

      // check if response is null
      if (response.body.isEmpty) throw CommonApiResponse(message: "$apiUrl returned empty response.");

      // decode json
      jsonResponse = json.decode(response.body.toString());

      // if not status 200
      if (response.statusCode != 200) throw CommonApiResponse(message: "Server is not responding, status code: ${response.statusCode}");
      // endregion

      // handle socket exception
    } on SocketException catch (exception) {
      throw CommonApiResponse(message: "No Internet Connection.");
    } on TimeoutException catch (exception) {
      throw CommonApiResponse(message: "Time out please try again.");
    }

    return jsonResponse;
  }

// endregion

  // region Put Api Call
  Future<Map<String, dynamic>> putApiCall(String apiUrl, var body) async {
    Map<String, dynamic> jsonResponse;

    // http header
    var header = {"content-type": "application/json", "X-Master-Key": ApiConstants.masterKey};

    //  parsed Url
    var url = Uri.parse(apiUrl);
    //  Timeout duration
    var duration = const Duration(seconds: ApiConstants.apiTimeOutInSecond);

    try {
      //  Execute Http Post
      var response = await http.put(url, body: json.encode(body), headers: header).timeout(duration);

      // check if response is null
      if (response.body.isEmpty) throw CommonApiResponse(message: "$apiUrl returned empty response.");

      // decode json
      jsonResponse = json.decode(response.body.toString());

      // if not status 200
      if (response.statusCode != 200) throw CommonApiResponse(message: "Server is not responding, status code: ${response.statusCode}");
      // endregion

      // handle socket exception
    } on SocketException catch (exception) {
      throw CommonApiResponse(message: "No Internet Connection.");
    } on TimeoutException catch (exception) {
      throw CommonApiResponse(message: "Time out please try again.");
    }

    return jsonResponse;
  }
// endregion
}
