import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/home/controller/home_controller.dart';
import 'package:match_app/screens/match/food_type_match_screen.dart';
import 'package:match_app/screens/register/register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;

  @override
  void initState() {
    controller = HomeController(context: context);
    FunctionConstants().resetVotes();
    super.initState();
  }

  WidgetConstants widgets = WidgetConstants();
  bool camera = false;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widgets.appBar(true, context),
      backgroundColor: Colors.deepPurpleAccent,
      body: FutureBuilder<bool>(
          future: controller.init(),
          builder: (context, snapshot) {
            return snapshot.data == false
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : ValueListenableBuilder<String?>(
                    valueListenable: controller.coupleId,
                    builder: (context, coupleId, _) {
                      return SizedBox(
                        width: screenSize.width,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widgets.button(
                                  Colors.deepPurple,
                                  0.5,
                                  () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const FoodTypeMatchScreen())),
                                  const Text(
                                    "Começar",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  context),
                              const Gap(20),
                              widgets.button(
                                  Colors.white,
                                  0.5,
                                  () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen())),
                                  const Text(
                                    "Cadastrar",
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  context),
                              const Gap(50),
                              TextButton(
                                  onPressed: () async {
                                    coupleId == null
                                        ? controller.addPartner()
                                        : controller.removePartner();
                                  },
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.white.withOpacity(0.1)),
                                  ),
                                  child: Text(
                                    coupleId == null
                                        ? "Adicionar Parceiro"
                                        : "Remover Parceiro",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white),
                                  ))
                            ]),
                      );
                    });
          }),
    );
  }
}
