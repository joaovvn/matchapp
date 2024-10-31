import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/image_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/user/controller/login_controller.dart';
import 'package:match_app/screens/user/user_register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget logo() {
  return Expanded(
    flex: 2,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(
          ImageConstants.logo,
        ),
      ],
    ),
  );
}

Widget body(LoginController controller, BuildContext context) {
  return Expanded(
    flex: 3,
    child: Obx(() {
      return WidgetConstants.loadingStateWidget(
        controller.loadingState.value,
        Column(
          children: [
            signInWithGoogleButton(controller, context),
            const Gap(10),
            orDivider(context),
            const Gap(5),
            WidgetConstants.textField(controller.emailController,
                AppLocalizations.of(context)!.email, context),
            const Gap(5),
            WidgetConstants.textField(controller.passwordController,
                AppLocalizations.of(context)!.password, context,
                isPassword: true, onSubmitted: () => controller.login()),
            const Gap(5),
            WidgetConstants.button(ColorsConstants.mainAccent, 0.8, () {
              controller.login();
            },
                Text(
                  AppLocalizations.of(context)!.login,
                  style: const TextStyle(color: ColorsConstants.contrast),
                ),
                context),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.noAccount,
                  style: const TextStyle(
                      color: ColorsConstants.grey, fontWeight: FontWeight.w600),
                ),
                WidgetConstants.textButton(() {
                  Get.to(() => const UserRegisterScreen());
                },
                    Text(
                      AppLocalizations.of(context)!.register,
                      style: const TextStyle(color: ColorsConstants.mainAccent),
                    )),
              ],
            ),
          ],
        ),
      );
    }),
  );
}

Widget signInWithGoogleButton(
    LoginController controller, BuildContext context) {
  return WidgetConstants.button(
      ColorsConstants.contrast,
      borderColor: ColorsConstants.main,
      0.8, () async {
    await controller.signInWithGoogle();
  },
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageConstants.google),
          const Gap(15),
          Text(
            AppLocalizations.of(context)!.signinWithGoogle,
            style: const TextStyle(
                color: ColorsConstants.main, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      context);
}

Widget orDivider(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    child: Row(
      children: [
        const Expanded(
          flex: 3,
          child: Divider(
            height: 2,
            color: ColorsConstants.mainAccent,
          ),
        ),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.or,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: ColorsConstants.main, fontWeight: FontWeight.w700),
          ),
        ),
        const Expanded(
          flex: 3,
          child: Divider(
            height: 2,
            color: ColorsConstants.mainAccent,
          ),
        ),
      ],
    ),
  );
}
