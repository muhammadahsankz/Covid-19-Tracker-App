import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Covid 19 Tracker App'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(children: []),
    );
  }
}
