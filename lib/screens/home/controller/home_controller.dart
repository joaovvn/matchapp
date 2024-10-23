import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:match_app/constants/colors_constants.dart';
import 'package:match_app/constants/function_constants.dart';
import 'package:match_app/constants/value_constants.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/group.dart';
import 'package:match_app/models/member.dart';
import 'package:match_app/screens/user/login_screen.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeController extends GetxController {
  HomeController({required this.context});
  BuildContext context;
  final GetStorage _storage = GetStorage();
  RxString groupId = "".obs;
  RxBool isEnglish = (Get.locale == const Locale("en")).obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  StreamSubscription<DatabaseEvent>? _groupRemovedListener;
  StreamSubscription<DatabaseEvent>? _groupAddedListener;

  init() async {
    String? key;
    if (groupId.isEmpty) {
      await FirebaseDatabase.instance
          .ref(ValueConstants.groupMembers)
          .orderByChild(ValueConstants.userId)
          .equalTo(_auth.currentUser?.uid)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.exists) {
          key = Member.fromJson(Map<String, dynamic>.from(
                  event.snapshot.children.first.value as Map))
              .groupId;
        }
      });
    } else {
      key = FirebaseDatabase.instance
          .ref('${ValueConstants.groups}/${groupId.value}')
          .key;
    }
    if (key == null) {
      _storage.remove(ValueConstants.groupId);
      groupId.value = "";
    } else {
      _storage.write(ValueConstants.groupId, key!);
      groupId.value = key!;
      FunctionConstants.resetVotes();
      verifyRemovedGroup();
    }
  }

  showAddedGroup() {
    WidgetConstants.addedGroup(context);
  }

  showRemovedGroup() {
    WidgetConstants.removedGroup(context);
  }

  logOut() async {
    try {
      await _googleSignIn.disconnect();

      await _auth.signOut();

      Get.off(() => const LoginScreen());
    } catch (e) {
      showLogoutWarning();
    }
  }

  showLogoutWarning() {
    WidgetConstants.showWarning(
        context, AppLocalizations.of(context)!.errorLogout);
  }

  removeGroup() async {
    FirebaseDatabase.instance
        .ref(ValueConstants.groups)
        .orderByChild(ValueConstants.groupId)
        .equalTo(groupId.value)
        .once()
        .then((DatabaseEvent event) {
      event.snapshot.ref.remove();
      _storage.remove(ValueConstants.groupId);
      FirebaseDatabase.instance
          .ref(ValueConstants.groupMembers)
          .orderByChild(ValueConstants.groupId)
          .equalTo(groupId.value)
          .once()
          .then((DatabaseEvent event) {
        event.snapshot.ref.remove();
      });
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
    WidgetConstants.showWarning(context, content);
  }

  verifyRemovedGroup() async {
    _groupRemovedListener = FirebaseDatabase.instance
        .ref('${ValueConstants.groups}/${groupId.value}')
        .onChildRemoved
        .listen((DatabaseEvent event) {
      _storage.remove(ValueConstants.groupId);
      groupId.value = "";
      showRemovedGroup();
      _groupRemovedListener!.cancel();
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
            backgroundColor: ColorsConstants.mainAccent,
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
                            color: ColorsConstants.contrast,
                            size: 20,
                          )),
                    )
                  ],
                ),
                QrImageView(
                    size: MediaQuery.of(context).size.width * 0.4,
                    backgroundColor: ColorsConstants.contrast,
                    data: _auth.currentUser!.uid),
                const Gap(15),
                WidgetConstants.button(ColorsConstants.contrast, 0.4, () {
                  Get.back();
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: ColorsConstants.mainAccent,
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
                                        color: ColorsConstants.contrast,
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
                            color: ColorsConstants.main,
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
      ownerId: _auth.currentUser!.uid,
    );
    if (await FirebaseDatabase.instance
        .ref(ValueConstants.groups)
        .orderByChild(ValueConstants.ownerId)
        .equalTo(_auth.currentUser!.uid)
        .once()
        .then((value) {
      return value.snapshot.children.isEmpty ? true : false;
    })) {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child(ValueConstants.groups).push();
      await databaseReference.set(group.toJson()).then((_) {
        _storage.write(ValueConstants.groupId, databaseReference.key!);
        groupId.value = databaseReference.key!;
        Member owner =
            Member(groupId: groupId.value, userId: _auth.currentUser!.uid);
        Member member = Member(groupId: groupId.value, userId: capture.text);
        FirebaseDatabase.instance
            .ref()
            .child(ValueConstants.groupMembers)
            .push()
            .set(owner.toJson());
        FirebaseDatabase.instance
            .ref()
            .child(ValueConstants.groupMembers)
            .push()
            .set(member.toJson());
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
    verifyRemovedGroup();
  }

  verifyAddedGroup() {
    _groupAddedListener = FirebaseDatabase.instance
        .ref(ValueConstants.groupMembers)
        .orderByChild(ValueConstants.userId)
        .equalTo(_auth.currentUser!.uid)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Member member = Member.fromJson(Map<String, dynamic>.from(
            event.snapshot.children.first.value as Map));
        _storage.write(ValueConstants.groupId, member.groupId);
        groupId.value = member.groupId;
        onGroupAdded();
        _groupAddedListener!.cancel();
      }
    });
  }
}
