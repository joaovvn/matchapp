import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/group.dart';
import 'package:match_app/models/member.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeController extends GetxController {
  HomeController({required this.context});
  BuildContext context;
  late SharedPreferences preferences;
  WidgetConstants widgets = WidgetConstants();
  RxString groupId = "".obs;
  RxBool isEnglish = (Get.locale == const Locale("en")).obs;

  init() async {
    String? key;
    preferences = await SharedPreferences.getInstance();
    String? language = preferences.getString('locale');
    if (language == null) {
      preferences.setString('locale', 'en');
      language = 'en';
    } else if (language == 'en') {
      isEnglish.value = true;
    }
    Get.updateLocale(Locale(language));
    if (groupId.isEmpty) {
      await FirebaseDatabase.instance
          .ref(ValueConstants.groupMembers)
          .orderByChild(ValueConstants.userId)
          .equalTo(FirebaseAuth.instance.currentUser?.uid)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          key = event.snapshot.children.first.key;
        }
      });
    } else {
      key = FirebaseDatabase.instance
          .ref('${ValueConstants.groups}/${groupId.value}')
          .key;
    }
    if (key == null) {
      preferences.remove(ValueConstants.groupId);
      groupId.value = "";
    } else {
      preferences.setString(ValueConstants.groupId, key!);
      groupId.value = key!;
      FunctionConstants.resetVotes();
      verifyRemovedGroup();
    }
  }

  showAddedGroup() {
    widgets.addedGroup(context);
  }

  showRemovedGroup() {
    widgets.removedGroup(context);
  }

  removeGroup() async {
    FirebaseDatabase.instance
        .ref('${ValueConstants.groups}/${groupId.value}')
        .remove()
        .then((_) {
      preferences.remove(ValueConstants.groupId);
      groupId.value = "";
    }).catchError((_) {
      showWarning(ValueConstants.removeGroupError);
    });
  }

  showWarning(int type) {
    String content = "";
    if (type == ValueConstants.removeGroupError) {
      content = AppLocalizations.of(context)!.errorRemovingGroup;
    }
    if (type == ValueConstants.connectGroupError) {
      content = AppLocalizations.of(context)!.errorConnectingGroup;
    }
    widgets.showWarning(context, content);
  }

  verifyRemovedGroup() async {
    FirebaseDatabase.instance
        .ref('${ValueConstants.groups}/${groupId.value}')
        .onValue
        .listen((DatabaseEvent event) {
      if (!event.snapshot.exists) {
        preferences.remove(ValueConstants.groupId);
        groupId.value = "";
        showRemovedGroup();
      }
    });
  }

  addGroup() {
    verifyAddedGroup();
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
                                    AppLocalizations.of(context)!.readGroupQR,
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
    Group group = Group(
      id: "",
      ownerId: FirebaseAuth.instance.currentUser!.uid,
    );
    if (await FirebaseDatabase.instance
        .ref(ValueConstants.groups)
        .orderByChild(ValueConstants.ownerId)
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((value) {
      return value.snapshot.children.isEmpty ? true : false;
    })) {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child(ValueConstants.groups).push();
      await databaseReference.set(group.toJson()).then((_) {
        preferences.setString(ValueConstants.groupId, databaseReference.key!);
        groupId.value = databaseReference.key!;
        Member owner = Member(
            groupId: groupId.value,
            userId: FirebaseAuth.instance.currentUser!.uid);
        Member member = Member(groupId: groupId.value, userId: capture.text);
        FirebaseDatabase.instance.ref(ValueConstants.groupMembers).set(owner);
        FirebaseDatabase.instance.ref(ValueConstants.groupMembers).set(member);
        onGroupAdded();
      }).catchError((e) {
        showWarning(ValueConstants.connectGroupError);
      });
      return;
    }
  }

  onGroupAdded() {
    Get.back();
    showAddedGroup();
  }

  verifyAddedGroup() {
    FirebaseDatabase.instance
        .ref(ValueConstants.groupMembers)
        .orderByChild(ValueConstants.userId)
        .equalTo(FirebaseAuth.instance.currentUser!.uid)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Member member = Member.fromJson(Map<String, dynamic>.from(
            event.snapshot.children.first.value as Map));
        preferences.setString(ValueConstants.groupId, member.groupId);
        groupId.value = member.groupId;
        onGroupAdded();
      }
    });
  }
}
