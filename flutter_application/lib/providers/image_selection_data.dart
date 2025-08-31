import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

class ImageSelectionData extends ChangeNotifier {
  String? selectedImageUrl;

  Future<void> pickImageWeb() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      selectedImageUrl = url;
      notifyListeners();
    }
  }
}
