import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VideoCard extends StatelessWidget {
  final String videoId;

  const VideoCard(this.videoId, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrlString('https://youtube.com/watch?v=$videoId'),
      child: SizedBox(
        width: 200,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.network('https://img.youtube.com/vi/$videoId/maxresdefault.jpg'),
            const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.play_arrow, 
                color: Colors.white, 
                size: 50,
                shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 16.0)],
              ),
            ),
          ],
        )
      ),
    );
  }
}