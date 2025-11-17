import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/repo_data.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RepoCard extends StatelessWidget {
  final RepoData data;
  final bool doublesize;

  const RepoCard(this.data, this.doublesize, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / (doublesize ? 2 : 4),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.github),
                      const SizedBox(width: 8),
                      Text(
                        data.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(data.description),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Go'),
                        onPressed: () => launchUrlString(data.link),
                      ),
                    ],
                  ),
                ],
              )
            )
          ],
        )
      )
    );
  }
}