import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';


AppBar portfolioAppBarBuilder(BuildContext context, Orientation orientation, {Function(int)? callback}) {
  return AppBar(
    elevation: 0,
    leading: Container(
      padding: const EdgeInsets.all(4),
      child: Image.network('https://firebasestorage.googleapis.com/v0/b/anticode-portfolio.appspot.com/o/assets%2FVerdana_icon_SuperComp.png?alt=media&token=6d65dc2d-4e90-4730-ab6d-461f04db4aaa'),
    ),
    title: TextButton(
      child: const Text(
        'anticode',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      onPressed: () => context.go('/'),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: TextButton(
            child: Text(
              orientation == Orientation.portrait ? 'SH' : 'Superhive',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onPressed: () => launchUrlString(DateTime.now().toUtc().isAfter(DateTime.utc(2025, 4, 7, 14)) ? 'https://superhivemarket.com/creators/anticode' : 'https://blendermarket.com/creators/anticode'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: TextButton(
          child: Text(orientation == Orientation.portrait ? 'GR' : 'Gumroad',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => launchUrlString('https://gumroad.anticode.me/'),
        ),
      ),
    ]
  );
}