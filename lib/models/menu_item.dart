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
      'restaurant': restaurant,
      'itemName': itemName,
      'description': description,
      'price': price
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
        restaurant: json['restaurant'],
        itemName: json['itemName'],
        description: json['description'],
        price: json['price']);
  }
}
