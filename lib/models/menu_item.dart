import 'package:match_app/constants/value_constants.dart';

class MenuItem {
  String restaurant;
  String itemName;
  String description;
  double price;
  int quantity = 0;

  MenuItem(
      {required this.restaurant,
      required this.itemName,
      required this.description,
      required this.price});

  Map<String, dynamic> toJson() {
    return {
      ValueConstants.restaurant: restaurant,
      ValueConstants.itemName: itemName,
      ValueConstants.description: description,
      ValueConstants.price: price
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
        restaurant: json[ValueConstants.restaurant],
        itemName: json[ValueConstants.itemName],
        description: json[ValueConstants.description],
        price: json[ValueConstants.price]);
  }
}
