import 'dart:convert';
import 'package:sdt_evd/models/Fullaccess.dart';
import 'package:sdt_evd/models/User.dart';
import 'package:sdt_evd/models/remember.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyRememberMe = 'rememberMe';
  static const String _keyUsername = 'username';
  static const String _keypassord = 'password';
  static const String _keytoken = 'token';
  static const String _keytokentype = 'tokentype';

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  static Future<rememberMe?> getLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_keyUsername);
    final password = prefs.getString(_keypassord);
    final accessToken = prefs.getString(_keytoken);
    final accesstokentype = prefs.getString(_keytokentype);
    print(username);
    print(password);
    print(accessToken);
    print(accesstokentype);

    if (username != null &&
        accessToken != null &&
        password != null &&
        accesstokentype != null) {
      return rememberMe(
          username: username,
          password: password,
          token: accessToken,
          tokenType: accesstokentype);
    }

    return null;
  }

  static Future<void> setLoginCredentials(rememberMe model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, model.username);
    await prefs.setString(_keypassord, model.password);
    await prefs.setString(_keytoken, model.token);
    await prefs.setString(_keytokentype, model.tokenType);
  }

  static Future<void> clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keypassord);
    await prefs.remove(_keytoken);
    await prefs.remove(_keytokentype);
  }
}


// class RememberUserPrefs {
//    static const  String _keytoken = 'token';
//   static const String _keyusername = 'username';
  
  
//   static Future<void> storeUserInfo(String user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keytoken, user);
//   }
  
//   static Future<void> clearlogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keytoken);
//   }


//   static Future<bool> getRememberMe() async{
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_keytoken) ?? false;
//   }

//   static Future<bool> setRememberMe(bool value) async{
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.setBool(_keytoken, value);
//   }

//   static 

//   static Future<User?> readUserInfo() async {
//     User? currentUserInfo;
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String? userinfo = preferences.getString("currentUser");

//     if (userinfo != null) {
//       currentUserInfo = jsonDecode(userinfo);
//     }
//     return currentUserInfo;
//   }


//   static Future<bool> deleteUserInfo() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.remove("currentUser");
//     return true;
//   }
// }
