import 'package:flutter/material.dart';
import 'package:workout_app/Components/Containers/workoutlistcheckbox.dart';
import 'package:workout_app/Components/Containers/workoutlistcontainer.dart';
import '../../constants.dart';

class HomeWorkoutsContainer extends StatefulWidget {
  HomeWorkoutsContainer({required this.day, required this.workouts, required this.currentUserID,
    required this.listID, required this.widthvalue, required this.completedlist, required this.completedliststring});
  late String day, currentUserID, listID;
  late double widthvalue;
  late List workouts, completedlist, completedliststring;
  @override
  _HomeWorkoutsContainerState createState() => _HomeWorkoutsContainerState();
}

class _HomeWorkoutsContainerState extends State<HomeWorkoutsContainer> {

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
          child: ListView.builder(
                itemCount: widget.workouts.length,
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    child: Stack(
                      children: [
                        Container(
                            child: WorkoutListContainer(
                              workout: widget.workouts[index],
                              margin: 1,
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: WorkoutListCheckbox(
                            completed: widget.completedlist[index],
                            index: index,
                            day: widget.day,
                            completedliststring: widget.completedliststring,
                            currentUserID: widget.currentUserID,
                            listID: widget.listID,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
        ),
    );
  }
}
