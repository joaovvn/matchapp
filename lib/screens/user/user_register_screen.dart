import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetConstants.appBar(false, context),
        backgroundColor: ColorsConstants.mainAccent,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetConstants.textField(TextEditingController(),
                  AppLocalizations.of(context)!.name, context,
                  filled: true),
              const Gap(5),
              WidgetConstants.textField(TextEditingController(),
                  AppLocalizations.of(context)!.email, context,
                  filled: true),
              const Gap(5),
              WidgetConstants.textField(TextEditingController(),
                  AppLocalizations.of(context)!.password, context,
                  isPassword: true, filled: true),
              const Gap(5),
              WidgetConstants.button(
                  ColorsConstants.contrast,
                  0.5,
                  () {},
                  Text(
                    AppLocalizations.of(context)!.register,
                    style: const TextStyle(
                        color: ColorsConstants.main,
                        fontWeight: FontWeight.bold),
                  ),
                  context)
            ]));
  }
}
