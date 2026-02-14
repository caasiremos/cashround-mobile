import '../core/network/api_service.dart';
import '../features/dashboard/models/create_group_request.dart';
import '../features/dashboard/models/create_group_response.dart';
import '../features/dashboard/models/get_groups_response.dart';

class GroupRepository {
  GroupRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  /// GET /groups — fetches groups list. Throws on failure.
  Future<GetGroupsResponse> getGroups() async {
    return _apiService.getGroups();
  }

  /// GET groups/{groupIdOrSlug}/wallet-balance. Throws on failure.
  Future<num> getGroupWalletBalance(String groupIdOrSlug) async {
    return _apiService.getGroupWalletBalance(groupIdOrSlug);
  }

  /// POST /groups — creates a group. Throws on failure.
  Future<CreateGroupResponse> createGroup({
    required String name,
    required String description,
    required String frequency,
    required int amount,
  }) async {
    final request = CreateGroupRequest(
      name: name,
      description: description,
      frequency: frequency,
      amount: amount,
    );
    return _apiService.createGroup(request);
  }
}
