import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nawaqs/Models/consumer.dart';
import 'package:nawaqs/firebase_options.dart';
import 'package:nawaqs/views/neededList.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const Nawaqs());
}

class Nawaqs extends StatelessWidget {
  const Nawaqs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'نواقص',
        theme: ThemeData.dark(),
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'),
          // Locale('en'),
        ],
        home: FutureBuilder(
            future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              Consumer();
              return const NeededList();
            }));
  }
}
