import 'package:flutter/foundation.dart';

class ImageData {
  String name;
  Uint8List? thumbnail;
  Uint8List? full;
  List<Function(void)> listeners = [];

  ImageData(this.name);

  void addListener(Function(void) listener) {
    listeners.add(listener);
  }

  void removeListener(Function(void) listener) {
    listeners.remove(listener);
  }

  bool hasThumbnail() {
    if (thumbnail != null) return true;
    return false;
  }

  bool hasFull() {
    if (full != null) return true;
    return false;
  }
}