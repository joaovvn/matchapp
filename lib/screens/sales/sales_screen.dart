import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/menu_item.dart';
import 'package:match_app/models/restaurant.dart';
import 'package:match_app/screens/sales/controller/sales_controller.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  WidgetConstants widgets = WidgetConstants();

  @override
  Widget build(BuildContext context) {
    SalesController controller = Get.put(SalesController());
    controller.init(restaurant: widget.restaurant, context: context);
    return Scaffold(
        appBar: widgets.appBar(false, context, onPressed: () {
          FunctionConstants().resetVotes;
        }),
        floatingActionButton:
            shoppingCartFloatingActionButton(context, controller),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              child: Image.memory(
                base64Decode(widget.restaurant.image),
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Obx(() {
                List<MenuItem> menu = controller.menu;
                return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        thickness: 1,
                        color: Colors.deepPurple,
                      );
                    },
                    itemCount: menu.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      RxInt quantity = 1.obs;
                      return Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu[index].itemName,
                                  style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Gap(5),
                                Text(
                                  menu[index].description,
                                  style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Gap(10),
                                Text(
                                  "R\$ ${menu[index].price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                itemQuantity(quantity),
                                IconButton(
                                    onPressed: () {
                                      controller.addItemToCart(
                                          menu[index], quantity);
                                      quantity.value = 1;
                                    },
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.deepPurple,
                                    )),
                              ],
                            ),
                          )
                        ],
                      );
                    });
              }),
            )
          ],
        ));
  }

  Widget shoppingCartFloatingActionButton(
      BuildContext context, SalesController controller) {
    return FloatingActionButton(
      onPressed: () {
        bottomSheetShoppingCart(context, controller);
      },
      shape: const CircleBorder(),
      backgroundColor: Colors.deepPurple,
      child: const Icon(
        Icons.shopping_cart_checkout_outlined,
        color: Colors.white,
      ),
    );
  }

  void bottomSheetShoppingCart(
      BuildContext context, SalesController controller) {
    showModalBottomSheet(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) {
          return Obx(() {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 10.0),
                  child: controller.shoppingCart.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Text(
                              "Não há produtos no carrinho!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.deepPurple),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: ListView.separated(
                                  itemCount: controller.shoppingCart.length,
                                  shrinkWrap: true,
                                  separatorBuilder: (_, index) {
                                    return const Divider(
                                      thickness: 1,
                                      color: Colors.deepPurple,
                                    );
                                  },
                                  itemBuilder: (_, index) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.shoppingCart[index]
                                                    .itemName,
                                                style: const TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Gap(5),
                                              Text(
                                                controller.shoppingCart[index]
                                                    .description,
                                                style: const TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Gap(10),
                                              Text(
                                                "R\$ ${controller.shoppingCart[index].price.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "${controller.shoppingCart[index].quantity} un.",
                                                style: const TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    controller
                                                        .removeItemFromCart(
                                                            index);
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .remove_shopping_cart_outlined,
                                                    color: Colors.deepPurple,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                            const Divider(
                              thickness: 2,
                              color: Colors.deepPurple,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Itens",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${controller.getTotalItems()} un.",
                                        style: const TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Total",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "R\$ ${controller.getTotalPrice()}",
                                        style: const TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  const Gap(5),
                                  widgets.button(
                                      Colors.deepPurple,
                                      0.3,
                                      () {},
                                      const Text(
                                        "Finalizar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      context)
                                ],
                              ),
                            )
                          ],
                        ),
                ),
              ),
            );
          });
        });
  }

  Widget itemQuantity(RxInt value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _decrementButton(value),
        Obx(() => Text(
              value.toString(),
              style: const TextStyle(fontSize: 14.0, color: Colors.deepPurple),
            )),
        _incrementButton(value),
      ],
    );
  }

  Widget _incrementButton(RxInt value) {
    return IconButton(
      color: Colors.white,
      onPressed: () {
        value++;
      },
      icon: const Icon(Icons.add, color: Colors.deepPurple),
    );
  }

  Widget _decrementButton(RxInt value) {
    return IconButton(
        onPressed: () {
          value = value--;
        },
        color: Colors.white,
        icon: const Icon(Icons.remove, color: Colors.deepPurple));
  }
}
