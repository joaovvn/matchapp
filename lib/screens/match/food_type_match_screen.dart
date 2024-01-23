import 'dart:convert';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/match/controller/food_type_match_controller.dart';

class FoodTypeMatchScreen extends StatefulWidget {
  const FoodTypeMatchScreen({super.key});

  @override
  State<FoodTypeMatchScreen> createState() => _FoodTypeMatchScreenState();
}

class _FoodTypeMatchScreenState extends State<FoodTypeMatchScreen> {
  WidgetConstants widgets = WidgetConstants();
  FoodTypeMatchController controller = FoodTypeMatchController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.appBar(false, context),
      body: FutureBuilder(
          future: controller.getList(),
          builder: (context, list) {
            if (list.data != null) {
              return AppinioSwiper(
                swipeOptions:
                    const AppinioSwipeOptions.symmetric(horizontal: true),
                allowUnswipe: false,
                cardsCount: list.data!.length,
                onSwipe: (index, direction) async {
                  debugPrint(index.toString());
                  controller.vote(list.data![index - 1], "jvVote", direction);
                },
                cardsBuilder: (BuildContext context, int index) {
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
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            child: Image.memory(
                              base64Decode(list.data![index].image),
                              gaplessPlayback: true,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            list.data![index].title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 45),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          }),
    );
  }
}
