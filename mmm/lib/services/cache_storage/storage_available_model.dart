//#region Region - StorageAvailable
/// ## Do Not Delete ##
/// This object is used check if storage is available.
class StorageAvailable {
  int index = 5;

  static StorageAvailable fromJson(Map<String, dynamic> json) {
    var value = StorageAvailable();
    value.index = json["index"] as int;
    return value;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'index': index};

  bool isValid() {
    return index == 5;
  }
}
//#endregion StorageAvailable
