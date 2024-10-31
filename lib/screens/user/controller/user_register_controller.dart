import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/loading_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/user/login_screen.dart';

class UserRegisterController extends GetxController {
  UserRegisterController({required this.context});
  BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<LoadingState> loadingState = LoadingState.idle.obs;
  Rx<Icon> icon = const Icon(
    Icons.circle,
    size: 0,
  ).obs;

  onChanged() {
    if (passwordController.text.isEmpty) {
      icon.value = const Icon(Icons.circle, size: 0);
      return;
    }
    if (passwordController.text == confirmPasswordController.text) {
      icon.value = const Icon(
        Icons.check,
        color: ColorsConstants.green,
      );
      return;
    }
    icon.value = const Icon(
      Icons.close,
      color: ColorsConstants.red,
    );
  }

  registerUser() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        usernameController.text.isEmpty) {
      showWarning(AppLocalizations.of(context)!.fillFields);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showWarning(AppLocalizations.of(context)!.passwordsNotMatching);
      return;
    }
    try {
      loadingState.value = LoadingState.loading;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      await _auth
          .setLanguageCode(Get.locale?.languageCode ?? ValueConstants.english);
      await credential.user?.updateDisplayName(usernameController.text);
      await credential.user?.sendEmailVerification();
      loadingState.value = LoadingState.success;
      if (context.mounted) {
        showWarning(AppLocalizations.of(context)!.userRegistrationSuccess);
      }
      await Future.delayed(Durations.extralong2);
      Get.off(() => const LoginScreen());
      loadingState.value = LoadingState.idle;
    } on FirebaseAuthException catch (e) {
      loadingState.value = LoadingState.error;
      await Future.delayed(Durations.long1);
      loadingState.value = LoadingState.idle;
      switch (e.code) {
        case 'email-already-in-use':
          showWarning(AppLocalizations.of(context)!.emailAlreadyInUse);
          break;
        case 'invalid-email':
          showWarning(AppLocalizations.of(context)!.invalidEmail);
          break;
        case 'operation-not-allowed':
          showWarning(AppLocalizations.of(context)!.operationNotAllowed);
          break;
        case 'weak-password':
          showWarning(AppLocalizations.of(context)!.weakPassword);
          break;
        case 'too-many-requests':
          showWarning(AppLocalizations.of(context)!.tooManyRequests);
          break;
        case 'user-token-expired':
          showWarning(AppLocalizations.of(context)!.userTokenExpired);
          break;
        case 'network-request-failed':
          showWarning(AppLocalizations.of(context)!.networkRequestFailed);
          break;
        default:
          showWarning(
              '${AppLocalizations.of(context)!.unknownError} ${e.code}');
      }
    } catch (e) {
      loadingState.value = LoadingState.error;
      await Future.delayed(Durations.long1);
      loadingState.value = LoadingState.idle;
      unexpectedErrorWarning();
    }
  }

  unexpectedErrorWarning() {
    showWarning(AppLocalizations.of(context)!.unexpectedError);
  }

  showWarning(String? message) {
    WidgetConstants.showWarning(context, message ?? "");
  }
}
