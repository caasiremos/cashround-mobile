import 'package:get_storage/get_storage.dart';

import '../../features/auth/models/member_model.dart';

/// Persistent storage for auth token and member.
class AuthStorage {
  AuthStorage._();
  static final _box = GetStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyTokenType = 'token_type';
  static const _keyMember = 'member';
  static const _keySavedEmail = 'saved_email';
  static const _keySavedPassword = 'saved_password';

  static String? get accessToken => _box.read<String>(_keyAccessToken);
  static String? get tokenType => _box.read<String>(_keyTokenType);
  static String? get savedEmail => _box.read<String>(_keySavedEmail);
  static String? get savedPassword => _box.read<String>(_keySavedPassword);

  static MemberModel? get member {
    final map = _box.read<Map<String, dynamic>>(_keyMember);
    if (map == null) return null;
    return MemberModel.fromJson(Map<String, dynamic>.from(map));
  }

  static Future<void> saveToken(String accessToken, {String tokenType = 'Bearer'}) async {
    await _box.write(_keyAccessToken, accessToken);
    await _box.write(_keyTokenType, tokenType);
  }

  static Future<void> saveMember(MemberModel member) async {
    await _box.write(_keyMember, member.toJson());
  }

  static Future<void> saveLogin(String accessToken, MemberModel member,
      {String tokenType = 'Bearer'}) async {
    await _box.write(_keyAccessToken, accessToken);
    await _box.write(_keyTokenType, tokenType);
    await _box.write(_keyMember, member.toJson());
  }

  /// Saves email/password for prefill on next login. Called after successful login.
  static Future<void> saveCredentials(String email, String password) async {
    await _box.write(_keySavedEmail, email);
    await _box.write(_keySavedPassword, password);
  }

  static Future<void> clear() async {
    await _box.remove(_keyAccessToken);
    await _box.remove(_keyTokenType);
    await _box.remove(_keyMember);
    await _box.remove(_keySavedEmail);
    await _box.remove(_keySavedPassword);
  }

  static bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;
}
