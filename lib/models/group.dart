import 'package:match_app/constants/value_constants.dart';

class Group {
  String id;
  String ownerId;

  Group({required this.id, required this.ownerId});

  Map<String, dynamic> toJson() => {ValueConstants.ownerId: ownerId};

  factory Group.fromJson(Map<String, dynamic> json, String id) {
    return Group(id: id, ownerId: json[ValueConstants.ownerId]);
  }
}
