import 'package:flutter/material.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/register/controller/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  WidgetConstants widgets = WidgetConstants();
  late RegisterController controller;

  @override
  void initState() {
    controller = RegisterController(context: context);
    super.initState();
  }

  bool finished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: widgets.appBar(false, context),
        body: FutureBuilder<bool>(
            future: controller.getFoodTypes(),
            builder: (context, snapshot) {
              return SafeArea(
                top: false,
                left: false,
                right: false,
                child: Column(
                  children: [
                    widgets.dropdown(
                        snapshot.data == true &&
                                controller.foodTypeItems.isNotEmpty
                            ? const [
                                DropdownMenuItem(
                                  value: "FoodType",
                                  child: Text(
                                    "Comida",
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Restaurant",
                                  child: Text(
                                    "Restaurante",
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                )
                              ]
                            : const [
                                DropdownMenuItem(
                                  value: "FoodType",
                                  child: Text(
                                    "Comida",
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                        "Tipo",
                        (option) => setState(() {
                              controller.option = option!;
                            }),
                        controller.option),
                    controller.option == "Restaurant"
                        ? widgets.dropdown(
                            controller.foodTypeItems, "Culinária", (option) {
                            controller.foodType = option;
                          }, controller.foodType)
                        : Container(),
                    widgets.textField(controller.titleController, "Título"),
                    widgets.imagePicker(controller.image, () async {
                      await controller.pickImage();
                      setState(() {});
                    }),
                    widgets.button(
                        Colors.deepPurple,
                        0.85,
                        () => controller.register(),
                        const Text("Cadastrar",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        context)
                  ],
                ),
              );
            }));
  }
}
