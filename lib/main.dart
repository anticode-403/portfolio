import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:portfolio/repo_card.dart';
import 'package:portfolio/video_card.dart';
import 'firebase_options.dart';

import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import './header.dart';
import './image_card.dart';
import './image_preview.dart';
import './image_data.dart';

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

class ImageState {
  static List<ImageData> images = <ImageData>[];

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

  _PortfolioState() {
    if (ImageState.images.isNotEmpty) {
      images = ImageState.images;
    }
    else {
      getImages();
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

  List<Widget> getImageCards() {
    List<Widget> imagesMap = images.map((e) => ImageCard(e)).toList();
    List<Widget> cards = <Widget>[];
    cards.insert(0, const VideoCard('ArOQApNu9HU')); // Inserting video cards manually
    cards.insert(0, const VideoCard('TIFAMFn0Y40'));
    cards.addAll(imagesMap);

    return cards;
  }

  Column getCuratedRepoCards(Orientation orientation) {
    List<RepoCard> curatedRepoCards = <RepoCard>[
      RepoCard('ABCO', 'A Minecraft mod that expands and overhauls many of the features added by the Better Combat mod.', 'https://github.com/anticode-403/antis-Better-Combat-Overhauls', orientation == Orientation.portrait),
      RepoCard('Astro Reforged', 'A completely redesigned and remade version of the Astro! mod by Prismatica.', 'https://github.com/anticode-403/astro_reforged', orientation == Orientation.portrait),
      RepoCard('Compositor Pro', 'A Blender add-on focused on adding features and utilities to the Blender Compositor.', 'https://github.com/anticode-403/compositor_pro', orientation == Orientation.portrait),
      RepoCard('Portfolio Website', 'A Flutter-based website designed ', '', orientation == Orientation.portrait)
    ];
    // Normally, embedding would be the better way to do this, but I'm doing it this way to curate specifically which repos get displayed AND what description gets shown.
    List<Row> rows = <Row>[];
    for (List<RepoCard> chunk in curatedRepoCards.slices(orientation == Orientation.portrait ? 2 : 4)) {
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
              getCuratedRepoCards(orientation),
              const SizedBox(height: 8),
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
