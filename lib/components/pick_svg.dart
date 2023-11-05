import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;

pickSvg({required bool allowMultiple}) async {
  Uint8List bytes = Uint8List(0);
  List<String> listaBase64 = [];

  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.image, allowMultiple: allowMultiple);

  if (result != null) {
    List<io.File> files =
        result.paths.map((path) => io.File(path ?? '')).toList();

    if (allowMultiple) {
      files.forEach((element) {
        bytes = io.File(element.path).readAsBytesSync();
        listaBase64.add(base64Encode(bytes));
      });
      return listaBase64;
    } else {
      bytes = io.File(files[0].path).readAsBytesSync();

      return base64Encode(bytes);
    }
  }
}
