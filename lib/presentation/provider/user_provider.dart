import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budgeting_flutter_app_v1/data/repositories/user_repository.dart';
import 'package:budgeting_flutter_app_v1/data/models/user_auth_model.dart';

class AuthProvider extends ChangeNotifier {
  final LoginRepository _loginRepository = LoginRepository();
  bool _isLoading = false;
  bool isLogin = false;
  String errorMessage = '';
  bool get isLoading => _isLoading;

  Future<void> init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs?.getBool('isLogin') ?? false;
    print('isLogin: $isLogin');
  }

  void clearErrorMessage() {
    errorMessage = '';
    notifyListeners();
  }

  Future<UserAuthModel> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserAuthModel user = await _loginRepository.login(username, password);

      if (user.role != 'user' && user.role != 'userplus') {
        throw Exception("You're Admin, please login to Web Platform");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token);
      await prefs.setInt('userId', user.userId);
      await prefs.setString('username', user.username);
      await prefs.setString('role', user.role);
      await prefs.setBool('isLogin', true);

      clearErrorMessage();

      return user;
    } catch (e) {
      errorMessage = e.toString();
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String username, String fullName, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _loginRepository.register(email, username, fullName, password);
      clearErrorMessage();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
