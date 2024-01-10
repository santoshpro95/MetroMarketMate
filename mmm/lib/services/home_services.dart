import 'http_service.dart';

class HomeServices {
  // region Common Variables
  late HttpService httpService;

  // endregion

  // region | Constructor |
  HomeServices() {
    httpService = HttpService();
  }

// endregion

  // // region update BuildingDetailsResponse
  // Future<BuildingDetailsResponse> getBuildingDetailsById({String? userId, int? systemId, String? token}) async {
  //   // region get body
  //   var body = {"data": '{"system_id": "$systemId", "userid": "$userId" }'};
  //
  //   // endregion
  //   Map<String, dynamic> response;
  //
  //   //#region Region - Execute Request
  //   response = await httpService.apiCall(body, AppConstants.getBuildingDetails, token!);
  //   // return response;
  //   return BuildingDetailsResponse.fromJson(response);
  // }
  //
  // // endregion

}
