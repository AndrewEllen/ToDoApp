import 'package:workout_app/Screens/Main/settings.dart';
import '../models/sidebartextmodel.dart';

class SideBarSettings {
  static List<SideBarText> getContents() {
    return [
      SideBarText(
        settingsText: "Settings",
        textLink: "/settings",
        routerWidget: SettingsPage(appbartitle: 'Settings',),
        //routerWidget: WorkoutsListScreen(),
      ),
    ];
  }
}
