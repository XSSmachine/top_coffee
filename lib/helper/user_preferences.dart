import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  final SharedPreferences preferences;

  UserPreferences({
    required this.preferences

  });

  static const _keyUserRole = 'userRole';


  Future setUserRole(String role) async {
    await preferences.setString(_keyUserRole, role);
  }

  String getUserRole() {
    return preferences.getString(_keyUserRole) ?? 'USER';
  }
}
