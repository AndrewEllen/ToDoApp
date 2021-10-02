import 'package:flutter/material.dart';
import 'package:todo_app/Components/Containers/todolistcheckbox.dart';
import 'package:todo_app/Components/Containers/todolistcontainer.dart';
import '../../constants.dart';

class ToDoContainer extends StatefulWidget {
  ToDoContainer({
    required this.listID,
    required this.currentUserID,
    required this.listcontents,
    required this.widthvalue,
    required this.completedlist,
    required this.completedliststring,
  });
  late String currentUserID;
  late String listID;
  late double widthvalue;
  late List listcontents;
  late List completedlist;
  late List completedliststring;
  @override
  _ToDoContainerState createState() => _ToDoContainerState();
}

class _ToDoContainerState extends State<ToDoContainer> {
  Future<void> _updateLists() async {
    final _user = widget.currentUserID;
    final _listID = widget.listID;
    final _listcontents = widget.listcontents;
    final _completedlist = widget.completedliststring;
    final updates = {
      'listid': _listID,
      'userid': _user,
      'listcontents': _listcontents,
      'Completed': _completedlist,
    };
    final response = await supabase.from('todolists').upsert(updates).execute();
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
          )),
    );
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    setState(() {
      var item1 = widget.listcontents[oldIndex];
      print(item1);
      var item2 = widget.completedlist[oldIndex];
      print(item2.runtimeType);

      widget.listcontents.removeAt(oldIndex);
      widget.listcontents.insert(newIndex, item1);
      widget.completedlist.removeAt(oldIndex);
      widget.completedlist.insert(newIndex,item2);
    });
    _updateLists();
  }

  List<Widget> getList() => widget.listcontents
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
          widget.listcontents.removeAt(index);
          widget.completedlist.removeAt(index);
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
          Container(
            child: ToDoListContainer(
              workout: widget.listcontents[index],
              margin: 0,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ToDoListCheckbox(
              completed: widget.completedlist[index],
              index: index,
              completedliststring: widget.completedliststring,
              completedlist: widget.completedlist,
              currentUserID: widget.currentUserID,
              listID: widget.listID,
            ),
          )
        ],
      ),
    );
  }
}
