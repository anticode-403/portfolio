import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './image_data.dart';

class ImageCard extends StatefulWidget {
  const ImageCard(this.imageData, {super.key});
  final ImageData imageData;

  @override
  State<StatefulWidget> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {

  @override
  void initState() {
    super.initState();
    if (!widget.imageData.hasThumbnail()) getImageThumb();
  }

  void getImageThumb() async {
    Reference storage = FirebaseStorage.instance.ref();
    Uint8List? data = await storage.child('portfolio/thumbnails/${widget.imageData.name.substring(0,widget.imageData.name.length-4)}_300x1000.png').getData(18750000);
    if (data != null) {
      setState(() => widget.imageData.thumbnail = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List? thumb = widget.imageData.thumbnail;
    return GestureDetector(
      onTap: () => context.go('/image/${widget.imageData.name}'),
      child: thumb != null ? Image.memory(thumb, fit:BoxFit.fitWidth) : Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.white,
        child: Container(width:200,height:200, color: Colors.white12,),
      ),
    );
  }
}