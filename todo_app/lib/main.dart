import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/Screens/Main/homescreen.dart';
import 'package:todo_app/Screens/Main/loginscreen.dart';
import 'package:todo_app/Screens/Main/splashscreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo_app/Screens/Main/userconsent.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "variables.env");
  String _url = dotenv.get('URL');
  String _anon = dotenv.get('ANONKEY');

  await Supabase.initialize(
    url: _url,
    anonKey: _anon,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      color: defaultBackgroundColour,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/consent': (_) => UserConsent(),
      },
    );
  }
}