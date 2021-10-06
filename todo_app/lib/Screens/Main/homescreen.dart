import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Components/Containers/hometodocontainer.dart';
import 'package:todo_app/constants.dart';
import '../../router.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List listids = [], listnames = [];
  late String userlistid;
  late String listid;
  final currentUser = supabase.auth.user();
  final _inputController = TextEditingController();
  final _inputformkey = GlobalKey<FormState>();
  late bool _new = true;
  var _loading = false;

  void initState() {
    _getLists(currentUser!.id);
  }

  Future<void> _createlist() async {
    print("Testing List");
    final updates = {
      'userid': currentUser!.id,
    };
    final response = await supabase.from('todolists').upsert(updates).execute();
    if (response.error != null) {
      print("AE Error Code 4");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _getlistid(String userId) async {
    final response = await supabase
        .from('todolists')
        .select()
        .eq('userid', userId)
        .eq('new', _new)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      print("AE Error Code 3");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data != null) {
      if (response.data['new'] == true) {
        listid = response.data['listid'] as String;
        _new = response.data['new'] as bool;
      }
    }
  }

  Future<void> _getLists(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('todolistlinks')
        .select()
        .eq('userid', userId)
        .single()
        .execute();
    if (response.error != null && response.status != 406) {
      print("AE Error Code 2");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
    if (response.data != null) {
      userlistid = response.data['id'] as String;
      listids = response.data!['listids'] as List;
      listnames = response.data!['listnames'] as List;
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _updateLists() async {
    final _listIDs = listids;
    final _user = currentUser!.id;
    final _listnames = listnames;
    final _ID = userlistid;
    final updates = {
      'listids': _listIDs,
      'userid': _user,
      "listnames": _listnames,
      "id": _ID,
    };
    final response = await supabase.from('todolistlinks').update(updates).execute();
    if (response.error != null) {
      print("AE Error Code 1");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _setnewlistfalse(String listId) async {
    print(listid);
    final _user = currentUser!.id;
    final updates = {
      "userid": _user,
      "new": false,
    };
    final response = await supabase.from('todolists').update(updates).execute();
    if (response.error != null) {
      print("AE Error Code 5");
      print(listid);
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
                  child: HomeToDoContainer(
                    widthvalue: 670,
                    listIDs: _loading? ["loading..."] : listids,
                    currentUserID: _loading? "loading..." : currentUser!.id,
                    listnames: _loading? ["loading..."] :  listnames,
                    //TODO review below variable
                    ID: _loading? "loading..." : userlistid,
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
                        setState(() {
                          _loading = true;
                        });
                        await _createlist();
                        await _getlistid(currentUser!.id);
                        print(listid);
                        listids.add(listid);
                        listnames.add(value);
                        await _setnewlistfalse(listid);
                        await _updateLists();
                        await _getLists(currentUser!.id);
                        _inputController.clear();
                        setState(() {
                          _loading = false;
                        });
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
                      hintText: 'Create New List',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Invalid List Name';
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


