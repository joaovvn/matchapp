import "package:match_app/constants/value_constants.dart";

class Restaurant {
  String id;
  String foodTypeId;
  String title;
  String image;
  int firstVote;
  int secondVote;

  Restaurant(
      {required this.id,
      required this.title,
      required this.image,
      required this.foodTypeId,
      required this.firstVote,
      required this.secondVote});

  factory Restaurant.fromJson(Map<String, dynamic> json, String id) {
    return Restaurant(
        id: id,
        title: json[ValueConstants.title],
        foodTypeId: json[ValueConstants.foodTypeId],
        image: json[ValueConstants.image],
        firstVote: json[ValueConstants.firstVote],
        secondVote: json[ValueConstants.secondVote]);
  }

  Map<String, dynamic> toJson() {
    return {
      ValueConstants.title: title,
      ValueConstants.image: image,
      ValueConstants.foodTypeId: foodTypeId,
      ValueConstants.firstVote: firstVote,
      ValueConstants.secondVote: secondVote
    };
  }
}
