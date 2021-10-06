import 'package:flutter/material.dart';
import 'package:todo_app/Components/Containers/todolistcontainer.dart';
import 'package:todo_app/Screens/Main/listview.dart';
import '../../constants.dart';

class HomeToDoContainer extends StatefulWidget {
  HomeToDoContainer({
    required this.listIDs,
    required this.currentUserID,
    required this.listnames,
    required this.ID,
    required this.widthvalue,
  });
  late String currentUserID;
  late List listIDs;
  late double widthvalue;
  late List listnames;
  late String ID;

  @override
  _HomeToDoContainerState createState() => _HomeToDoContainerState();
}

class _HomeToDoContainerState extends State<HomeToDoContainer> {
  Future<void> _updateLists() async {
    final _user = widget.currentUserID;
    final _listIDs = widget.listIDs;
    final _listnames = widget.listnames;
    final _ID = widget.ID;
    final updates = {
      'listids': _listIDs,
      'userid': _user,
      'listnames': _listnames,
      'id': _ID,
    };
    final response = await supabase.from('todolistlinks').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _deletelist(listID) async {
    await supabase
        .from('todolists')
        .delete()
        .eq('listid', listID)
        .eq('userid', widget.currentUserID)
        .execute();
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
          )),
    );
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    setState(() {
      var item1 = widget.listnames[oldIndex];
      var item2 = widget.listIDs[oldIndex];

      widget.listnames.removeAt(oldIndex);
      widget.listnames.insert(newIndex, item1);
      widget.listIDs.removeAt(oldIndex);
      widget.listIDs.insert(newIndex,item2);
    });
    _updateLists();
  }

  List<Widget> getList() => widget.listnames
      .asMap()
      .map((i, item) => MapEntry(i, _buildTiles(item, i)))
      .values
      .toList();

  Widget _buildTiles(item, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          _deletelist(widget.listIDs[index]);
          widget.listnames.removeAt(index);
          widget.listIDs.removeAt(index);
        });
        _updateLists();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$item dismissed')));
      },
      background: Container(
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15), child: Icon(Icons.delete))),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListScreen(listid: widget.listIDs[index],
                  ),
                )
              );
            },
            child: Container(
              child: ToDoListContainer(
                workout: widget.listnames[index],
                margin: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
