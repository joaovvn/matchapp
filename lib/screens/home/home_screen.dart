import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/image_constants.dart';
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
    super.initState();
  }

  WidgetConstants widgets = WidgetConstants();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widgets.appBar(true, context),
      backgroundColor: Colors.deepPurpleAccent,
      body: FutureBuilder<bool>(
          future: controller.init(),
          builder: (context, snapshot) {
            return snapshot.data == false
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : SizedBox(
                    width: screenSize.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          widgets.button(Colors.deepPurple, 0.5, () {
                            FunctionConstants.resetVotes();
                            Get.to(() => const FoodTypeMatchScreen());
                          },
                              Text(
                                AppLocalizations.of(context)!.start,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              context),
                          const Gap(20),
                          widgets.button(
                              Colors.white,
                              0.5,
                              () => Get.to(() => const RegisterScreen()),
                              Text(
                                AppLocalizations.of(context)!.register,
                                style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                              context),
                          const Gap(50),
                          TextButton(
                              onPressed: () async {
                                controller.coupleId.value.isEmpty
                                    ? controller.addPartner()
                                    : controller.removePartner();
                              },
                              style: ButtonStyle(
                                overlayColor: WidgetStateColor.resolveWith(
                                    (states) => Colors.white.withOpacity(0.1)),
                              ),
                              child: Obx(() {
                                return Text(
                                  controller.coupleId.value.isEmpty
                                      ? AppLocalizations.of(context)!.addPartner
                                      : AppLocalizations.of(context)!
                                          .removePartner,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white),
                                );
                              })),
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  controller.isEnglish.value
                                      ? ImageConstants.brFlagOutlined
                                      : ImageConstants.brFlag,
                                ),
                                Switch(
                                  value: controller.isEnglish.value,
                                  onChanged: (_) {
                                    controller.isEnglish.value =
                                        !controller.isEnglish.value;
                                    controller.isEnglish.value
                                        ? Get.updateLocale(const Locale("en"))
                                        : Get.updateLocale(const Locale("pt"));
                                  },
                                  inactiveTrackColor: ColorsConstants.brGreen,
                                  inactiveThumbColor: ColorsConstants.brYellow,
                                  activeColor: ColorsConstants.usBlue,
                                  activeTrackColor: ColorsConstants.usRed,
                                ),
                                Image.asset(
                                  controller.isEnglish.value
                                      ? ImageConstants.usFlag
                                      : ImageConstants.usFlagOutlined,
                                ),
                              ],
                            );
                          }),
                        ]),
                  );
          }),
    );
  }
}
