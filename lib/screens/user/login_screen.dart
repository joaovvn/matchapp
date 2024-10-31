import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/user/controller/login_controller.dart';
import 'package:match_app/screens/user/widgets/login_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController controller;

  @override
  void initState() {
    controller = Get.put(LoginController(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logo(),
          body(controller, context),
          Expanded(child: WidgetConstants.languageSwitch(controller.isEnglish)),
        ],
      ),
    );
  }
}
