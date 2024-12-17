import 'package:flutter/material.dart';
import 'package:histomictk/pages/annotate.dart';
import 'package:histomictk/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:histomictk/service/provider/appdata.dart';
void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AppData())],
      child: const MyApp()));
}

const Color kCanvasColor = Color(0xfff2f3f7);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HistomicTK',
      home: Annotate(),
    );
  }
}
