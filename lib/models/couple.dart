class Couple {
  String id;
  String firstId;
  String secondId;

  Couple({required this.id, required this.firstId, required this.secondId});

  Map<String, dynamic> toJson() => {'firstId': firstId, 'secondId': secondId};

  factory Couple.fromJson(Map<String, dynamic> json, String id) {
    return Couple(id: id, firstId: json['firstId'], secondId: json['secondId']);
  }
}
