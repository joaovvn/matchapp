import 'package:match_app/constants/value_constants.dart';

class Member {
  String groupId;
  String userId;

  Member({
    required this.groupId,
    required this.userId,
  });

  Map<String, dynamic> toJson() =>
      {ValueConstants.groupId: groupId, ValueConstants.userId: userId};

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        groupId: json[ValueConstants.groupId],
        userId: json[ValueConstants.userId]);
  }
}
