import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_available_model.dart';
import 'storage_keys.dart';

class CacheStorageService {
  //#region Region - IsStorageAvailable
  /// This method checks whether the app has access to shared preferences.
  /// If we don't have access to shared preferences the app will not function.
  ///
  /// To check whether storage is available, this method tries to save json
  /// object to shared preferences and retrieve it back.
  /// If we can't retrieve or save the object it means there is something wrong
  /// with shared preferences thus storage not available.
  ///
  /// The caller is expected to sign the user out and send back to login page
  /// in-case we have issue with storage.
  Future<bool> isStorageAvailable() async {
    var isAvailable = false;

    try {
      // Create instance object which we will be saving to shared Preferences.
      var storageAvailableObject = StorageAvailable();

      // Save object to storage in json format.
      await save(StorageKeys.StorageAvailabilityKey, storageAvailableObject);

      // Now we have to get the object to ensure reading from storage is working.
      var jsonValue = await get(StorageKeys.StorageAvailabilityKey);

      // Convert json string to StorageAvailable object.
      var storageAvailable = StorageAvailable.fromJson(jsonValue);

      // If store is not valid return false consumer will show dead screen;
      if (storageAvailable.isValid()) isAvailable = true;
    } catch (exception) {
      isAvailable = false;
    }

    // If we reach here it means we were able to successfully test the storage.
    return isAvailable;
  }

  //#endregion

  //#region Region - ContainsKey
  /// Checks whether the key provided has value in storage.
  Future<bool> containsKey(String key) async {
    try {
      // Get shared preferences and check if provided key is not null.
      var sharedPreferences = await SharedPreferences.getInstance();

      // Check if our key exist.
      if (sharedPreferences.containsKey(key)) return true;

      // if key did not exist return false;
      return false;
    } catch (exception) {
      return false;
    }
  }

//#endregion

  //#region Region - Save Object
  /// Saves the object provided to Shared References
  /// Object is converted into json before saving.
  ///
  /// Does not handle errors so caller must use try catch.
  /// Returns true if object is saved.
  /// NOTE - the object passed to the parameter must implement the toJson
  /// method and return Map<String, dynamic> or error will occur.
  Future<bool> save<T>(String key, T object) async {
    // Convert object to json string
    var jsonString = json.encode(object);

    // Get access to shared Preferences
    var shared = await SharedPreferences.getInstance();

    // Save object with the key provided.
    // Object is overridden if a copy already exist.
    return await shared.setString(key, jsonString);
  }

  //#endregion

  // region Region - Get Object
  Future<dynamic> get(String key) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var value = sharedPreferences.getString(key);
    if (value == null) return null;

    // Now at this point we know that we have the key value and we can parse json without any issues.
    var dynamicJson = json.decode(value);
    return dynamicJson;
  }

  //#endregion

  //#region Region - Save List of Strings
  /// Saves a simple string list value to the shared preferences.
  /// Note caller must handle exceptions.
  Future<bool> saveStringList(String key, List<String> value) async {
    // Get access to shared Preferences
    var shared = await SharedPreferences.getInstance();

    // Save string List value with the key provided.
    // Value is overridden if a copy already exist.
    return await shared.setStringList(key, value);
  }

  //#endregion

  //#region Region - Get String List
  /// Returns the string list data available for the key provided
  /// Caller must handle exceptions.
  Future<List<String>> getStringList(String key) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var value = sharedPreferences.getStringList(key);
    if (value == null) return [];
    return value;
  }

  //#endregion

  //#region Region - Save String
  /// Saves a simple string value to the shared preferences.
  /// Note consumer must handle exceptions.
  Future<bool> saveString(String key, String value) async {
    // Get access to shared Preferences
    var shared = await SharedPreferences.getInstance();

    // Save string value with the key provided.
    // Value is overridden if a copy already exist.
    return await shared.setString(key, value);
  }

//#endregion

  //#region Region - Get String
  /// Returns the string data available for the key provided
  /// Caller must handle exceptions.
  Future<String> getString(String key) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var value = sharedPreferences.getString(key);
    if (value == null) return "";
    return value;
  }

  //#endregion

  //#region Region - Save Boolean
  /// Saves a simple boolean value to the shared preferences.
  /// Note consumer must handle exceptions.
  Future<bool> saveBoolean(String key, bool value) async {
    // Get access to shared Preferences
    var shared = await SharedPreferences.getInstance();

    // Save string value with the key provided.
    // Value is overridden if a copy already exist.
    return await shared.setBool(key, value);
  }

//#endregion

  //#region Region - Get Boolean
  /// Returns the boolean data available for the key provided
  /// Caller must handle exceptions.
  Future<bool> getBoolean(String key) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var value = sharedPreferences.getBool(key);
    if (value == null) return false;
    return value;
  }

  //#endregion

  //#region Region - Remove Item
  /// Returns the string data available for the key provided
  /// Caller must handle exceptions.
  Future<void> removeItem(String key) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key);
  }

//#endregion

  //#region Region - Remove All Item
  /// Caller must handle exceptions.
  Future<void> removeAllItem() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(StorageKeys.SavedMateKey);
  }

//#endregion
}
