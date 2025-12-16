import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalAuthProvider with ChangeNotifier {
  LocalAuthProvider() : _box = Hive.box('local_auth') {
    _isLoggedIn = _box.get('isLoggedIn', defaultValue: false) as bool;
    _username = _box.get('username', defaultValue: '') as String;
  }

  final Box _box;
  bool _isLoggedIn = false;
  String _username = '';

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    const hardcodedUser = 'admin123';
    const hardcodedPass = 'admin123';

    if (username == hardcodedUser && password == hardcodedPass) {
      _isLoggedIn = true;
      _username = username;
      await _box.put('isLoggedIn', true);
      await _box.put('username', username);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = '';
    await _box.put('isLoggedIn', false);
    await _box.put('username', '');
    notifyListeners();
  }
}
