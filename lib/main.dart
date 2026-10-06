import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_rtdb/firebase_options.dart';
import 'package:firebase_rtdb/provider/app_provider.dart';
import 'package:firebase_rtdb/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'MCS BAB 5',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

