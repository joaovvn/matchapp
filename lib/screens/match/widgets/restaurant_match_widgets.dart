import 'dart:convert';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/match/controller/restaurant_match_controller.dart';

noRegisteredRestaurants(BuildContext context) {
  return WidgetConstants.warning(
      AppLocalizations.of(context)!.noRegisteredRestaurants);
}

restaurantSwiper(RestaurantMatchController controller) {
  AppinioSwiper(
    backgroundCardCount: 2,
    swipeOptions: const SwipeOptions.symmetric(horizontal: true),
    allowUnSwipe: false,
    controller: controller.swiperController,
    cardCount: controller.restaurantList.value!.length,
    onEnd: () => controller.finished.value = true,
    onSwipeEnd: (previousIndex, index, direction) async {
      if (index == 0) {
        return;
      }
      await controller.vote(controller.restaurantList.value![index - 1],
          direction, controller.restaurantList.value!.length == index);
    },
    cardBuilder: (BuildContext context, int index) {
      return restaurantCard(controller, index);
    },
  );
}

restaurantCard(RestaurantMatchController controller, int index) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: ColorsConstants.main,
    ),
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.memory(
                base64Decode(controller.restaurantList.value![index].image),
                gaplessPlayback: true,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(
                controller.restaurantList.value![index].title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
