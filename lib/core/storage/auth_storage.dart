import 'package:get_storage/get_storage.dart';

import '../../features/auth/models/member_model.dart';

/// Persistent storage for auth token and member.
class AuthStorage {
  AuthStorage._();
  static final _box = GetStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyTokenType = 'token_type';
  static const _keyMember = 'member';

  static String? get accessToken => _box.read<String>(_keyAccessToken);
  static String? get tokenType => _box.read<String>(_keyTokenType);

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

  static Future<void> clear() async {
    await _box.remove(_keyAccessToken);
    await _box.remove(_keyTokenType);
    await _box.remove(_keyMember);
  }

  static bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;
}
