import 'package:flutter/foundation.dart';

class PickedFile {
  Uint8List bytes;
  String name;
  String ext;
  PickedFile({
    required this.bytes,
    required this.name,
    required this.ext,
  });
}
