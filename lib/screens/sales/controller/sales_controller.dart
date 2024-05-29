import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/menu_item.dart';
import 'package:match_app/models/restaurant.dart';

class SalesController extends GetxController {
  WidgetConstants widgets = WidgetConstants();
  late BuildContext _context;
  late Restaurant restaurant;
  RxList<MenuItem> menu = <MenuItem>[].obs;
  RxList<MenuItem> shoppingCart = List<MenuItem>.empty(growable: true).obs;

  init({required Restaurant restaurant, required BuildContext context}) {
    this.restaurant = restaurant;
    getList();
    _context = context;
  }

  getList() async {
    QuerySnapshot<Map<String, dynamic>> mapMenu = await FirebaseFirestore
        .instance
        .collection('Menu')
        .where("restaurant", isEqualTo: restaurant.title)
        .get();
    menu.assignAll(
        mapMenu.docs.map((doc) => MenuItem.fromJson(doc.data())).toList());
  }

  String getTotalPrice() {
    double total = 0;
    for (MenuItem item in shoppingCart) {
      total += item.price * item.quantity;
    }
    return total.toStringAsFixed(2);
  }

  String getTotalItems() {
    int total = 0;
    for (MenuItem item in shoppingCart) {
      total += item.quantity;
    }
    return total.toString();
  }

  void addItemToCart(MenuItem item, RxInt quantity) {
    if (shoppingCart.contains(item)) {
      shoppingCart
          .firstWhere((product) => item.itemName == product.itemName)
          .quantity += quantity.value;
    } else {
      item.quantity = quantity.value;
      shoppingCart.add(item);
    }
    widgets.showWarning(_context, "${item.itemName} adicionado com sucesso!");
  }

  removeItemFromCart(int index) {
    String itemName = shoppingCart[index].itemName;
    shoppingCart.removeAt(index);
    widgets.showWarning(_context, "$itemName removido com sucesso!");
  }
}
