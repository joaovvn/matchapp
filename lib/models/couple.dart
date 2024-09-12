import 'package:match_app/constants/value_constants.dart';

class Couple {
  String id;
  String firstId;
  String secondId;

  Couple({required this.id, required this.firstId, required this.secondId});

  Map<String, dynamic> toJson() =>
      {ValueConstants.firstId: firstId, ValueConstants.secondId: secondId};

  factory Couple.fromJson(Map<String, dynamic> json, String id) {
    return Couple(
        id: id,
        firstId: json[ValueConstants.firstId],
        secondId: json[ValueConstants.secondId]);
  }
}
