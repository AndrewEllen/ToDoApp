import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase/supabase.dart';
import '../../constants.dart';

class UserConsent extends StatefulWidget {
  @override
  _UserConsentState createState() => _UserConsentState();
}

class _UserConsentState extends State<UserConsent> {
  final currentUser = supabase.auth.user();

  Future<void> _createlist() async {
    print("Testing List");
    final updates = {
      'userid': currentUser!.id,
    };
    final response = await supabase.from('todolists').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _createProfile() async {
    final user = supabase.auth.currentUser;
    final updates = {
      'userid': user!.id,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully created profile!')));
    await {
    _createlist()
    };
    Timer(Duration(milliseconds: 800), () {
    Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: defaultBackgroundColour,
          body: Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  _createProfile();
                  print("Clicked");
                },
                style: ElevatedButton.styleFrom(
                  primary: WorkoutsAccentColour,
                ),
                child: Text(
                  "Consent to App Use",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
