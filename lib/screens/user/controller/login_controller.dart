import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/screens/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController extends GetxController {
  LoginController({required this.context});
  BuildContext context;
  RxBool isEnglish = (Get.locale == const Locale("en")).obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  login() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((_) {
        Get.off(() => const HomeScreen());
      });
    } on FirebaseAuthException catch (e) {
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
          showWarning('Unknown error: ${e.code}');
      }
    } catch (e) {
      showWarning('Unexpected error. Please try again.');
    }
  }

  signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential).then((_) {
        Get.off(() => const HomeScreen());
      });
    } on FirebaseAuthException catch (e) {
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
          showWarning('Unknown error: ${e.code}');
      }
    } catch (e) {
      debugPrint(e.toString());
      showWarning('Unexpected error. Please try again.');
    }
  }

  showWarning(String? message) {
    WidgetConstants.showWarning(context, message ?? "");
  }
}
