
import 'package:flutter/material.dart';
import 'package:shop_admin/constants/assets.dart';
import 'package:shop_admin/widgets/subtitle_text.dart';
import 'package:shop_admin/widgets/title_text.dart';

class AppMethods {

    static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String subtitle,
    required Function fct,
    bool isError = true,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.imagesWarning,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SubTitleText(
                  label: subtitle,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SubTitleText(
                            label: "Cancel", color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        fct();
                        Navigator.pop(context);
                      },
                      child: const SubTitleText(
                          label: "OK", color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }




  static Future<void> imagePickerDialog(
      {required BuildContext context,
      required Function cameraFT,
      required Function galleryFT,
      required Function removeFT}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: TitleText(label: 'pick image'),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      cameraFT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    label: const Text('from camera'),
                    icon: const Icon(Icons.camera_alt),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      galleryFT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    label: const Text('from gallary'),
                    icon: const Icon(Icons.photo),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      removeFT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    label: const Text('remove picture'),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
