import 'text.dart';
import 'package:flutter/material.dart';

bool lang = false;
TextTranslation tt = TextTranslation();

void main() {
  runApp(const AutoResume());
}

class AutoResume extends StatelessWidget {
  const AutoResume({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: lang ? tt.resumeGenerator.zh : tt.resumeGenerator.en,
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 500,
      color: Colors.amber,
      child: const Text("TEST"),
    );
  }
}
