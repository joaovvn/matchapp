import 'package:flutter/material.dart';
import 'package:match_app/constants/image_constants.dart';

class WidgetConstants {
  Widget button(Color color, double width, Function()? onPressed, Widget child,
      BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStatePropertyAll(
                Size(MediaQuery.of(context).size.width * width, 48)),
            backgroundColor: MaterialStatePropertyAll(color),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ))),
        onPressed: onPressed,
        child: child);
  }

  AppBar appBar(bool isHome, BuildContext context) {
    ImageConstants images = ImageConstants();
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Image.asset(
        images.logo,
      ),
      leading: isHome
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.deepPurple,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
    );
  }

  personSelectDialog(
      BuildContext context,
      String contentText,
      Widget buttonContent,
      Function()? buttonFunction,
      Color textColor,
      Color buttonColor) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              content: Container(
                height: screenSize.height * 0.12,
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.05),
                        child: Text(
                          contentText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      button(buttonColor, 0.9, buttonFunction, buttonContent,
                          context)
                    ]),
              ),
            ));
  }
}
