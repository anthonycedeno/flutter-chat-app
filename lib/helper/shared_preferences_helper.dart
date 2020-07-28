import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String sharedPreferencesUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferencesUsernameKey = "USERNAMEKEY";
  static String sharedPreferencesUserEmailKey = "USEREMAILKEY";

  //Saving data to Shared Preferences
  static Future<void> saveLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(
      sharedPreferencesUserLoggedInKey,
      isUserLoggedIn,
    );
  }

  static Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
      sharedPreferencesUsernameKey,
      username,
    );
  }

  static Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
      sharedPreferencesUserEmailKey,
      email,
    );
  }
}
