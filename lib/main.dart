import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/screens/home/home_screen.dart';
import 'package:match_app/screens/user/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage().initStorage;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetStorage storage = GetStorage();
  String? language = storage.read('locale');
  if (language == null) {
    storage.write('locale', 'en');
    language = 'en';
  }
  await Get.updateLocale(Locale(language));
  runApp(const FoodMatch());
}

class FoodMatch extends StatelessWidget {
  const FoodMatch({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: ColorsConstants.contrast,
              displayColor: ColorsConstants.contrast,
              fontFamily: 'Kodchasan')),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }
}
