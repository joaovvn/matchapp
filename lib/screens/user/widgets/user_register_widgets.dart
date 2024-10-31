import 'package:flutter/material.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:match_app/screens/user/controller/user_register_controller.dart';

Widget userNameTextField(
    TextEditingController usernameController, BuildContext context) {
  return WidgetConstants.textField(
      usernameController, AppLocalizations.of(context)!.name, context,
      filled: true);
}

Widget emailTextField(
    TextEditingController emailController, BuildContext context) {
  return WidgetConstants.textField(
      emailController, AppLocalizations.of(context)!.email, context,
      filled: true);
}

Widget passwordTextField(
  TextEditingController passwordController,
  BuildContext context,
  Function onChanged,
) {
  return WidgetConstants.textField(passwordController,
      AppLocalizations.of(context)!.confirmPassword, context,
      isPassword: true, filled: true, onChanged: onChanged);
}

Widget confirmPasswordTextField(TextEditingController confirmPasswordController,
    BuildContext context, Function onChanged, Icon icon) {
  return WidgetConstants.textField(confirmPasswordController,
      AppLocalizations.of(context)!.confirmPassword, context,
      isPassword: true, filled: true, onChanged: onChanged, suffixIcon: icon);
}

Widget registerUserButton(
    UserRegisterController controller, BuildContext context) {
  return WidgetConstants.button(ColorsConstants.contrast, 0.5, () async {
    controller.registerUser();
  },
      Text(
        AppLocalizations.of(context)!.register,
        style: const TextStyle(
            color: ColorsConstants.main, fontWeight: FontWeight.bold),
      ),
      context);
}
