import '../constants.dart';

Future<void> resettickboxes(day,userId) async {
  late String listID = "null";
  late List completedlist = [];
  late bool resetchecked = true;

  Future<void> _getWorkouts(String userId) async {
    final response = await supabase
        .from('userworkouts')
        .select()
        .eq('UserID', userId)
        .eq('Day', day)
        .single()
        .execute();
    if (response.data != null) {
      listID = response.data!["id"] as String;
      completedlist = response.data!['Completed'] as List;
      resetchecked = response.data!['resetchecked'] as bool;
    }
  }

  Future<void> _updateWorkouts() async {
    final _listID = listID;
    final _user = userId;
    final _day = day;
    final _completedlist = completedlist;
    final updates = {
      "id": _listID,
      'UserID': _user,
      'Day': _day,
      'Completed': _completedlist,
      "resetchecked" : resetchecked,
    };
    final response = await supabase.from('userworkouts').upsert(updates).execute();
    if (response.error != null) {
    }
  }

  await _getWorkouts(userId);

  if (resetchecked == true) {
    var i;
    for (i=0;i < completedlist.length; i++) {
      completedlist[i] = "false";
    }
    resetchecked == false;
    await _updateWorkouts();
  }

}