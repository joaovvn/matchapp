import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:match_app/constants/loading_state.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController extends GetxController {
  LoginController({required this.context});
  BuildContext context;
  RxBool isEnglish = (Get.locale == const Locale(ValueConstants.english)).obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Rx<LoadingState> loadingState = LoadingState.idle.obs;

  login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showWarning(AppLocalizations.of(context)!.fillFields);
      return;
    }
    try {
      loadingState.value = LoadingState.loading;
      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((_) async {
        loadingState.value = LoadingState.success;
        await Future.delayed(Durations.long1);
        Get.off(() => const HomeScreen());
        loadingState.value = LoadingState.idle;
      });
    } on FirebaseAuthException catch (e) {
      loadingState.value = LoadingState.error;
      await Future.delayed(Durations.long1);
      loadingState.value = LoadingState.idle;
      switch (e.code) {
        case 'invalid-email':
          showWarning(AppLocalizations.of(context)!.invalidEmail);
          break;
        case 'user-disabled':
          showWarning(AppLocalizations.of(context)!.userDisabled);
          break;
        case 'user-not-found':
          showWarning(AppLocalizations.of(context)!.userNotFound);
          break;
        case 'wrong-password':
          showWarning(AppLocalizations.of(context)!.wrongPassword);
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
        case 'invalid-credential':
          showWarning(AppLocalizations.of(context)!.invalidCredential);
          break;
        case 'operation-not-allowed':
          showWarning(AppLocalizations.of(context)!.operationNotAllowed);
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

  signInWithGoogle() async {
    try {
      loadingState.value = LoadingState.loading;
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        loadingState.value = LoadingState.idle;
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential).then((_) async {
        loadingState.value = LoadingState.success;
        await Future.delayed(Durations.long1);
        Get.off(() => const HomeScreen());
        loadingState.value = LoadingState.idle;
      });
    } on FirebaseAuthException catch (e) {
      loadingState.value = LoadingState.error;
      await Future.delayed(Durations.long1);
      loadingState.value = LoadingState.idle;
      switch (e.code) {
        case 'invalid-email':
          showWarning(AppLocalizations.of(context)!.invalidEmail);
          break;
        case 'user-disabled':
          showWarning(AppLocalizations.of(context)!.userDisabled);
          break;
        case 'user-not-found':
          showWarning(AppLocalizations.of(context)!.userNotFound);
          break;
        case 'wrong-password':
          showWarning(AppLocalizations.of(context)!.wrongPassword);
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
        case 'invalid-credential':
          showWarning(AppLocalizations.of(context)!.invalidCredential);
          break;
        case 'operation-not-allowed':
          showWarning(AppLocalizations.of(context)!.operationNotAllowed);
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

  showWarning(String? message) {
    WidgetConstants.showWarning(context, message ?? "");
  }
}
