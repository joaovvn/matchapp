import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/home/controller/home_controller.dart';
import 'package:match_app/screens/match/food_type_match_screen.dart';
import 'package:match_app/screens/register/register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              WidgetConstants.button(ColorsConstants.main, 0.5, () {
                FunctionConstants.resetVotes();
                Get.to(() => const FoodTypeMatchScreen());
              },
                  Text(
                    AppLocalizations.of(context)!.start,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsConstants.contrast),
                  ),
                  context),
              const Gap(20),
              WidgetConstants.button(
                  ColorsConstants.contrast,
                  0.5,
                  () => Get.to(() => const RegisterScreen()),
                  Text(
                    AppLocalizations.of(context)!.register,
                    style: const TextStyle(
                        color: ColorsConstants.main,
                        fontWeight: FontWeight.bold),
                  ),
                  context),
              const Gap(50),
              TextButton(
                  onPressed: () async {
                    controller.groupId.value.isEmpty
                        ? controller.addGroup()
                        : controller.removeGroup();
                  },
                  style: ButtonStyle(
                    overlayColor: WidgetStateColor.resolveWith(
                        (states) => ColorsConstants.contrast.withOpacity(0.1)),
                  ),
                  child: Obx(() {
                    return Text(
                      controller.groupId.value.isEmpty
                          ? AppLocalizations.of(context)!.addGroup
                          : AppLocalizations.of(context)!.removeGroup,
                      style: const TextStyle(
                          fontSize: 12,
                          color: ColorsConstants.contrast,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorsConstants.contrast),
                    );
                  })),
              Obx(() {
                return WidgetConstants.languageSwitch(controller.isEnglish);
              }),
            ]));
  }
}
