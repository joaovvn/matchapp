import 'dart:convert';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/match/controller/restaurant_match_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RestaurantMatchScreen extends StatefulWidget {
  const RestaurantMatchScreen({super.key, required this.foodTypeId});

  final String foodTypeId;

  @override
  State<RestaurantMatchScreen> createState() => _RestaurantMatchScreenState();
}

class _RestaurantMatchScreenState extends State<RestaurantMatchScreen> {
  bool finished = false;
  AppinioSwiperController swiperController = AppinioSwiperController();
  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantMatchController controller = RestaurantMatchController(
        context: context, foodTypeId: widget.foodTypeId);
    return Scaffold(
      appBar: WidgetConstants.appBar(false, context,
          onPressed: FunctionConstants.resetVotes),
      body: Obx(() {
        if (controller.restaurantList.value != null &&
            (controller.restaurantList.value ?? []).isNotEmpty) {
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
                          cardCount: controller.restaurantList.value!.length,
                          onEnd: () => setState(() {
                            finished = true;
                          }),
                          onSwipeEnd: (previousIndex, index, direction) async {
                            await controller.vote(
                                controller.restaurantList.value![index - 1],
                                direction,
                                controller.restaurantList.value!.length ==
                                    index);
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
                                        base64Decode(controller.restaurantList
                                            .value![index].image),
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
                                          controller.restaurantList
                                              .value![index].title,
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
        return controller.restaurantList.value == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorsConstants.main,
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    AppLocalizations.of(context)!.noRegisteredRestaurants,
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
