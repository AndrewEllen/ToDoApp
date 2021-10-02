import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import 'package:workout_app/Components/Screens/workoutscontainer.dart';
import 'package:workout_app/Data/resetcheckboxes.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';

class WorkoutListScreen extends StatefulWidget {
  WorkoutListScreen(
      {required this.appbartitle});
  final String appbartitle;

  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final currentUser = supabase.auth.user();
  var yesterday = DateTime.now().subtract(Duration(days:1));
  var today = DateTime.now();
  String dropdownValueDay = "Monday";
  final _Dayformkey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  final _inputformkey = GlobalKey<FormState>();
  late String day, listID;
  late List workouts,completedlist;
  bool _loading = true;

  void initState() {
    if (int.parse(DateFormat('HH').format(today)) < 4) {
      dropdownValueDay = DateFormat('EEEE').format(yesterday);
    } else {
      dropdownValueDay = DateFormat('EEEE').format(today);
      resettickboxes(DateFormat('EEEE').format(yesterday),currentUser!.id);
    }

    _getWorkouts(currentUser!.id);
  }

  Future<void> _updateWorkouts() async {
    final _listID = listID;
    final _user = currentUser!.id;
    final _day = day;
    final _workouts = workouts;
    final _completedlist = completedlist;
    final updates = {
      "id": _listID,
      'userid': _user,
      'Day': _day,
      'Exercises': _workouts,
      'Completed': _completedlist,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

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
          appbaraccentcolour: WorkoutsAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: widget.appbartitle,
        ),
        body: ListView(
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
              child: _loading? Container(
                  width: double.infinity,
                  height: 500,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppbarColour,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  )) : Container(
                child: WorkoutsContainer(
                  widthvalue: 500,
                  day: _loading ? "loading..." : day,
                  workouts: _loading? ["loading..."] : workouts,
                  completedlist: _loading? ["loading..."] : completedlist,
                  currentUserID: _loading? "loading..." : currentUser!.id,
                  listID: _loading? "loading..." :  listID,
                ),
              )
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 60,
                margin: EdgeInsets.only(left:10,right:10),
                decoration: BoxDecoration(
                  color: AppbarColour,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
                  key: _inputformkey,
                  child: TextFormField(
                    onFieldSubmitted: (value) async {
                      if (_inputformkey.currentState!.validate()) {
                        workouts.add(value);
                        completedlist.add("false");
                        await _updateWorkouts();
                        _getWorkouts(currentUser!.id);
                        _inputController.clear();
                      }
                    },
                    enableInteractiveSelection : true,
                    controller: _inputController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Workout',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Invalid Height';
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
