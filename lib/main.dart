import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tomalyze/presentation/views/main_page.dart';

void main() {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tomalyze',
      home: MainPage(),
    );
  }
}
