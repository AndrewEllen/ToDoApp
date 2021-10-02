import 'package:workout_app/Screens/Diet/foodscreen.dart';
import '../models/sidebartextmodel.dart';

class SideBarDiet {
  static List<SideBarText> getContents() {
    return [
      SideBarText(
        settingsText: "Breakfast",
        textLink: "/food",
        routerWidget: FoodListScreen(appbartitle: "Breakfast")
      ),
      SideBarText(
        settingsText: "Lunch",
        textLink: "/food",
        routerWidget: FoodListScreen(appbartitle: "Lunch"),
      ),
      SideBarText(
        settingsText: "Dinner",
        textLink: "/food",
        routerWidget: FoodListScreen(appbartitle: "Dinner"),
      ),
    ];
  }
}
