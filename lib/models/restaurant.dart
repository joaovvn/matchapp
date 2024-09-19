import "package:match_app/constants/value_constants.dart";

class Restaurant {
  String id;
  String foodTypeId;
  String title;
  String image;

  Restaurant(
      {required this.id,
      required this.title,
      required this.image,
      required this.foodTypeId});

  factory Restaurant.fromJson(Map<String, dynamic> json, String id) {
    return Restaurant(
      id: id,
      title: json[ValueConstants.title],
      foodTypeId: json[ValueConstants.foodTypeId],
      image: json[ValueConstants.image],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ValueConstants.title: title,
      ValueConstants.image: image,
      ValueConstants.foodTypeId: foodTypeId,
    };
  }
}
