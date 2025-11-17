import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

import 'package:collection/collection.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import './header.dart';
import './image_card.dart';
import './image_preview.dart';
import './image_data.dart';
import './repo_card.dart';
import './repo_data.dart';
import './video_card.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Portfolio(),
    ),
    GoRoute(
      path: '/image/:image',
      builder: (context, state) => ImagePreview(imageId: state.pathParameters['image']),
    ),
  ]
);

class FirebaseState {
  static List<ImageData> images = <ImageData>[];
  static List<String> videoIds = <String>[];
  static List<RepoData> repos = <RepoData>[];

  static ImageData? getImage(String name) {
    for (ImageData image in images) {
      if (image.name == name) return image;
    }
    return null;
  }
}

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'anticode',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        )
      ),
      routerConfig: _router,
    );
  }
}

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  final storage = FirebaseStorage.instance.ref();
  List<ImageData> images = <ImageData>[];
  // List<RepoData> repos = <RepoData>[];
  List<String> videoIds = <String>[];

  _PortfolioState() {
    if (FirebaseState.images.isNotEmpty) {
      images = FirebaseState.images;
    }
    else {
      getImages();
    }
    // if (FirebaseState.repos.isNotEmpty) {
    //   repos = FirebaseState.repos;
    // }
    // else {
      
    // }
    if (FirebaseState.videoIds.isNotEmpty) {
      videoIds = FirebaseState.videoIds;
    }
    else {
      getVideos();
    }
  }

  void getImages() async {
    ListResult baseList = await storage.child('portfolio').list();
    baseList.items.remove(storage.child('portfolio/thumbnails')); // Get rid of thumbnail
    List<ImageData> baseImageData = baseList.items.map((e) => ImageData(e.name)).toList();
    setState(() {
      images = baseImageData;
    });
  }

  void getVideos() async {
    Uint8List? baseVideoData = await storage.child('videos.txt').getData();
    if (baseVideoData == null) return;
    setState(() {
      videoIds = const Utf8Codec().decode(baseVideoData).split('\n');
    });
  }

  List<Widget> getImageCards() {
    return images.map((e) => ImageCard(e)).toList();
  }

  List<Widget> getVideoCards() {
    return videoIds.map((e) => VideoCard(e)).toList();
  }

  Column getCuratedRepoCards(Orientation orientation) {
    List<RepoData> curatedRepoCards = <RepoData>[
      const RepoData('ABCO', 'A Minecraft mod that expands and overhauls many of the features added by the Better Combat mod.', 'https://github.com/anticode-403/antis-Better-Combat-Overhauls'),
      const RepoData('Astro Reforged', 'A completely redesigned and remade version of the Astro! mod by Prismatica.', 'https://github.com/anticode-403/astro_reforged'),
      const RepoData('Compositor Pro', 'A Blender add-on focused on adding features and utilities to the Blender Compositor.', 'https://github.com/anticode-403/compositor_pro'),
      const RepoData('Portfolio Website', 'A Flutter-based website designed to show-off various projects I\'ve worked on.', 'https://github.com/anticode-403/portfolio')
    ];
    // Normally, embedding would be the better way to do this, but I'm doing it this way to curate specifically which repos get displayed AND what description gets shown.
    List<Row> rows = <Row>[];
    for (List<RepoData> dataChunk in curatedRepoCards.slices(orientation == Orientation.portrait ? 2 : 4)) {
      List<RepoCard> chunk = <RepoCard>[];
      for (RepoData data in dataChunk) {
        chunk.add(RepoCard(data, orientation == Orientation.portrait));
      }
      rows.add(Row(
        children: chunk,
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: portfolioAppBarBuilder(context, orientation),
          body: ListView(
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(16), child: Text('Software Development', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
              getCuratedRepoCards(orientation),
              const SizedBox(height: 8),
              const Padding(padding: EdgeInsets.all(16), child: Text('Video Projects', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
              StaggeredGrid.count(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                axisDirection: AxisDirection.down,
                children: getVideoCards(),
              ),
              const SizedBox(height: 8),
              const Padding(padding: EdgeInsets.all(16), child: Text('Art Pieces', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
              StaggeredGrid.count(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                axisDirection: AxisDirection.down,
                children: getImageCards(),
              ),
            ],
          )
        );
      }
    );
  }
}
