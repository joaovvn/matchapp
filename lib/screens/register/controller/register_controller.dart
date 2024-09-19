import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterController {
  RegisterController({required this.context});
  BuildContext context;
  TextEditingController titleController = TextEditingController();
  String option = ValueConstants.foodType;
  String? foodType;
  Uint8List? image;
  String? groupId;
  List<DropdownMenuItem> foodTypeItems =
      List<DropdownMenuItem>.empty(growable: true);
  WidgetConstants widgets = WidgetConstants();

  Future<bool> getFoodTypes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    groupId = preferences.getString(ValueConstants.groupId);
    if (groupId == null) {
      openNoPartnerDialog();
    } else {
      DatabaseEvent foodEvent = await FirebaseDatabase.instance
          .ref(ValueConstants.foodType)
          .orderByChild(ValueConstants.groupId)
          .equalTo(groupId)
          .once();

      List<FoodType> foodTypes = foodEvent.snapshot.children
          .map((child) => FoodType.fromJson(
              Map<String, dynamic>.from(child.value as Map), child.key!))
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
    widgets.noGroupDialog(context);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)!.fillFields,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 1),
      ));
      return;
    }
    DatabaseReference reference = FirebaseDatabase.instance.ref(option).push();
    await reference
        .set(option == ValueConstants.foodType
            ? FoodType(
                    id: "",
                    title: titleController.text,
                    image: image != null ? base64.encode(image!.toList()) : "",
                    groupId: groupId!)
                .toJson()
            : Restaurant(
                    id: "",
                    title: titleController.text,
                    image: image != null ? base64.encode(image!.toList()) : "",
                    foodTypeId: foodType!)
                .toJson())
        .catchError((e) {
      debugPrint(e);
    });
    showRegisterDialog();
  }

  showRegisterDialog() {
    widgets.registerDialog(context);
  }
}
