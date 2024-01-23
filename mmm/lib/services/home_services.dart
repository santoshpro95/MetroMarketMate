import 'package:mmm/model/get_shops_response.dart';
import 'package:mmm/utils/api_constants.dart';

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
  Future<GetShopsResponse> getShops() async {
    // endregion
    Map<String, dynamic> response;

    //#region Region - Execute Request
    response = await httpService.getApiCall(ApiConstants.getShops);

    // return response;
    return GetShopsResponse.fromJson(response);
  }

// endregion
}
