import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:match_app/models/couple.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionConstants {
  resetVotes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? coupleId = preferences.getString("coupleId");
    String voteId = "";
    QuerySnapshot<Map<String, dynamic>> foodTypes = await FirebaseFirestore
        .instance
        .collection('FoodType')
        .where("coupleId", isEqualTo: coupleId)
        .get();
    DocumentSnapshot<Map<String, dynamic>> coupleDoc = await FirebaseFirestore
        .instance
        .collection("Couples")
        .doc(coupleId)
        .get();
    if (coupleDoc.data() != null) {
      Couple couple = Couple.fromJson(coupleDoc.data()!, coupleId!);
      if (couple.firstId == FirebaseAuth.instance.currentUser!.uid) {
        voteId = "firstVote";
      } else {
        voteId = "secondVote";
      }
      List<FoodType> listFoodTypes = foodTypes.docs
          .map((doc) => FoodType.fromJson(doc.data(), doc.id))
          .toList();
      for (FoodType foodType in listFoodTypes) {
        await FirebaseFirestore.instance
            .collection('FoodType')
            .doc(foodType.id)
            .update({voteId: 0});

        QuerySnapshot<Map<String, dynamic>> restaurants =
            await FirebaseFirestore.instance
                .collection('Restaurant')
                .where("foodTypeId", isEqualTo: foodType.id)
                .get();

        List<Restaurant> listRestaurants = restaurants.docs
            .map((doc) => Restaurant.fromJson(doc.data(), doc.id))
            .toList();
        for (Restaurant restaurant in listRestaurants) {
          await FirebaseFirestore.instance
              .collection('Restaurant')
              .doc(restaurant.id)
              .update({voteId: 0});
        }
      }
    }
  }
}
