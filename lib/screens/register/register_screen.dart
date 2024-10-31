import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/register/controller/register_controller.dart';
import 'package:match_app/screens/register/widgets/register_widgets.dart';

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
                  registerOptionDropdown(controller, context),
                  controller.option.value == ValueConstants.restaurant
                      ? foodTypeDropdown(controller, context)
                      : const Gap(5),
                  titleTextField(controller, context),
                  const Gap(5),
                  imagePicker(controller, context),
                  const Gap(5),
                  registerButton(controller, context)
                ],
              ),
            ),
          );
        }));
  }
}
