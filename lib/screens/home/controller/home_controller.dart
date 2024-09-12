import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/couple.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeController extends GetxController {
  HomeController({required this.context});
  BuildContext context;
  late SharedPreferences preferences;
  WidgetConstants widgets = WidgetConstants();
  RxString coupleId = "".obs;
  RxBool isEnglish = (Get.locale == const Locale("en")).obs;

  Future<bool> init() async {
    String? key;
    preferences = await SharedPreferences.getInstance();
    if (coupleId.isEmpty) {
      await FirebaseDatabase.instance
          .ref(ValueConstants.couples)
          .orderByChild(ValueConstants.firstId)
          .equalTo(FirebaseAuth.instance.currentUser?.uid)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          key = event.snapshot.children.first.key;
        }
      });
      if (key == null) {
        FirebaseDatabase.instance
            .ref(ValueConstants.couples)
            .orderByChild(ValueConstants.secondId)
            .equalTo(FirebaseAuth.instance.currentUser?.uid)
            .once()
            .then((DatabaseEvent event) {
          if (event.snapshot.exists) {
            key = event.snapshot.children.first.key;
          }
        });
      }
    } else {
      key = FirebaseDatabase.instance
          .ref('${ValueConstants.couples}/${coupleId.value}')
          .key;
    }
    if (key == null) {
      preferences.remove(ValueConstants.coupleId);
      coupleId.value = "";
    } else {
      preferences.setString(ValueConstants.coupleId, key!);
      coupleId.value = key!;
      FunctionConstants.resetVotes();
      verifyRemovedPartner();
    }
    return true;
  }

  showAddedPartner() {
    widgets.addedPartner(context);
  }

  showRemovedPartner() {
    widgets.removedPartner(context);
  }

  removePartner() async {
    FirebaseDatabase.instance
        .ref('${ValueConstants.couples}/${coupleId.value}')
        .remove()
        .then((_) {
      preferences.remove(ValueConstants.coupleId);
      coupleId.value = "";
    }).catchError((_) {
      showWarning(ValueConstants.removePartnerError);
    });
  }

  showWarning(int type) {
    String content = "";
    if (type == ValueConstants.removePartnerError) {
      content = AppLocalizations.of(context)!.errorRemovingPartner;
    }
    if (type == ValueConstants.connectPartnerError) {
      content = AppLocalizations.of(context)!.errorConnectingPartner;
    }
    widgets.showWarning(context, content);
  }

  verifyRemovedPartner() async {
    FirebaseDatabase.instance
        .ref('${ValueConstants.couples}/${coupleId.value}')
        .onValue
        .listen((DatabaseEvent event) {
      if (!event.snapshot.exists) {
        preferences.remove(ValueConstants.coupleId);
        coupleId.value = "";
        showRemovedPartner();
      }
    });
  }

  addPartner() {
    verifyAddedPartner();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.deepPurpleAccent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Expanded(
                      flex: 7,
                      child: Text(
                        AppLocalizations.of(context)!.showQR,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          )),
                    )
                  ],
                ),
                QrImageView(
                    size: MediaQuery.of(context).size.width * 0.4,
                    backgroundColor: Colors.white,
                    data: FirebaseAuth.instance.currentUser!.uid),
                const Gap(15),
                widgets.button(Colors.white, 0.4, () {
                  Get.back();
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Expanded(child: SizedBox()),
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    AppLocalizations.of(context)!.readPartnerQR,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                      splashRadius: 20,
                                      onPressed: () => Get.back(),
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: QRCodeDartScanView(
                                onCapture: (capture) async {
                                  await onQrFound(capture);
                                },
                              ),
                            ),
                            const Gap(20)
                          ]),
                    ),
                  );
                },
                    Text(AppLocalizations.of(context)!.readQR,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold)),
                    context),
                const Gap(20)
              ],
            ),
          );
        });
  }

  onQrFound(Result capture) async {
    Couple couple = Couple(
        id: "",
        firstId: FirebaseAuth.instance.currentUser!.uid,
        secondId: capture.text);
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(ValueConstants.couples).push();

    await databaseReference.set(couple.toJson()).then((_) {
      preferences.setString(ValueConstants.coupleId, databaseReference.key!);
      coupleId.value = databaseReference.key!;
      onPartnerAdded();
    }).catchError((e) {
      showWarning(ValueConstants.connectPartnerError);
    });
  }

  onPartnerAdded() {
    Get.back();
    showAddedPartner();
  }

  verifyAddedPartner() {
    FirebaseDatabase.instance
        .ref(ValueConstants.couples)
        .orderByChild(ValueConstants.secondId)
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        preferences.setString(
            ValueConstants.coupleId, event.snapshot.children.first.key!);
        coupleId.value = event.snapshot.children.first.key!;
        onPartnerAdded();
      }
    });
  }
}
