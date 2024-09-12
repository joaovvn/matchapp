import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/couple.dart';
import 'package:match_app/models/food_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodTypeMatchController extends GetxController {
  FoodTypeMatchController({required this.context});
  BuildContext context;
  WidgetConstants widgets = WidgetConstants();
  String voteId = "";
  String coupleId = "";
  bool match = false;
  RxList<FoodType>? foodTypeList;

  void getList() async {
    await getUser();
    if (coupleId == "") {
      return null;
    }
    DatabaseEvent foodEvent =
        await FirebaseDatabase.instance.ref(ValueConstants.foodType).once();

    foodTypeList = foodEvent.snapshot.children
        .map((child) => FoodType.fromJson(
            Map<String, dynamic>.from(child.value as Map), child.key!))
        .toList()
        .obs;
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(ValueConstants.coupleId);
    if (id != null) {
      coupleId = id;
      DatabaseEvent coupleEvent = await FirebaseDatabase.instance
          .ref('${ValueConstants.couples}/$coupleId')
          .once();
      Couple couple = Couple.fromJson(
          Map<String, dynamic>.from(coupleEvent.snapshot.value as Map),
          coupleEvent.snapshot.key!);
      if (couple.firstId == FirebaseAuth.instance.currentUser!.uid) {
        voteId = ValueConstants.firstVote;
      } else {
        voteId = ValueConstants.secondVote;
      }
    } else {
      openNoPartnerDialog();
    }
  }

  vote(FoodType foodType, SwiperActivity activity, bool last) async {
    await FirebaseDatabase.instance
        .ref('${ValueConstants.foodType}/${foodType.id}')
        .update({voteId: activity.direction == AxisDirection.right ? 1 : -1});
    await verifyMatches(last);
  }

  verifyMatches(bool last) async {
    DatabaseEvent foodEvent = await FirebaseDatabase.instance
        .ref(ValueConstants.foodType)
        .orderByChild(ValueConstants.coupleId)
        .equalTo(coupleId)
        .once();

    List<FoodType> matches = foodEvent.snapshot.children
        .map((child) => FoodType.fromJson(
            Map<String, dynamic>.from(child.value as Map), child.key!))
        .toList();
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
