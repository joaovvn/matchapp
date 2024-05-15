import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController {
  RegisterController({required this.context});
  BuildContext context;
  TextEditingController titleController = TextEditingController();
  String option = "FoodType";
  String? foodType;
  Uint8List? image;
  String? coupleId;
  List<DropdownMenuItem> foodTypeItems =
      List<DropdownMenuItem>.empty(growable: true);
  WidgetConstants widgets = WidgetConstants();

  Future<bool> getFoodTypes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    coupleId = preferences.getString("coupleId");
    if (coupleId == null) {
      openNoPartnerDialog();
    } else {
      QuerySnapshot<Map<String, dynamic>> mapFoodType = await FirebaseFirestore
          .instance
          .collection('FoodType')
          .where("coupleId", isEqualTo: coupleId)
          .get();
      List<FoodType> foodTypes = mapFoodType.docs
          .map((doc) => FoodType.fromJson(doc.data(), doc.id))
          .toList();

      if (foodTypes.isNotEmpty && foodType == null) {
        foodType = foodTypes[0].id;
      }

      foodTypeItems.clear();

      for (FoodType foodType in foodTypes) {
        foodTypeItems.add(DropdownMenuItem(
          value: foodType.id,
          child: Text(
            foodType.title,
            style: const TextStyle(color: Colors.deepPurple),
          ),
        ));
      }
    }
    return true;
  }

  openNoPartnerDialog() {
    widgets.noPartnerDialog(context);
  }

  pickImage() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        image = await xFile.readAsBytes();
      }
    } on PlatformException catch (error) {
      debugPrint('Failed to pick image: $error');
    }
  }

  register() async {
    if (titleController.text.isEmpty || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Preencha todos os campos!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.deepPurple,
        duration: Duration(seconds: 1),
      ));
      return;
    }
    await FirebaseFirestore.instance.collection(option).add(option == "FoodType"
        ? FoodType(
                id: "",
                title: titleController.text,
                image: image != null ? base64.encode(image!.toList()) : "",
                coupleId: coupleId!,
                firstVote: 0,
                secondVote: 0)
            .toJson()
        : Restaurant(
                id: "",
                firstVote: 0,
                secondVote: 0,
                title: titleController.text,
                image: image != null ? base64.encode(image!.toList()) : "",
                foodTypeId: foodType!)
            .toJson());
    showRegisterDialog();
  }

  showRegisterDialog() {
    widgets.registerDialog(context);
  }
}