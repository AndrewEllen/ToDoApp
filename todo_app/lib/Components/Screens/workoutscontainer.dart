import 'package:flutter/material.dart';
import 'package:workout_app/Components/Containers/workoutlistcontainer.dart';
import '../../constants.dart';

class WorkoutsContainer extends StatefulWidget {
  WorkoutsContainer(
      {required this.day,
      required this.workouts,
      required this.currentUserID,
      required this.listID,
      required this.widthvalue,
      required this.completedlist});
  late String day, currentUserID, listID;
  late double widthvalue;
  late List workouts, completedlist;
  @override
  _WorkoutsContainerState createState() => _WorkoutsContainerState();
}

class _WorkoutsContainerState extends State<WorkoutsContainer> {
  Future<void> _updateWorkouts() async {
    final _listID = widget.listID;
    final _user = widget.currentUserID;
    final _day = widget.day;
    final _workouts = widget.workouts;
    final _completedlist = widget.completedlist;
    final updates = {
      "id": _listID,
      'userid': _user,
      'Day': _day,
      'Exercises': _workouts,
      'Completed': _completedlist,
    };
    final response =
        await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.widthvalue,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppbarColour,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: ReorderableListView(
            onReorder: reorder,
            children: getList(),
          )


      ),
    );
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    setState(() {
      var item1 = widget.workouts[oldIndex];
      var item2 = widget.completedlist[oldIndex];

      widget.workouts.removeAt(oldIndex);
      widget.workouts.insert(newIndex,item1);
      widget.completedlist.removeAt(oldIndex);
      widget.completedlist.insert(newIndex,item2);
    });
    _updateWorkouts();
  }

  List<Widget> getList() => widget.workouts
      .asMap()
      .map((i, item) => MapEntry(i, _buildTiles(item, i)))
      .values
      .toList();

  Widget _buildTiles(item ,int index) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          setState(() {
            widget.workouts.removeAt(index);
            widget.completedlist.removeAt(index);
          });
          _updateWorkouts();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$item dismissed')));
        },
        background: Container(
          color: Colors.red,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Icon(Icons.delete))),
        ),
        child: Container(
          child: WorkoutListContainer(
            workout: widget.workouts[index],
            margin: 0,
          ),
        ),
    );
  }

}
