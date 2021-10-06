import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Components/Screens/listscontainer.dart';
import '../../constants.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key, required this.listid}) : super(key: key);
  final String listid;

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late List listcontents = [], completedlist = [], _completedlist = [];
  late String listid = widget.listid;
  final currentUser = supabase.auth.user();
  final _inputController = TextEditingController();
  final _inputformkey = GlobalKey<FormState>();
  late bool _completed;
  var _loading = false;

  void initState() {
    _getLists(currentUser!.id);
  }

  Future<void> _getLists(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('todolists')
        .select()
        .eq('userid', userId)
        .eq('listid', listid)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data != null) {
      listcontents = response.data!['listcontents'] as List;
      completedlist = response.data!['Completed'] as List;
      _completedlist = completedlist;
    }
    var i;
    for (i=0; i < completedlist.length; i++) {
      if (completedlist[i] == "true"){
        _completed = true;
        _completedlist[i] = _completed;

      } else {
        _completed = false;
        _completedlist[i] = _completed;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateLists() async {
    final _listID = listid;
    final _user = currentUser!.id;
    final _listcontents = listcontents;
    final _completed = completedlist;
    final updates = {
      'listid': _listID,
      'userid': _user,
      "listcontents": _listcontents,
      "Completed": _completed,
    };
    final response = await supabase.from('todolists').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  _logout() async {
    await supabase.auth.signOut();
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void onUnauthenticated() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        drawer: Drawer(
          child: Scaffold(
            backgroundColor: defaultBackgroundColour,
            body: Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    _logout();
                    print("Clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    primary: WorkoutsAccentColour,
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
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
                  child: ToDoContainer(
                    widthvalue: 670,
                    listID: _loading? "loading..." : listid,
                    currentUserID: _loading? "loading..." : currentUser!.id,
                    listcontents: _loading? ["loading..."] :  listcontents,
                    completedlist: _loading? ["loading..."] : _completedlist,
                    completedliststring: _loading? ["loading..."] : completedlist,
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
                        listcontents.add(value);
                        completedlist.add("false");
                        await _updateLists();
                        _getLists(currentUser!.id);
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
                      hintText: 'Create New Item',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Invalid Item';
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
