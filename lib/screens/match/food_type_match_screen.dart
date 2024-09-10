import 'dart:convert';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/match/controller/food_type_match_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodTypeMatchScreen extends StatefulWidget {
  const FoodTypeMatchScreen({super.key});

  @override
  State<FoodTypeMatchScreen> createState() => _FoodTypeMatchScreenState();
}

class _FoodTypeMatchScreenState extends State<FoodTypeMatchScreen> {
  WidgetConstants widgets = WidgetConstants();
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
        FoodTypeMatchController(context: context);
    return Scaffold(
      appBar: widgets.appBar(false, context),
      body: FutureBuilder(
          future: controller.getList(),
          builder: (context, list) {
            if (list.data != null && list.data!.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: finished
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .waitingPartnerVotes,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.deepPurple),
                              ),
                            )
                          : AppinioSwiper(
                              backgroundCardCount: 2,
                              swipeOptions: const SwipeOptions.symmetric(
                                  horizontal: true),
                              allowUnSwipe: false,
                              controller: swiperController,
                              cardCount: list.data!.length,
                              onEnd: () => setState(() {
                                finished = true;
                              }),
                              onSwipeEnd:
                                  (previousIndex, index, direction) async {
                                await controller.vote(list.data![index - 1],
                                    direction, list.data!.length == index);
                              },
                              cardBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.deepPurple,
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(20)),
                                          child: Image.memory(
                                            base64Decode(
                                                list.data![index].image),
                                            gaplessPlayback: true,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              list.data![index].title,
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
                                    color: Colors.white,
                                  )),
                              IconButton(
                                  iconSize: 50,
                                  onPressed: () =>
                                      swiperController.swipeRight(),
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.green)),
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        )
                ],
              );
            }
            return list.data == null
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
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
                            color: Colors.deepPurple),
                      ),
                    ),
                  );
          }),
    );
  }
}
