import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/couple.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantMatchController {
  RestaurantMatchController({required this.context, required this.foodTypeId});
  BuildContext context;
  WidgetConstants widgets = WidgetConstants();
  String voteId = "";
  String coupleId = "";
  String foodTypeId;
  bool match = false;

  Future<List<Restaurant>> getList() async {
    await getUser();
    DatabaseEvent restaurantEvent = await FirebaseDatabase.instance
        .ref("restaurant")
        .orderByChild("foodTypeId")
        .equalTo(foodTypeId)
        .once();

    if (!restaurantEvent.snapshot.exists) {
      FunctionConstants.resetVotes();
    }
    return restaurantEvent.snapshot.children
        .map((child) => Restaurant.fromJson(
            Map<String, dynamic>.from(child.value as Map), child.key!))
        .toList();
  }

  Future<bool> hasMenu(String restaurantName) async {
    await getUser();

    DatabaseEvent restaurantEvent = await FirebaseDatabase.instance
        .ref('menu')
        .orderByChild('restaurant')
        .equalTo(restaurantName)
        .once();

    if (!restaurantEvent.snapshot.exists) {
      return false;
    }
    return true;
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString("coupleId");
    if (id != null) {
      coupleId = id;
      DatabaseEvent coupleEvent =
          await FirebaseDatabase.instance.ref('couples/$coupleId').once();
      Couple couple = Couple.fromJson(
          Map<String, dynamic>.from(coupleEvent.snapshot.value as Map),
          coupleEvent.snapshot.key!);
      if (couple.firstId == FirebaseAuth.instance.currentUser!.uid) {
        voteId = "firstVote";
      } else {
        voteId = "secondVote";
      }
    } else {
      openNoPartnerDialog();
    }
  }

  vote(Restaurant restaurant, SwiperActivity activity, bool last) async {
    await FirebaseDatabase.instance
        .ref('restaurant/${restaurant.id}')
        .update({voteId: activity.direction == AxisDirection.right ? 1 : -1});
    await verifyMatches(last);
  }

  verifyMatches(bool last) async {
    DatabaseEvent restaurantEvent = await FirebaseDatabase.instance
        .ref('restaurant')
        .orderByChild('foodTypeId')
        .equalTo(foodTypeId)
        .once();

    List<Restaurant> matches = restaurantEvent.snapshot.children
        .map((child) => Restaurant.fromJson(
            Map<String, dynamic>.from(child.value as Map), child.key!))
        .toList();
    if (matches.isNotEmpty &&
        matches.any((element) =>
            element.firstVote == element.secondVote &&
            element.firstVote == 1)) {
      Restaurant restaurant = matches.firstWhere((element) =>
          element.firstVote == element.secondVote && element.firstVote == 1);
      bool showMenu = await hasMenu(restaurant.title);
      openMatchDialog(restaurant, showMenu);
    } else if (last &&
        matches.every((element) =>
            ((element.firstVote == -1 && element.secondVote.isOdd) ||
                (element.firstVote.isOdd && element.secondVote == -1)))) {
      openNoMatchDialog();
    } else {
      verifyMatches(last);
    }
  }

  openMatchDialog(Restaurant restaurant, bool showMenu) async {
    if (!match) {
      match = true;
      widgets.restaurantMatchDialog(context, restaurant, showMenu);
    }
  }

  openNoMatchDialog() {
    widgets.noMatchDialog(context);
  }

  openNoPartnerDialog() {
    widgets.noPartnerDialog(context);
  }
}
