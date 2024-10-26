import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/match/controller/food_type_match_controller.dart';
import 'package:match_app/screens/match/widgets/food_type_match_widgets.dart';

class FoodTypeMatchScreen extends StatefulWidget {
  const FoodTypeMatchScreen({super.key});

  @override
  State<FoodTypeMatchScreen> createState() => _FoodTypeMatchScreenState();
}

class _FoodTypeMatchScreenState extends State<FoodTypeMatchScreen> {
  late FoodTypeMatchController controller;
  @override
  void dispose() {
    controller.swiperController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = Get.put(FoodTypeMatchController(context: context));
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetConstants.appBar(false, context),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Obx(() {
          if (controller.checkList()) {
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: controller.finished.value
                          ? WidgetConstants.waitingVotes(context)
                          : foodSwiper(controller)),
                ),
                controller.finished.value
                    ? Expanded(child: Container())
                    : WidgetConstants.voteButtons(controller.swiperController)
              ],
            );
          }
          return controller.foodTypeList.value == null
              ? WidgetConstants.loader()
              : noRegisteredFoods(context);
        }),
      ),
    );
  }
}
