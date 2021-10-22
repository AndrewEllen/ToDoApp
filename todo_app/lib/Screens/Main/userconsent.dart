import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase/supabase.dart';
import '../../constants.dart';
import 'T&C.dart' as TandC;
import 'PrivacyPolicy.dart' as PrP;

//https://medium.com/flutter-town/flutter-create-an-agreement-view-3710c2e7db44
//CCPA & GDPR

class UserConsent extends StatefulWidget {
  @override
  _UserConsentState createState() => _UserConsentState();
}

class _UserConsentState extends State<UserConsent> {
  final currentUser = supabase.auth.user();
  bool useragreement = false;
  bool userpolicy = false;
  bool usercancontinue = false;

  Future<void> _createnewlist() async {
    print("Testing List");
    final updates = {
      'userid': currentUser!.id,
    };
    final response =
        await supabase.from('todolistlinks').upsert(updates).execute();
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
      await {_createnewlist()};
      Timer(Duration(milliseconds: 800), () {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      });
    }
  }

  Future _OpenTermsAndConditions(context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return TandC.TermsAndConditions();
        },
        fullscreenDialog: true));
  }

  Future _OpenPrivacyPolicy(context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return PrP.PrivacyPolicy();
        },
        fullscreenDialog: true));
  }

  Future _checkuseragreed() async {
    if ((useragreement == true) & (userpolicy == true)) {
      usercancontinue = true;
    } else {
      usercancontinue = false;
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        body: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                Row(children: [
                  Checkbox(
                      value: useragreement,
                      focusColor: Colors.red,
                      activeColor: Colors.red,
                      hoverColor: Colors.red,
                      checkColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          useragreement = value ?? false;
                          _checkuseragreed();
                        });
                      }),
                  Text(
                    'I have read and I accept the ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _OpenTermsAndConditions(context);
                    },
                    child: Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: userpolicy,
                      focusColor: Colors.red,
                      activeColor: Colors.red,
                      hoverColor: Colors.red,
                      checkColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          userpolicy = value ?? false;
                          _checkuseragreed();
                        });
                      }),
                  Text(
                    'I have read and I accept the ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _OpenPrivacyPolicy(context);
                    },
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ]),
                ElevatedButton(
                  onPressed: usercancontinue
                      ? () {
                          _createProfile();
                          print("Clicked");
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    primary: usercancontinue ? WorkoutsAccentColour : Colors.grey,
                  ),
                  child: Text(
                    "Consent to App Use",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
