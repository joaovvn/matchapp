import 'package:match_app/constants/value_constants.dart';

abstract class Vote {
  String groupId;
  String userId;
  int vote;
  Vote({
    required this.groupId,
    required this.userId,
    required this.vote,
  });
}

class FoodVote extends Vote {
  String foodTypeId;
  FoodVote(
      {required super.groupId,
      required super.userId,
      required super.vote,
      required this.foodTypeId});

  factory FoodVote.fromJson(Map<String, dynamic> json) {
    return FoodVote(
        userId: json[ValueConstants.userId],
        groupId: json[ValueConstants.groupId],
        vote: json[ValueConstants.vote],
        foodTypeId: json[ValueConstants.foodTypeId]);
  }

  Map<String, dynamic> toJson() {
    return {
      ValueConstants.userId: userId,
      ValueConstants.groupId: groupId,
      ValueConstants.vote: vote,
      ValueConstants.foodTypeId: foodTypeId
    };
  }
}

class RestaurantVote extends Vote {
  String restaurantId;
  RestaurantVote(
      {required super.groupId,
      required super.userId,
      required super.vote,
      required this.restaurantId});

  factory RestaurantVote.fromJson(Map<String, dynamic> json) {
    return RestaurantVote(
        userId: json[ValueConstants.userId],
        groupId: json[ValueConstants.groupId],
        vote: json[ValueConstants.vote],
        restaurantId: json[ValueConstants.restaurantId]);
  }

  Map<String, dynamic> toJson() {
    return {
      ValueConstants.userId: userId,
      ValueConstants.groupId: groupId,
      ValueConstants.vote: vote,
      ValueConstants.restaurantId: restaurantId
    };
  }
}
