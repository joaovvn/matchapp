class Restaurant {
  String id;
  String foodTypeId;
  String title;
  String image;
  int firstVote;
  int secondVote;

  Restaurant(
      {required this.id,
      required this.title,
      required this.image,
      required this.foodTypeId,
      required this.firstVote,
      required this.secondVote});

  factory Restaurant.fromJson(Map<String, dynamic> json, String id) {
    return Restaurant(
        id: id,
        title: json['title'],
        foodTypeId: json['foodTypeId'],
        image: json['image'],
        firstVote: json['firstVote'],
        secondVote: json['secondVote']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'foodTypeId': foodTypeId,
      'firstVote': firstVote,
      'secondVote': secondVote
    };
  }
}
