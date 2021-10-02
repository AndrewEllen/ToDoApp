import 'package:workout_app/Screens/Workouts/workoutsscreen.dart';
import '../models/sidebartextmodel.dart';

class SideBarWorkout {
  static List<SideBarText> getContents() {
    return [
      SideBarText(
        settingsText: "Edit Workout Plan",
        textLink: "/workouts",
        routerWidget: WorkoutListScreen(appbartitle: 'Select Workouts'),
        //routerWidget: WorkoutsListScreen(),
      ),
    ];
  }
}
