import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/couple.dart';
import 'package:match_app/models/food_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodTypeMatchController {
  FoodTypeMatchController({required this.context});
  BuildContext context;
  WidgetConstants widgets = WidgetConstants();
  String voteId = "";
  String coupleId = "";
  bool match = false;

  Future<List<FoodType>?> getList() async {
    await getUser();
    if (coupleId == "") {
      return null;
    }
    QuerySnapshot<Map<String, dynamic>> mapFoodType = await FirebaseFirestore
        .instance
        .collection('FoodType')
        .where("coupleId", isEqualTo: coupleId)
        .get();
    return mapFoodType.docs
        .map((doc) => FoodType.fromJson(doc.data(), doc.id))
        .toList();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("coupleId");
    if (id != null) {
      coupleId = id;
      DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection("Couples")
          .doc(coupleId)
          .get();
      Couple couple = Couple.fromJson(data.data()!, coupleId);
      if (couple.firstId == FirebaseAuth.instance.currentUser!.uid) {
        voteId = "firstVote";
      } else {
        voteId = "secondVote";
      }
    } else {
      openNoPartnerDialog();
    }
  }

  vote(FoodType foodType, SwiperActivity activity, bool last) async {
    await FirebaseFirestore.instance
        .collection('FoodType')
        .doc(foodType.id)
        .update({voteId: activity.direction == AxisDirection.right ? 1 : -1});
    await verifyMatches(last);
  }

  verifyMatches(bool last) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('FoodType')
        .where("coupleId", isEqualTo: coupleId)
        .get();
    List<FoodType> matches =
        data.docs.map((doc) => FoodType.fromJson(doc.data(), doc.id)).toList();
    if (matches.isNotEmpty &&
        matches.any((element) =>
            element.firstVote == element.secondVote &&
            element.firstVote == 1)) {
      openMatchDialog(matches.firstWhere((element) =>
          element.firstVote == element.secondVote && element.firstVote == 1));
    } else if (last &&
        matches.every((element) =>
            ((element.firstVote == -1 && element.secondVote.isOdd) ||
                (element.firstVote.isOdd && element.secondVote == -1)))) {
      openNoMatchDialog();
    } else {
      verifyMatches(last);
    }
  }

  openMatchDialog(FoodType foodType) {
    if (!match) {
      match = true;
      widgets.foodMatchDialog(context, foodType);
    }
  }

  openNoMatchDialog() {
    widgets.noMatchDialog(context);
  }

  openNoPartnerDialog() {
    widgets.noPartnerDialog(context);
  }
}
