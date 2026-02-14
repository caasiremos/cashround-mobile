import 'package:flutter/material.dart';

import '../core/network/api_error_helper.dart';
import '../features/dashboard/models/create_group_response.dart';
import '../features/dashboard/models/group_model.dart';
import '../repositories/group_repository.dart';

class GroupViewModel extends ChangeNotifier {
  GroupViewModel({GroupRepository? repository})
      : _repository = repository ?? GroupRepository();

  final GroupRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<GroupModel> _groups = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<GroupModel> get groups => List.unmodifiable(_groups);

  /// GET /groups — fetches and updates [groups]. Returns true on success.
  Future<bool> getGroups() async {
    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      final response = await _repository.getGroups();
      _groups = response.data;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(ApiErrorHelper.messageFromException(e));
      notifyListeners();
      return false;
    }
  }

  Future<CreateGroupResponse?> createGroup({
    required String name,
    required String description,
    required String frequency,
    required int amount,
  }) async {
    _setLoading(true);
    _clearError();
    notifyListeners();

    try {
      final response = await _repository.createGroup(
        name: name,
        description: description,
        frequency: frequency,
        amount: amount,
      );
      _setLoading(false);
      notifyListeners();
      return response;
    } catch (e) {
      _setLoading(false);
      _setError(ApiErrorHelper.messageFromException(e));
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setError(String message) {
    _errorMessage = message;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
