import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/user/controller/user_register_controller.dart';
import 'package:match_app/screens/user/widgets/user_register_widgets.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  late UserRegisterController controller;

  @override
  void initState() {
    controller = UserRegisterController(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetConstants.appBar(false, context),
        backgroundColor: ColorsConstants.mainAccent,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() {
                return WidgetConstants.loadingStateWidget(
                  contrast: true,
                  controller.loadingState.value,
                  Column(
                    children: [
                      userNameTextField(controller.usernameController, context),
                      const Gap(5),
                      emailTextField(controller.emailController, context),
                      const Gap(5),
                      passwordTextField(controller.passwordController, context,
                          controller.onChanged),
                      const Gap(5),
                      confirmPasswordTextField(
                          controller.confirmPasswordController,
                          context,
                          controller.onChanged,
                          controller.icon.value),
                      const Gap(10),
                      registerUserButton(controller, context),
                    ],
                  ),
                );
              })
            ]));
  }
}
