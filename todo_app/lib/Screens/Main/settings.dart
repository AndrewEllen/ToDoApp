import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import '../../constants.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({required this.appbartitle, Key? key}) : super(key: key);
  final String appbartitle;


  Future<void> _deletedata() async {
    final currentUser = supabase.auth.user()!.id;
    final responseWorkouts = await supabase
        .from('userworkouts')
        .delete()
        .eq('userid', currentUser)
        .execute();
    final responseProfile = await supabase
        .from('profiles')
        .delete()
        .eq('id', currentUser)
        .execute();
/*    final responseUserDelete = await supabase.auth.api.deleteUser(
      currentUser,

    )*/
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: defaultBackgroundColour,
          appBar: CustomAppBar(
            appbaraccentcolour: OtherAccentColour,
            appbarcolour: AppbarColour,
            appbartitle: appbartitle,
          ),
          body: Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                   _deletedata();
                   print("Clicked");
                },
                style: ElevatedButton.styleFrom(
                  primary: WorkoutsAccentColour,
                ),
                child: Text(
                  "Delete all Data",
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
