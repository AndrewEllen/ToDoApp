import 'package:workout_app/Screens/Main/feedback.dart';
import '../models/sidebartextmodel.dart';

class SideBarFeedback {
  static List<SideBarText> getContents() {
    return [
      SideBarText(
        settingsText: "Feedback",
        textLink: "/feedback",
        routerWidget: FeedBack(appbartitle: 'Anonymous Feedback',),
        //routerWidget: WorkoutsListScreen(),
      ),
    ];
  }
}
