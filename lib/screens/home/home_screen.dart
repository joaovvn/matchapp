import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/home/controller/home_controller.dart';
import 'package:match_app/screens/home/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;

  @override
  void initState() {
    controller = Get.put(HomeController(context: context));
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetConstants.appBar(true, context, onPressed: () async {
          await controller.logOut();
        }),
        backgroundColor: ColorsConstants.mainAccent,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              startButton(context),
              const Gap(20),
              registerButton(context),
              const Gap(50),
              groupButton(controller, context),
              WidgetConstants.languageSwitch(controller.isEnglish)
            ]));
  }
}
