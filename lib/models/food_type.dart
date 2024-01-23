class FoodType {
  String id;
  String title;
  String image;
  int manaVote;
  int jvVote;

  FoodType(
      {required this.id,
      required this.title,
      required this.image,
      required this.manaVote,
      required this.jvVote});

  factory FoodType.fromJson(Map<String, dynamic> json, String id) {
    return FoodType(
      id: id,
      title: json['title'],
      image: json['image'],
      manaVote: json['manaVote'],
      jvVote: json['jvVote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'manaVote': manaVote,
      'jvVote': jvVote
    };
  }
}
