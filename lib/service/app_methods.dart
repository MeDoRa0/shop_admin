
import 'package:flutter/material.dart';
import 'package:shop_admin/widgets/title_text.dart';

class AppMethods {




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
