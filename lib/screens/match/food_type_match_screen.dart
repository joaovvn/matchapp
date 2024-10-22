import 'dart:convert';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/match/controller/food_type_match_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodTypeMatchScreen extends StatefulWidget {
  const FoodTypeMatchScreen({super.key});

  @override
  State<FoodTypeMatchScreen> createState() => _FoodTypeMatchScreenState();
}

class _FoodTypeMatchScreenState extends State<FoodTypeMatchScreen> {
  bool finished = false;
  AppinioSwiperController swiperController = AppinioSwiperController();
  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FoodTypeMatchController controller =
        Get.put(FoodTypeMatchController(context: context));
    controller.getList();
    return Scaffold(
      appBar: WidgetConstants.appBar(false, context),
      body: Obx(() {
        if (controller.foodTypeList.value != null &&
            (controller.foodTypeList.value ?? []).isNotEmpty) {
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: finished
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.waitingGroupVotes,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: ColorsConstants.main),
                          ),
                        )
                      : AppinioSwiper(
                          backgroundCardCount: 2,
                          swipeOptions:
                              const SwipeOptions.symmetric(horizontal: true),
                          allowUnSwipe: false,
                          controller: swiperController,
                          cardCount: controller.foodTypeList.value!.length,
                          onEnd: () => setState(() {
                            finished = true;
                          }),
                          onSwipeEnd: (previousIndex, index, direction) async {
                            await controller.vote(
                                controller.foodTypeList.value![index - 1],
                                direction,
                                controller.foodTypeList.value!.length == index);
                          },
                          cardBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorsConstants.main,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      child: Image.memory(
                                        base64Decode(controller
                                            .foodTypeList.value![index].image),
                                        gaplessPlayback: true,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          controller
                                              .foodTypeList.value![index].title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
              finished
                  ? Expanded(child: Container())
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              iconSize: 50,
                              onPressed: () => swiperController.swipeLeft(),
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.red)),
                              icon: const Icon(
                                Icons.close,
                                color: ColorsConstants.contrast,
                              )),
                          IconButton(
                              iconSize: 50,
                              onPressed: () => swiperController.swipeRight(),
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.green)),
                              icon: const Icon(
                                Icons.check,
                                color: ColorsConstants.contrast,
                              ))
                        ],
                      ),
                    )
            ],
          );
        }
        return controller.foodTypeList.value == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorsConstants.main,
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    AppLocalizations.of(context)!.noRegisteredFoods,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: ColorsConstants.main),
                  ),
                ),
              );
      }),
    );
  }
}
