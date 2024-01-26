import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_images.dart';

class CommonWidgets {
  // region ConfirmationBox
  static void confirmationBox(BuildContext context, String title, String msg, submit, cancel, {String submitBtn = "YES", String cancelBtn = "NO"}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Column(children: [
                SvgPicture.asset(AppImages.infoIcon),
                const SizedBox(height: 16),
                Text(title, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                const SizedBox(height: 20.0),
                Text(msg, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black), textAlign: TextAlign.center),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: cancel,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.grey, width: 1))),
                            child: Text(cancelBtn, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                          )),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                onPressed: submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                ),
                                child: Text(submitBtn, style: const TextStyle(color: Colors.white))))),
                  ],
                ),
              ]),
            ));
  }

// endregion
}
