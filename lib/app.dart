import 'package:coin_bitch/constants.dart';
import 'package:coin_bitch/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(title: Constants.title),
    );
  }
}
