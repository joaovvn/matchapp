import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    QuerySnapshot<Map<String, dynamic>> mapRestaurant = await FirebaseFirestore
        .instance
        .collection('Restaurant')
        .where("foodTypeId", isEqualTo: foodTypeId)
        .get();
    if (mapRestaurant.docs.isEmpty) {
      FunctionConstants().resetVotes();
    }
    return mapRestaurant.docs
        .map((doc) => Restaurant.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<bool> hasMenu(String restaurantName) async {
    await getUser();
    QuerySnapshot<Map<String, dynamic>> menu = await FirebaseFirestore.instance
        .collection('Menu')
        .where("restaurant", isEqualTo: restaurantName)
        .get();
    if (menu.docs.isEmpty) {
      return false;
    }
    return true;
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

  vote(Restaurant restaurant, SwiperActivity activity, bool last) async {
    await FirebaseFirestore.instance
        .collection('Restaurant')
        .doc(restaurant.id)
        .update({voteId: activity.direction == AxisDirection.right ? 1 : -1});
    await verifyMatches(last);
  }

  verifyMatches(bool last) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('Restaurant')
        .where("foodTypeId", isEqualTo: foodTypeId)
        .get();
    List<Restaurant> matches = data.docs
        .map((doc) => Restaurant.fromJson(doc.data(), doc.id))
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
