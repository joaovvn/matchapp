class FoodType {
  String id;
  String coupleId;
  String title;
  String image;
  int firstVote;
  int secondVote;

  FoodType(
      {required this.id,
      required this.title,
      required this.image,
      required this.coupleId,
      required this.firstVote,
      required this.secondVote});

  factory FoodType.fromJson(Map<String, dynamic> json, String id) {
    return FoodType(
      id: id,
      title: json['title'],
      coupleId: json['coupleId'],
      image: json['image'],
      firstVote: json['firstVote'],
      secondVote: json['secondVote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'coupleId': coupleId,
      'firstVote': firstVote,
      'secondVote': secondVote
    };
  }
}
