import 'dart:async';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:match_app/models/vote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantMatchController extends GetxController {
  RestaurantMatchController({required this.context, required this.foodTypeId});
  BuildContext context;
  WidgetConstants widgets = WidgetConstants();
  late String groupId;
  String foodTypeId;
  bool match = false;
  Rx<List<Restaurant>?> restaurantList = Rx<List<Restaurant>?>(null);

  Future<void> getList() async {
    await getUser();
    DatabaseEvent restaurantEvent = await FirebaseDatabase.instance
        .ref(ValueConstants.restaurant)
        .orderByChild(ValueConstants.foodTypeId)
        .equalTo(foodTypeId)
        .once();

    if (!restaurantEvent.snapshot.exists) {
      FunctionConstants.resetVotes();
    }
    restaurantList.value = restaurantEvent.snapshot.children
        .map((child) => Restaurant.fromJson(
            Map<String, dynamic>.from(child.value as Map), child.key!))
        .toList();
  }

  Future<bool> hasMenu(String restaurantName) async {
    await getUser();

    DatabaseEvent restaurantEvent = await FirebaseDatabase.instance
        .ref(ValueConstants.menu)
        .orderByChild(ValueConstants.restaurant)
        .equalTo(restaurantName)
        .once();

    if (!restaurantEvent.snapshot.exists) {
      return false;
    }
    return true;
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(ValueConstants.groupId);
    if (id != null) {
      groupId = id;
      verifyMatches();
    } else {
      openNoGroupDialog();
    }
  }

  vote(Restaurant restaurant, SwiperActivity activity, bool last) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref(ValueConstants.votes);
    reference.set(RestaurantVote(
        restaurantId: restaurant.id,
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
    for (Restaurant restaurant in restaurantList.value!) {
      reference
          .orderByChild(ValueConstants.groupId)
          .equalTo(groupId)
          .orderByChild(ValueConstants.restaurantId)
          .equalTo(restaurant.id)
          .orderByChild(ValueConstants.vote)
          .equalTo(1)
          .onValue
          .listen((DatabaseEvent event) {
        if (event.snapshot.children.length == groupSize) {
          openMatchDialog(restaurant);
        }
      });
    }
    reference
        .orderByChild(ValueConstants.groupId)
        .equalTo(groupId)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.children.length ==
          groupSize * restaurantList.value!.length) {
        openNoMatchDialog();
      }
    });
  }

  openMatchDialog(Restaurant restaurant) async {
    if (!match) {
      match = true;
      widgets.restaurantMatchDialog(context, restaurant, false);
    }
  }

  openNoMatchDialog() {
    if (!match) {
      widgets.noMatchDialog(context);
    }
  }

  openNoGroupDialog() {
    widgets.noGroupDialog(context);
  }
}
