import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:match_app/constants/widget_constants.dart';
import 'package:match_app/models/couple.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  HomeController({required this.context});
  BuildContext context;
  late SharedPreferences preferences;
  WidgetConstants widgets = WidgetConstants();
  ValueNotifier<String?> coupleId = ValueNotifier(null);

  Future<bool> init() async {
    preferences = await SharedPreferences.getInstance();
    coupleId.value = preferences.getString("coupleId");
    DocumentSnapshot<Map<String, dynamic>> data;
    if (coupleId.value == null) {
      QuerySnapshot<Map<String, dynamic>> couple = await FirebaseFirestore
          .instance
          .collection("Couples")
          .where("firstId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      data = couple.docs[0];
      if (data.data() == null) {
        QuerySnapshot<Map<String, dynamic>> couple = await FirebaseFirestore
            .instance
            .collection("Couples")
            .where("secondId",
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .get();
        data = couple.docs[0];
      }
    } else {
      data = await FirebaseFirestore.instance
          .collection("Couples")
          .doc(coupleId.value)
          .get();
    }
    if (data.data() == null) {
      preferences.remove("coupleId");
      coupleId.value = null;
    } else {
      preferences.setString("coupleId", data.id);
      coupleId.value = data.id;
      verifyRemovedPartner();
    }
    return true;
  }

  showAddedPartner() {
    widgets.addedPartner(context);
    verifyRemovedPartner();
  }

  showRemovedPartner() {
    widgets.removedPartner(context);
  }

  removePartner() async {
    await FirebaseFirestore.instance
        .collection("Couples")
        .doc(coupleId.value)
        .delete();
    preferences.remove("coupleId");
    coupleId.value = null;
  }

  verifyRemovedPartner() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection("Couples")
        .doc(coupleId.value)
        .get();
    if (!data.exists) {
      preferences.remove("coupleId");
      coupleId.value = null;
      showRemovedPartner();
    } else {
      await verifyRemovedPartner();
    }
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
                    const Expanded(
                      flex: 7,
                      child: Text(
                        "Mostre o QR Code para seu parceiro ler",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            Navigator.of(context).pop();
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
                  Navigator.of(context).pop();
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
                                const Expanded(
                                  flex: 6,
                                  child: Text(
                                    "Leia o QR Code na tela do seu parceiro",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                      splashRadius: 20,
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
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
                              child: MobileScanner(
                                controller: MobileScannerController(
                                    detectionSpeed:
                                        DetectionSpeed.noDuplicates),
                                // scanWindow: Rect.zero,
                                fit: BoxFit.contain,
                                onDetect: (capture) async {
                                  await onQrFound(capture);
                                },
                              ),
                            ),
                            const Gap(20)
                          ]),
                    ),
                  );
                },
                    const Text("Ler QR Code",
                        style: TextStyle(
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

  onQrFound(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    Couple couple = Couple(
        id: "",
        firstId: FirebaseAuth.instance.currentUser!.uid,
        secondId: barcodes[0].rawValue!);
    DocumentReference<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('Couples')
        .add(couple.toJson());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("coupleId", data.id);
    coupleId.value = data.id;
    onPartnerAdded();
  }

  onPartnerAdded() {
    Navigator.of(context).pop();
    showAddedPartner();
  }

  verifyAddedPartner() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("Couples")
        .where("secondId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<Couple> couple =
        data.docs.map((doc) => Couple.fromJson(doc.data(), doc.id)).toList();
    if (couple.isNotEmpty) {
      preferences.setString("coupleId", couple[0].id);
      coupleId.value = couple[0].id;
      onPartnerAdded();
    } else {
      verifyAddedPartner();
    }
  }
}
