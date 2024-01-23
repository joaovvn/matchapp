import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match_app/models/food_type.dart';

class FoodTypeMatchController {
  Future<List<FoodType>> getList() async {
    QuerySnapshot<Map<String, dynamic>> mapFoodType =
        await FirebaseFirestore.instance.collection('FoodType').get();
    return mapFoodType.docs
        .map((doc) => FoodType.fromJson(doc.data(), doc.id))
        .toList();
  }

  vote(FoodType foodType, String vote, AppinioSwiperDirection direction) async {
    await FirebaseFirestore.instance
        .collection('FoodType')
        .doc(foodType.id)
        .update({vote: direction == AppinioSwiperDirection.right ? 1 : -1});
  }
}
