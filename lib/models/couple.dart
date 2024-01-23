class Couple {
  String firstId;
  String secondId;

  Couple({required this.firstId, required this.secondId});

  Map<String, dynamic> toJson() => {'firstId': firstId, 'secondId': secondId};
}
