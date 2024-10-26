import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/register/controller/register_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterController controller;

  @override
  void initState() {
    controller = RegisterController(context: context);
    super.initState();
  }

  bool finished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: WidgetConstants.appBar(false, context),
        body: Obx(() {
          return SafeArea(
            top: false,
            left: false,
            right: false,
            child: Center(
              child: Column(
                children: [
                  const Gap(5),
                  WidgetConstants.dropdown(
                      controller.foodTypeItems.isNotEmpty
                          ? [
                              DropdownMenuItem(
                                value: ValueConstants.foodType,
                                child: Text(
                                  AppLocalizations.of(context)!.foodType,
                                  style: const TextStyle(
                                      color: ColorsConstants.main),
                                ),
                              ),
                              DropdownMenuItem(
                                value: ValueConstants.restaurant,
                                child: Text(
                                  AppLocalizations.of(context)!.restaurant,
                                  style: const TextStyle(
                                      color: ColorsConstants.main),
                                ),
                              )
                            ]
                          : [
                              DropdownMenuItem(
                                value: ValueConstants.foodType,
                                child: Text(
                                  AppLocalizations.of(context)!.foodType,
                                  style: const TextStyle(
                                      color: ColorsConstants.main),
                                ),
                              ),
                            ],
                      AppLocalizations.of(context)!.type,
                      (option) => controller.option.value = option!,
                      controller.option.value,
                      context),
                  controller.option.value == ValueConstants.restaurant
                      ? Column(
                          children: [
                            const Gap(5),
                            WidgetConstants.dropdown(controller.foodTypeItems,
                                AppLocalizations.of(context)!.culinary,
                                (option) {
                              controller.foodType = option;
                            }, controller.foodType, context),
                            const Gap(5),
                          ],
                        )
                      : const Gap(5),
                  WidgetConstants.textField(controller.titleController,
                      AppLocalizations.of(context)!.title, context),
                  const Gap(5),
                  Obx(
                    () => WidgetConstants.imagePicker(controller.image.value,
                        () async {
                      await controller.pickImage();
                    }, context),
                  ),
                  const Gap(5),
                  WidgetConstants.button(
                      ColorsConstants.main,
                      0.85,
                      () => controller.register(),
                      Text(AppLocalizations.of(context)!.register,
                          style: const TextStyle(
                              fontSize: 10,
                              color: ColorsConstants.contrast,
                              fontWeight: FontWeight.bold)),
                      context)
                ],
              ),
            ),
          );
        }));
  }
}
