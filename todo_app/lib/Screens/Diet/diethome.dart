import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Components/SideBar/sidebar.dart';
import 'dart:async';
import 'package:workout_app/Components/Screens/dietmealbox.dart';
import 'package:workout_app/Data/Screens/feedback.dart';
import 'package:workout_app/Data/Screens/settings.dart';
import 'package:workout_app/data/Screens/diethome.dart';
import '../../constants.dart';

class DietHomeScreen extends StatefulWidget {
  @override
  _DietHomeScreenState createState() => _DietHomeScreenState();
}

class _DietHomeScreenState extends State<DietHomeScreen> {
  final currentUser = supabase.auth.user();
  late List sidebardata, feedbackdata, settingsdata;
  var _loading = false;
  var calories;

  void initState() {
    sidebardata = SideBarDiet.getContents();
    feedbackdata = SideBarFeedback.getContents();
    settingsdata = SideBarSettings.getContents();
    _getProfile(currentUser!.id);
  }

  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data != null) {
      calories = response.data!['daily_calories'];
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        appBar: CustomAppBar(
          appbaraccentcolour: DietAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: "Diet",
        ),
        drawer: CustomSideBar(
          sidebaraccentcolour: DietAccentColour,
          sidebarcolour: SideBarColour,
          sidebartitle: "Meals",
          feedbacktitle: "Feedback",
          settingstitle: "Settings",
          sidebardata: sidebardata,
          feedbackdata: feedbackdata,
          settingsdata: settingsdata,
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: DietMealBox(
                marginsize: 15,
                boxheading: "Daily Calories Goal",
                headingcontent: _loading ? 0 : calories.toString(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: DietMealBox(
                marginsize: 110,
                boxheading: "Daily Calories Remaining",
                headingcontent: _loading ? 0 : calories.toString(),
              ),
            ),
          ],
        )
      ),
    );
  }
}
