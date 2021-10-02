import 'package:flutter/material.dart';
import 'package:workout_app/Components/Auth/authstate.dart';
import '../../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends AuthState<SplashScreen> {
  @override
  void initState() {
    recoverSupabaseSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: defaultBackgroundColour,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}