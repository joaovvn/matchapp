import 'dart:convert';
import 'dart:typed_data';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/image_constants.dart';
import 'package:match_app/constants/loading_state.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:match_app/screens/match/restaurant_match_screen.dart';
import 'package:match_app/screens/sales/sales_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WidgetConstants {
  static Widget button(Color color, double width, Function()? onPressed,
      Widget child, BuildContext context,
      {Color borderColor = ColorsConstants.contrast}) {
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width * width, 48)),
            backgroundColor: WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ))),
        onPressed: onPressed,
        child: child);
  }

  static Widget textButton(Function()? onPressed, Widget child) {
    return TextButton(onPressed: onPressed, child: child);
  }

  static AppBar appBar(bool isHome, BuildContext context,
      {Function()? onPressed, User? user}) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: ColorsConstants.contrast,
      centerTitle: true,
      title: Image.asset(
        ImageConstants.logo,
      ),
      leading: isHome
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: ColorsConstants.main,
              ),
              onPressed: () {
                Get.until((route) => route.isFirst);
              },
            ),
      actions: isHome
          ? [
              IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: ColorsConstants.main,
                  ),
                  onPressed: onPressed)
            ]
          : null,
    );
  }

  static showWarning(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorsConstants.main,
      duration: const Duration(seconds: 1, milliseconds: 500),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: ColorsConstants.contrast,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
    ));
  }

  static registerDialog(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromRGBO(255, 255, 255, 1)),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.registeredSuccesfully,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: ColorsConstants.main,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.05, vertical: 20.0),
                  child: button(ColorsConstants.main, 0.9, () {
                    Get.until((route) => route.isFirst);
                  },
                      Text(AppLocalizations.of(context)!.ok,
                          style: const TextStyle(
                              fontSize: 10,
                              color: ColorsConstants.contrast,
                              fontWeight: FontWeight.bold)),
                      context),
                )
              ]),
        ),
      ),
    );
  }

  static restaurantMatchDialog(
      BuildContext context, Restaurant restaurant, bool showMenu) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromRGBO(255, 255, 255, 1)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.match,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: ColorsConstants.main,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Image.memory(
                                base64Decode(restaurant.image),
                                gaplessPlayback: true,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                restaurant.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorsConstants.main,
                                    fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                      showMenu
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05,
                                  vertical: 20.0),
                              child: button(ColorsConstants.main, 0.9,
                                  () async {
                                Get.back();
                                Get.off(() => SalesScreen(
                                      restaurant: restaurant,
                                    ));
                              },
                                  Text(AppLocalizations.of(context)!.placeOrder,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: ColorsConstants.contrast,
                                          fontWeight: FontWeight.bold)),
                                  context),
                            )
                          : const Gap(20),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                            bottom: 20.0),
                        child: button(ColorsConstants.main, 0.9, () async {
                          await launchUrl(Uri.parse(
                              "https://maps.google.com/?q=${restaurant.title}"));
                        },
                            Text(AppLocalizations.of(context)!.findLocation,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorsConstants.contrast,
                                    fontWeight: FontWeight.bold)),
                            context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                            bottom: 20.0),
                        child: button(ColorsConstants.main, 0.9, () {
                          Get.until((route) => route.isFirst);
                          FunctionConstants.resetVotes();
                        },
                            Text(AppLocalizations.of(context)!.ok,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorsConstants.contrast,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
              ),
            ));
  }

  static foodMatchDialog(BuildContext context, FoodType foodType) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              backgroundColor: ColorsConstants.contrast,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromRGBO(255, 255, 255, 1)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.match,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: ColorsConstants.main,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.chooseRestaurant,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: ColorsConstants.main,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Image.memory(
                                base64Decode(foodType.image),
                                gaplessPlayback: true,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  foodType.title,
                                  style: const TextStyle(
                                    color: ColorsConstants.main,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05, vertical: 20),
                        child: button(ColorsConstants.main, 0.9, () {
                          Get.back();
                          Get.off(() => RestaurantMatchScreen(
                                foodTypeId: foodType.id,
                              ));
                        },
                            Text(AppLocalizations.of(context)!.proceed,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorsConstants.contrast,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
              ),
            ));
  }

  static noGroupDialog(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromRGBO(255, 255, 255, 1)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.groupNotAdded,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: ColorsConstants.main,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(ColorsConstants.main, 0.9, () {
                          Get.until((route) => route.isFirst);
                        },
                            Text(AppLocalizations.of(context)!.backToHome,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorsConstants.contrast,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }

  static noMatchDialog(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromRGBO(255, 255, 255, 1)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.noMatch,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: ColorsConstants.main,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(ColorsConstants.main, 0.9, () {
                          FunctionConstants.resetVotes();
                          Get.until((route) => route.isFirst);
                        },
                            Text(AppLocalizations.of(context)!.backToHome,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorsConstants.contrast,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }

  static Widget dropdown(List<DropdownMenuItem> items, String title,
      Function(dynamic)? onChanged, dynamic value, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: ColorsConstants.main, fontWeight: FontWeight.w600),
            ),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: ColorsConstants.main)),
            ),
            items: items,
            onChanged: onChanged,
            value: value,
          ),
        ],
      ),
    );
  }

  static Widget imagePicker(
      Uint8List image, Function() onTap, BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                AppLocalizations.of(context)!.image,
                style: const TextStyle(
                    color: ColorsConstants.main, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: image.isEmpty
                              ? Colors.grey
                              : ColorsConstants.main,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: image.isEmpty
                        ? const Icon(
                            Icons.image_search,
                            color: Colors.grey,
                            size: 60,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(image, fit: BoxFit.fitHeight)),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  static Widget textField(
      TextEditingController controller, String title, BuildContext context,
      {bool isPassword = false,
      bool filled = false,
      double width = 0.8,
      Function? onSubmitted}) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: TextStyle(
                  color:
                      filled ? ColorsConstants.contrast : ColorsConstants.main,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextField(
            onSubmitted: (_) => onSubmitted != null ? onSubmitted() : null,
            style: const TextStyle(
                color: ColorsConstants.main, fontWeight: FontWeight.w600),
            controller: controller,
            obscureText: isPassword,
            cursorColor: ColorsConstants.main,
            decoration: InputDecoration(
                filled: filled,
                fillColor: ColorsConstants.contrast,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorsConstants.main),
                    borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  static languageSwitch(RxBool isEnglish) {
    GetStorage storage = GetStorage();
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isEnglish.value
                ? ImageConstants.brFlagOutlined
                : ImageConstants.brFlag,
          ),
          Switch(
            value: isEnglish.value,
            onChanged: (_) async {
              isEnglish.value = !isEnglish.value;
              Locale locale =
                  isEnglish.value ? const Locale("en") : const Locale("pt");
              await Get.updateLocale(locale);
              storage.write("locale", locale.languageCode);
            },
            inactiveTrackColor: ColorsConstants.brGreen,
            inactiveThumbColor: ColorsConstants.brYellow,
            activeColor: ColorsConstants.usBlue,
            activeTrackColor: ColorsConstants.usRed,
          ),
          Image.asset(
            isEnglish.value
                ? ImageConstants.usFlag
                : ImageConstants.usFlagOutlined,
          ),
        ],
      );
    });
  }

  static addedGroup(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromRGBO(255, 255, 255, 1)),
              height: screenSize.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.groupAdded,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: ColorsConstants.main,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(ColorsConstants.main, 0.9, () {
                          Get.back();
                        },
                            Text(AppLocalizations.of(context)!.ok,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorsConstants.contrast,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }

  static removedGroup(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromRGBO(255, 255, 255, 1)),
              height: screenSize.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.groupRemoved,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: ColorsConstants.main,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(ColorsConstants.main, 0.9, () {
                          Get.back();
                        },
                            Text(AppLocalizations.of(context)!.ok,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorsConstants.contrast,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }

  static Widget loadingStateWidget(
      LoadingState loadingState, Widget idleWidget) {
    Widget widget;
    switch (loadingState) {
      case LoadingState.idle:
        widget = idleWidget;
        break;
      case LoadingState.loading:
        widget = const CircularProgressIndicator(
          color: ColorsConstants.mainAccent,
        );
        break;
      case LoadingState.success:
        widget = const Icon(Icons.check,
            color: Colors.green, size: 50, key: ValueKey(LoadingState.success));
        break;
      case LoadingState.error:
        widget = const Icon(Icons.close,
            color: Colors.red, size: 50, key: ValueKey(LoadingState.error));
        break;
    }

    return AnimatedSwitcher(
      duration: Durations.medium2,
      child: widget,
    );
  }

  static warning(String warning) {
    return Center(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          warning,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: ColorsConstants.main),
        ),
      ),
    );
  }

  static waitingVotes(BuildContext context) {
    return warning(AppLocalizations.of(context)!.waitingGroupVotes);
  }

  static voteButtons(AppinioSwiperController swiperController) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              iconSize: 50,
              onPressed: () => swiperController.swipeLeft(),
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red)),
              icon: const Icon(
                Icons.close,
                color: ColorsConstants.contrast,
              )),
          IconButton(
              iconSize: 50,
              onPressed: () => swiperController.swipeRight(),
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
              icon: const Icon(
                Icons.check,
                color: ColorsConstants.contrast,
              ))
        ],
      ),
    );
  }

  static loader() {
    return const Center(
      child: CircularProgressIndicator(
        color: ColorsConstants.main,
      ),
    );
  }
}
