import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;

pickSvg() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result != null) {
    List<io.File> files =
        result.paths.map((path) => io.File(path ?? '')).toList();
    final bytes = io.File(files[0].path).readAsBytesSync();

    return base64Encode(bytes);
  }
}
