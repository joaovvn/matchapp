import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/home/controller/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:match_app/screens/match/food_type_match_screen.dart';
import 'package:match_app/screens/register/register_screen.dart';

groupButton(HomeController controller, BuildContext context) {
  return TextButton(
    onPressed: () async {
      controller.groupId.value.isEmpty
          ? controller.addGroup()
          : controller.removeGroup();
    },
    style: ButtonStyle(
      overlayColor: WidgetStateColor.resolveWith(
          (states) => ColorsConstants.contrast.withOpacity(0.1)),
    ),
    child: Obx(
      () {
        return Text(
          controller.groupId.value.isEmpty
              ? AppLocalizations.of(context)!.addGroup
              : AppLocalizations.of(context)!.removeGroup,
          style: const TextStyle(
              fontSize: 12,
              color: ColorsConstants.contrast,
              decoration: TextDecoration.underline,
              decorationColor: ColorsConstants.contrast),
        );
      },
    ),
  );
}

registerButton(BuildContext context) {
  return WidgetConstants.button(
      ColorsConstants.contrast,
      0.5,
      () => Get.to(() => const RegisterScreen()),
      Text(
        AppLocalizations.of(context)!.register,
        style: const TextStyle(
            color: ColorsConstants.main, fontWeight: FontWeight.bold),
      ),
      context);
}

startButton(BuildContext context) {
  return WidgetConstants.button(ColorsConstants.main, 0.5, () {
    FunctionConstants.resetVotes();
    Get.to(() => const FoodTypeMatchScreen());
  },
      Text(
        AppLocalizations.of(context)!.start,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: ColorsConstants.contrast),
      ),
      context);
}
