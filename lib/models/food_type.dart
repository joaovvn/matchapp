import 'package:match_app/constants/value_constants.dart';

class FoodType {
  String id;
  String groupId;
  String title;
  String image;

  FoodType(
      {required this.id,
      required this.title,
      required this.image,
      required this.groupId});

  factory FoodType.fromJson(Map<String, dynamic> json, String id) {
    return FoodType(
      id: id,
      title: json[ValueConstants.title],
      groupId: json[ValueConstants.groupId],
      image: json[ValueConstants.image],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ValueConstants.title: title,
      ValueConstants.image: image,
      ValueConstants.groupId: groupId,
    };
  }
}
