import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/match/controller/restaurant_match_controller.dart';
import 'package:match_app/screens/match/widgets/restaurant_match_widgets.dart';

class RestaurantMatchScreen extends StatefulWidget {
  const RestaurantMatchScreen({super.key, required this.foodTypeId});

  final String foodTypeId;

  @override
  State<RestaurantMatchScreen> createState() => _RestaurantMatchScreenState();
}

class _RestaurantMatchScreenState extends State<RestaurantMatchScreen> {
  late RestaurantMatchController controller;
  @override
  void dispose() {
    controller.swiperController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = RestaurantMatchController(
        context: context, foodTypeId: widget.foodTypeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetConstants.appBar(false, context,
          onPressed: FunctionConstants.resetVotes),
      body: Obx(() {
        if (controller.checkList()) {
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: controller.finished.value
                        ? WidgetConstants.waitingVotes(context)
                        : restaurantSwiper(controller)),
              ),
              controller.finished.value
                  ? Expanded(child: Container())
                  : WidgetConstants.voteButtons(controller.swiperController)
            ],
          );
        }
        return controller.restaurantList.value == null
            ? WidgetConstants.loader()
            : noRegisteredRestaurants(context);
      }),
    );
  }
}
