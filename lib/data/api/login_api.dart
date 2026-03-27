import 'api_service.dart';
import '../../utils/const.dart';
import '../../utils/shared_pref.dart';
import 'package:restart_app/restart_app.dart';

import '../../utils/secret_code.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginApi {
  static const _url = "${Const.postSvrURL}/user";
  static Future<bool> google() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final userData = await googleSignIn.signIn();
      if (userData == null) {
        return false;
      }
      var response = await ApiService.post(
        url: "$_url/login",
        body: {
          "email": userData.email,
          "name": userData.displayName,
          "cover": userData.photoUrl,
          "password": SecretCode.generate(userData.email.split('@')[0]),
        },
      );

      if (response.status) {
        await SharedPref.setData(value: userData.email, key: Const.token);
        Restart.restartApp();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
