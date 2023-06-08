import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  bool themeMode = true;

  void changeTheme() {
    setState(() {
      themeMode = !themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tenor Картинки',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
      ),
      themeMode: themeMode ? ThemeMode.light : ThemeMode.dark,
      home: const MyHomePage(title: 'Tenor Картинки'),
    );
  }
}
