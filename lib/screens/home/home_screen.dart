import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/couple.dart';
import 'package:match_app/screens/match/food_type_match_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WidgetConstants widgets = WidgetConstants();
  bool camera = false;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widgets.appBar(true, context),
      backgroundColor: Colors.deepPurpleAccent,
      body: SizedBox(
        width: screenSize.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widgets.button(
                  Colors.deepPurple,
                  0.5,
                  () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FoodTypeMatchScreen())),
                  const Text(
                    "Começar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  context),
              const Gap(20),
              widgets.button(
                  Colors.white,
                  0.5,
                  () => null,
                  const Text(
                    "Cadastrar",
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  context),
              const Gap(50),
              TextButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(child: SizedBox()),
                                    const Expanded(
                                      flex: 7,
                                      child: Text(
                                        "Mostre o QR Code para seu parceiro ler",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                          splashRadius: 20,
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                    )
                                  ],
                                ),
                                QrImageView(
                                    size:
                                        MediaQuery.of(context).size.width * 0.4,
                                    backgroundColor: Colors.white,
                                    data:
                                        FirebaseAuth.instance.currentUser!.uid),
                                const Gap(15),
                                widgets.button(Colors.white, 0.4, () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: Colors.deepPurpleAccent,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                const Expanded(
                                                    child: SizedBox()),
                                                const Expanded(
                                                  flex: 6,
                                                  child: Text(
                                                    "Leia o QR Code na tela do seu parceiro",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: IconButton(
                                                      splashRadius: 20,
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 20,
                                                      )),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              child: MobileScanner(
                                                scanWindow: Rect.zero,
                                                fit: BoxFit.contain,
                                                onDetect: (capture) async {
                                                  final List<Barcode> barcodes =
                                                      capture.barcodes;
                                                  Couple couple = Couple(
                                                      firstId: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                      secondId: barcodes[0]
                                                          .rawValue!);
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Couples')
                                                      .add(couple.toJson());
                                                },
                                              ),
                                            ),
                                            const Gap(20)
                                          ]),
                                    ),
                                  );
                                },
                                    const Text("Ler QR Code",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold)),
                                    context),
                                const Gap(20)
                              ],
                            ),
                          );
                        });
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white.withOpacity(0.1)),
                  ),
                  child: const Text(
                    "Adicionar Parceiro",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                  ))
            ]),
      ),
    );
  }
}
