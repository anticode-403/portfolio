import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:go_router/go_router.dart';

import './header.dart';
import './main.dart';
import './image_data.dart';

class ImagePreview extends StatefulWidget {
  final String? imageId;

  const ImagePreview({this.imageId, super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late ImageData imageData;
  bool isLoading = true;

  void getImage() async {
    Reference storage = FirebaseStorage.instance.ref();
    Uint8List? data = await storage.child('portfolio/${imageData.name}').getData(18750000);

    setState(() {
      isLoading = false;
      if (data != null) imageData.full = data;
    });
  }

  @override
  void initState() {
    super.initState();
    String? imageName = widget.imageId;
    if (imageName == null) return;
    if (FirebaseState.images.isEmpty || FirebaseState.getImage(imageName) == null) {
      isLoading = true;
      imageData = ImageData(imageName);
      getImage();
      return;
    }
    else {
      ImageData? fetchedImage = FirebaseState.getImage(imageName);
      if (fetchedImage != null) {
        imageData = fetchedImage;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            appBar: portfolioAppBarBuilder(context, orientation),
            body: const Center(
              child: CircularProgressIndicator()
            ),
          );
        }
      );
    }
    else if (widget.imageId == null || imageData.full == null) {
      return OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            appBar: portfolioAppBarBuilder(context, orientation),
            body: const Center(
              child: Text('No image here! Check your URL.'),
            ),
          );
        }
      );
    }
    else {
      return OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            appBar: portfolioAppBarBuilder(context, orientation),
            body: Center(
              child: PhotoView(
                imageProvider: MemoryImage(imageData.full!),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.go('/'),
              child: const Icon(Icons.undo),
            ),
          );
        }
      );
    }
  }
}