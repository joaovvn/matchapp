import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterController {
  RegisterController({required this.context});
  BuildContext context;
  TextEditingController titleController = TextEditingController();
  RxString option = ValueConstants.foodType.obs;
  String? foodType;
  Rx<Uint8List> image = Uint8List(0).obs;
  String? groupId;
  GetStorage storage = GetStorage();
  RxList<DropdownMenuItem> foodTypeItems =
      List<DropdownMenuItem>.empty(growable: true).obs;

  getFoodTypes() async {
    groupId = storage.read(ValueConstants.groupId);
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
            style: const TextStyle(color: ColorsConstants.main),
          ),
        ));
      }
    }
  }

  openNoPartnerDialog() {
    WidgetConstants.noGroupDialog(context);
  }

  pickImage() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        image.value = await xFile.readAsBytes();
      }
    } on PlatformException catch (error) {
      debugPrint('Failed to pick image: $error');
    }
  }

  register() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)!.fillFields,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: ColorsConstants.main,
        duration: const Duration(seconds: 1),
      ));
      return;
    }
    DatabaseReference reference =
        FirebaseDatabase.instance.ref(option.value).push();
    await reference
        .set(option.value == ValueConstants.foodType
            ? FoodType(
                    id: "",
                    title: titleController.text,
                    image: image.value.isEmpty
                        ? base64.encode(image.value.toList())
                        : "",
                    groupId: groupId!)
                .toJson()
            : Restaurant(
                    id: "",
                    title: titleController.text,
                    image: image.value.isEmpty
                        ? base64.encode(image.value.toList())
                        : "",
                    foodTypeId: foodType!)
                .toJson())
        .catchError((e) {});
    showRegisterDialog();
  }

  showRegisterDialog() {
    WidgetConstants.registerDialog(context);
  }
}
