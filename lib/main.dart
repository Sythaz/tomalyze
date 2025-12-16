import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tomalyze/firebase_options.dart';

import 'core/models/history_classification_model.dart';
import 'core/providers/auth_provider.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tomalyze',
      home: auth.user != null ? const MainPage() : const LoginPage(),
    );
  }
}
