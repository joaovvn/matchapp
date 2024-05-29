import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/image_constants.dart';
import 'package:match_app/models/food_type.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:match_app/screens/match/restaurant_match_screen.dart';
import 'package:match_app/screens/sales/sales_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetConstants {
  FunctionConstants functions = FunctionConstants();
  Widget button(Color color, double width, Function()? onPressed, Widget child,
      BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width * width, 48)),
            backgroundColor: WidgetStatePropertyAll(color),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ))),
        onPressed: onPressed,
        child: child);
  }

  AppBar appBar(bool isHome, BuildContext context, {Function? onPressed}) {
    ImageConstants images = ImageConstants();
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Image.asset(
        images.logo,
      ),
      leading: isHome
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                Get.until((route) => route.isFirst);
              },
            ),
    );
  }

  showWarning(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 1, milliseconds: 500),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ));
  }

  registerDialog(BuildContext context) {
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
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Registrado com sucesso!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.deepPurple,
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
                  child: button(Colors.deepPurple, 0.9, () {
                    Get.until((route) => route.isFirst);
                  },
                      const Text("OK",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      context),
                )
              ]),
        ),
      ),
    );
  }

  restaurantMatchDialog(
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
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "MATCH!!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.deepPurple,
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
                                    color: Colors.deepPurple,
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
                              child: button(Colors.deepPurple, 0.9, () async {
                                Get.back();
                                Get.off(() => SalesScreen(
                                      restaurant: restaurant,
                                    ));
                              },
                                  const Text("Fazer Pedido",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  context),
                            )
                          : const Gap(20),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                            bottom: 20.0),
                        child: button(Colors.deepPurple, 0.9, () async {
                          await launchUrl(Uri.parse(
                              "https://maps.google.com/?q=${restaurant.title}"));
                        },
                            const Text("Buscar Localização",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.width * 0.05,
                            right: screenSize.width * 0.05,
                            bottom: 20.0),
                        child: button(Colors.deepPurple, 0.9, () {
                          Get.until((route) => route.isFirst);
                          functions.resetVotes();
                        },
                            const Text("OK",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
              ),
            ));
  }

  foodMatchDialog(BuildContext context, FoodType foodType) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              backgroundColor: Colors.white,
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
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "MATCH!!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                              child: Text(
                                "Agora vamos para a escolha dos restaurantes!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.deepPurple,
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
                                    color: Colors.deepPurple,
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
                        child: button(Colors.deepPurple, 0.9, () {
                          Get.back();
                          Get.off(() => RestaurantMatchScreen(
                                foodTypeId: foodType.id,
                              ));
                        },
                            const Text("Continuar",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
              ),
            ));
  }

  noPartnerDialog(BuildContext context) {
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Você ainda não possui um parceiro adicionado. Adicione um e tente novamente!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(Colors.deepPurple, 0.9, () {
                          Get.until((route) => route.isFirst);
                        },
                            const Text("Voltar para a página inicial",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }

  noMatchDialog(BuildContext context) {
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "NENHUM MATCH!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(Colors.deepPurple, 0.9, () {
                          functions.resetVotes();
                          Get.until((route) => route.isFirst);
                        },
                            const Text("Voltar para a página inicial",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }

  Widget dropdown(List<DropdownMenuItem> items, String title,
      Function(dynamic)? onChanged, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w600),
            ),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.deepPurple)),
            ),
            items: items,
            onChanged: onChanged,
            value: value,
          ),
        ],
      ),
    );
  }

  Widget imagePicker(Uint8List? image, Function() onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "Imagem",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              image == null ? Colors.grey : Colors.deepPurple,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                    child: image == null
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

  Widget textField(TextEditingController controller, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w600),
            ),
          ),
          TextField(
            style: const TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.w600),
            controller: controller,
            cursorColor: Colors.deepPurple,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  addedPartner(BuildContext context) {
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Parceiro adicionado!! Agora é só aproveitar.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(Colors.deepPurple, 0.9, () {
                          Get.back();
                        },
                            const Text("OK",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }

  removedPartner(BuildContext context) {
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Parceiro removido!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05,
                            vertical: 20.0),
                        child: button(Colors.deepPurple, 0.9, () {
                          Get.back();
                        },
                            const Text("OK",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            context),
                      )
                    ]),
                  ),
                ],
              ),
            )));
  }
}
