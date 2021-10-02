import 'package:flutter/material.dart';
import '../../constants.dart';

class WorkoutListCheckbox extends StatefulWidget {
  WorkoutListCheckbox({required this.day, required this.currentUserID, required this.listID,
    required this.completed, required this.index, required this.completedliststring});
  late String day, currentUserID, listID;
  late List completedliststring;
  late int index;
  late bool completed;

  @override
  _WorkoutListCheckboxState createState() => _WorkoutListCheckboxState();
}

class _WorkoutListCheckboxState extends State<WorkoutListCheckbox> {

  Future<void> _updateWorkouts(value) async {
    if (value == true) {
      widget.completedliststring[widget.index] = "true";
    } else {
      widget.completedliststring[widget.index] = "false";
    }
    final _listID = widget.listID;
    final _user = widget.currentUserID;
    final _day = widget.day;
    final _completed = widget.completedliststring;
    final updates = {
      "id": _listID,
      'userid': _user,
      'Day': _day,
      'Completed': _completed,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.completed,
      onChanged: (bool? value) {
        setState(() {
          widget.completed = value!;
          _updateWorkouts(widget.completed);
        });
      },
    );
  }
}

//_loading ? false :
