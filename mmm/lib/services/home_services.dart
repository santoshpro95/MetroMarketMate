import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/api_constants.dart';
import 'package:mmm/utils/app_constants.dart';
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

// region getShops
  Future<GetShopsResponse> getShops(String location) async {
    // endregion
    Map<String, dynamic> response;
    var objectId = "";
    if (location == AppConstants.cities.first) {
      objectId = "65b6c24c1f5677401f277f1d";
    } else {
      objectId = "65b00848266cfc3fde7ee3f2";
    }

    //#region Region - Execute Request
    response = await httpService.getApiCall("${ApiConstants.baseUrl}$objectId/latest?meta=false");

    // return response;
    return GetShopsResponse.fromJson(response);
  }

// endregion
}
