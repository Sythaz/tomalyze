import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tomalyze/core/providers/local_auth_provider.dart';
import 'package:tomalyze/firebase_options.dart';
import 'package:tomalyze/presentation/views/history/history_page.dart';
import 'package:tomalyze/presentation/views/home/home_page.dart';

import 'core/models/history_classification_model.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/history_provider.dart';
import 'presentation/views/auth/login_page.dart';
import 'presentation/views/main_page.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryClassificationModelAdapter());
  await Hive.openBox<HistoryClassificationModel>('classification_history');
  await Hive.openBox('local_auth');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => LocalAuthProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context);
    final authLocal = Provider.of<LocalAuthProvider>(context);
    bool isLoggedIn = auth.isLoggedIn || authLocal.isLoggedIn;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tomalyze',
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
