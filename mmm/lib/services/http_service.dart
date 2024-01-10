import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mmm/model/api_response_message.dart';
import 'package:mmm/utils/api_constants.dart';
import 'package:mmm/utils/app_constants.dart';

class HttpService {
  // region Api Call
  Future<Map<String, dynamic>> apiCall(var param, String apiUrl, String token) async {
    Map<String, dynamic> jsonResponse;

    // http header
    var header = {"content-type": "application/json", "authorization": "Bearer $token"};
    //  Request Body
    var body = json.encode(param);
    //  parsed Url
    var url = Uri.parse(apiUrl);
    //  Timeout duration
    var duration = const Duration(seconds: ApiConstants.apiTimeOutInSecond);

    try {
      //  Execute Http Post
      var response = await http.post(url, body: body, headers: header).timeout(duration);

      // region check if response is null
      if (response.body.isEmpty) {
        throw Exception("$apiUrl returned empty response.");
      }
      // endregion

      // decode json
      jsonResponse = json.decode(response.body.toString());

      // Region - Handle None Http 200
      if (response.statusCode != 200) {
        throw Exception("Oops error occurred, please try again in few minutes. Error Code:  ${response.statusCode} Details: ${response.body}.");
      }
      // endregion

      //#region Region - Handle Http 200 api error
      var isStatusOk = jsonResponse["status"] == "OK";
      if (!isStatusOk) {
        throw CommonApiResponse.fromJson(json.decode(response.body));
      }
      // endregion

      // handle socket exception
    } on SocketException catch (exception) {
      throw CommonApiResponse(message: "No Internet Connection.", status: "No Internet");
    } on TimeoutException catch (exception) {
      throw CommonApiResponse(message: "Time out please try again.", status: "Timeout");
    }

    return jsonResponse;
  }
// endregion

}
