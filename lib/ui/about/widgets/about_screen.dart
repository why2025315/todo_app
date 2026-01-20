import 'package:flutter/material.dart';
import 'package:todo_app/widgets/bottom_navigation.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Container(),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
