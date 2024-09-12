import 'package:match_app/constants/value_constants.dart';

class FoodType {
  String id;
  String coupleId;
  String title;
  String image;
  int firstVote;
  int secondVote;

  FoodType(
      {required this.id,
      required this.title,
      required this.image,
      required this.coupleId,
      required this.firstVote,
      required this.secondVote});

  factory FoodType.fromJson(Map<String, dynamic> json, String id) {
    return FoodType(
      id: id,
      title: json[ValueConstants.title],
      coupleId: json[ValueConstants.coupleId],
      image: json[ValueConstants.image],
      firstVote: json[ValueConstants.firstVote],
      secondVote: json[ValueConstants.secondVote],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ValueConstants.title: title,
      ValueConstants.image: image,
      ValueConstants.coupleId: coupleId,
      ValueConstants.firstVote: firstVote,
      ValueConstants.secondVote: secondVote
    };
  }
}
