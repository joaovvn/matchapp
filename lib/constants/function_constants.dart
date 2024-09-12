import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/models/couple.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionConstants {
  static resetVotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? coupleId = preferences.getString(ValueConstants.coupleId);
    if (coupleId == null) {
      return;
    }
    String voteId = "";
    FirebaseDatabase.instance
        .ref("${ValueConstants.couples}/$coupleId")
        .once()
        .then((DatabaseEvent event) {
      Couple couple = Couple.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as Map), coupleId);
      if (couple.firstId == FirebaseAuth.instance.currentUser!.uid) {
        voteId = ValueConstants.firstVote;
      } else {
        voteId = ValueConstants.secondVote;
      }
    });

    DatabaseEvent foodEvent = await FirebaseDatabase.instance
        .ref(ValueConstants.foodType)
        .orderByChild(ValueConstants.coupleId)
        .equalTo(coupleId)
        .once();

    List<FoodType> listFoodTypes = foodEvent.snapshot.children
        .map((child) => FoodType.fromJson(
            Map<String, dynamic>.from(child.value as Map), child.key!))
        .toList();

    for (FoodType foodType in listFoodTypes) {
      await FirebaseDatabase.instance
          .ref('${ValueConstants.foodType}/${foodType.id}')
          .update({voteId: 0});

      DatabaseEvent restaurantEvent = await FirebaseDatabase.instance
          .ref(ValueConstants.restaurant)
          .orderByChild(ValueConstants.foodTypeId)
          .equalTo(foodType.id)
          .once();

      List<Restaurant> listRestaurants = restaurantEvent.snapshot.children
          .map((child) => Restaurant.fromJson(
              Map<String, dynamic>.from(child.value as Map), child.key!))
          .toList();
      for (Restaurant restaurant in listRestaurants) {
        await FirebaseDatabase.instance
            .ref('${ValueConstants.restaurant}/${restaurant.id}')
            .update({voteId: 0});
      }
    }
  }
}
