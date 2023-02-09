// ignore_for_file: file_names
import 'package:aamusted_timetable_generator/Components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Styles/colors.dart';

class CustomDialog {
  static void showLoading({required String message}) {
    SmartDialog.showLoading(
      msg: message,
    );
  }

  static void dismiss() {
    SmartDialog.dismiss();
  }

  static void showToast({required String message}) {
    SmartDialog.showToast(
      message,
    );
  }

  static void showError({required String message}) {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: 450,
          height: 250,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Okay',
                      onPressed: () => SmartDialog.dismiss(),
                      color: primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSuccess({required String message}) {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: 450,
          height: 250,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  message,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Okay',
                      onPressed: () => SmartDialog.dismiss(),
                      color: primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showInfo(
      {required String message,
      VoidCallback? onPressed,
      required String buttonText,
      String? buttonText2,
      VoidCallback? onPressed2}) async {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: 400,
          height: 230,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, -40),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.info,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Text(
                  message,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: buttonText,
                    onPressed: onPressed!,
                    color: secondaryColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                    text: buttonText2 ?? 'Cancel',
                    onPressed: () {
                      if (onPressed2 != null) {
                        onPressed2.call();
                      } else {
                        SmartDialog.dismiss();
                      }
                    },
                    color: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showCustom(
      {required Widget ui, SmartDialogController? controller}) async {
    SmartDialog.show(
      controller: controller,
      maskColor: Colors.transparent,
      builder: (_) {
        return ui;
      },
    );
  }

  static Future<void> showImageDialog({String? path}) async {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (_) {
        return Card(
          elevation: 10,
          child: Container(
              width: 500,
              height: 500,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(path!), fit: BoxFit.fill)),
              child: Transform.translate(
                offset: const Offset(30, -30),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    color: Colors.white,
                    highlightColor: Colors.white,
                    padding: EdgeInsets.zero,
                    icon: const CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 40,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    onPressed: () {
                      CustomDialog.dismiss();
                    },
                  ),
                ),
              )),
        );
      },
    );
  }
}
