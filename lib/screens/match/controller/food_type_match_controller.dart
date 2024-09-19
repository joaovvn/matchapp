import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/vote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodTypeMatchController extends GetxController {
  FoodTypeMatchController({required this.context});
  BuildContext context;
  WidgetConstants widgets = WidgetConstants();
  String voteId = "";
  String groupId = "";
  bool match = false;
  Rx<List<FoodType>?> foodTypeList = Rx<List<FoodType>?>(null);

  void getList() async {
    await getUser();
    if (groupId == "") {
      return;
    }
    DatabaseEvent foodEvent = await FirebaseDatabase.instance
        .ref(ValueConstants.foodType)
        .orderByChild(ValueConstants.groupId)
        .equalTo(groupId)
        .once();

    foodTypeList.value = List<FoodType>.empty();

    foodTypeList.value = foodEvent.snapshot.children
        .map((child) => FoodType.fromJson(
            Map<String, dynamic>.from(child.value as Map), child.key!))
        .toList();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(ValueConstants.groupId);
    if (id != null) {
      groupId = id;
      await verifyMatches();
    } else {
      openNoGroupDialog();
    }
  }

  vote(FoodType foodType, SwiperActivity activity, bool last) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref(ValueConstants.votes);
    reference.set(FoodVote(
        foodTypeId: foodType.id,
        groupId: groupId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        vote: activity.direction == AxisDirection.right ? 1 : -1));
  }

  verifyMatches() async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref(ValueConstants.groupMembers)
        .orderByChild(ValueConstants.groupId)
        .get();
    int groupSize = snapshot.children.length;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref(ValueConstants.votes);
    for (FoodType foodType in foodTypeList.value!) {
      reference
          .orderByChild(ValueConstants.groupId)
          .equalTo(groupId)
          .orderByChild(ValueConstants.restaurantId)
          .equalTo(foodType.id)
          .orderByChild(ValueConstants.vote)
          .equalTo(1)
          .onValue
          .listen((DatabaseEvent event) {
        if (event.snapshot.children.length == groupSize) {
          openMatchDialog(foodType);
        }
      });
    }
    reference
        .orderByChild(ValueConstants.groupId)
        .equalTo(groupId)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.children.length ==
          groupSize * foodTypeList.value!.length) {
        openNoMatchDialog();
      }
    });
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

  openNoGroupDialog() {
    widgets.noGroupDialog(context);
  }
}
