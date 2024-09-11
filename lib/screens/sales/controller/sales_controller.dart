import 'package:firebase_database/firebase_database.dart';
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
    DatabaseEvent restaurantEvent = await FirebaseDatabase.instance
        .ref('menu')
        .orderByChild('restaurant')
        .equalTo(restaurant.title)
        .once();
    menu.assignAll(restaurantEvent.snapshot.children
        .map((child) =>
            MenuItem.fromJson(Map<String, dynamic>.from(child.value as Map)))
        .toList());
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
