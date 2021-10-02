import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Components/Screens/homeworkoutscontainer.dart';
import 'package:workout_app/Components/SideBar/sidebar.dart';
import 'package:workout_app/Data/Screens/feedback.dart';
import 'package:workout_app/Data/Screens/settings.dart';
import 'package:workout_app/Data/resetcheckboxes.dart';
import 'package:workout_app/data/Screens/workouthome.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

class WorkoutHomeScreen extends StatefulWidget {
  @override
  _WorkoutHomeScreenState createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  List sidebardata = [], feedbackdata = [];
  final currentUser = supabase.auth.user();
  var yesterday = DateTime.now().subtract(Duration(days:1));
  var today = DateTime.now();
  String dropdownValueDay = "Monday";
  final _Dayformkey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  late String day, listID;
  late List workouts = [],completedlist = [],_completedlist = [], settingsdata = [];
  bool _loading = true;
  late bool _completed;

  Future<void> _getWorkouts(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('userworkouts')
        .select()
        .eq('userid', userId)
        .eq('Day', dropdownValueDay)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data != null) {
      listID = response.data!["id"] as String;
      day = response.data!['Day'] as String;
      workouts = response.data!['Exercises'] as List;
      completedlist = response.data!['Completed'] as List;
      _completedlist = completedlist;
    }
    var i;
    for (i=0; i < completedlist.length; i++) {
      if (completedlist[i] == "true"){
        _completed = true;
        completedlist[i] = _completed;

      } else {
        _completed = false;
        completedlist[i] = _completed;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  Future<Null> _refresh() {
    return _getWorkouts(currentUser!.id).then((_workouts) {
      setState(() => workouts);
    });
  }

  void initState() {
    if (int.parse(DateFormat('HH').format(today)) < 4) {
      dropdownValueDay = DateFormat('EEEE').format(yesterday);
    } else {
      dropdownValueDay = DateFormat('EEEE').format(today);
      resettickboxes(DateFormat('EEEE').format(yesterday),currentUser!.id);
    }
    sidebardata = SideBarWorkout.getContents();
    feedbackdata = SideBarFeedback.getContents();
    settingsdata = SideBarSettings.getContents();
    _getWorkouts(currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        appBar: CustomAppBar(
          appbaraccentcolour: WorkoutsAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: "Workouts",
        ),
        drawer: CustomSideBar(
          sidebaraccentcolour: WorkoutsAccentColour,
          sidebarcolour: SideBarColour,
          sidebartitle: "Meals",
          feedbacktitle: "Feedback",
          settingstitle: "Settings",
          sidebardata: sidebardata,
          feedbackdata: feedbackdata,
          settingsdata: settingsdata,
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _Dayformkey,
                    child: DropdownButton<String>(
                      dropdownColor: defaultLoginBackgroundColour,
                      value: dropdownValueDay,
                      elevation: 1,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      underline: Container(
                        height: 2,
                        color: defaultLoginBackgroundColour,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValueDay = newValue!;
                        });
                        _getWorkouts(currentUser!.id);
                      },
                      items: <String>['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: _loading ? Container(
                    width: double.infinity,
                    height: 580,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppbarColour,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    )) : Container(
                    child: HomeWorkoutsContainer(
                      widthvalue: 580,
                      day: _loading ? "loading..." : day,
                      workouts: _loading? ["loading..."] : workouts,
                      completedlist: _loading? [false] : completedlist,
                      currentUserID: _loading? "loading..." : currentUser!.id,
                      listID: _loading? "loading..." :  listID,
                      completedliststring: _loading? ["loading..."] : _completedlist,
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
