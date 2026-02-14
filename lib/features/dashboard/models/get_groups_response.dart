import 'group_model.dart';

/// Response from GET /groups.
class GetGroupsResponse {
  const GetGroupsResponse({
    required this.data,
    this.metadata,
  });

  factory GetGroupsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'];
    return GetGroupsResponse(
      data: dataList is List
          ? (dataList)
              .map((e) => GroupModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList()
          : const [],
      metadata: json['metadata'] as String?,
    );
  }

  final List<GroupModel> data;
  final String? metadata;
}
