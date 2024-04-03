import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budgeting_flutter_app_v1/data/repositories/user_repository.dart';
import 'package:budgeting_flutter_app_v1/data/models/user_auth_model.dart';

class AuthProvider extends ChangeNotifier {
  final LoginRepository _loginRepository = LoginRepository();
  bool _isLoading = false;
  bool isLogin = false;

  bool get isLoading => _isLoading;

  Future<void> init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs?.getBool('isLogin') ?? false;
    print('isLogin: $isLogin');
  }

  Future<UserAuthModel> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserAuthModel user = await _loginRepository.login(username, password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token);
      await prefs.setInt('userId', user.userId);
      await prefs.setString('username', user.username);
      await prefs.setString('role', user.role);
      await prefs.setBool('isLogin', true);

      return user;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
