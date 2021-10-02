import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workout_app/Components/Navbar/Navbar.dart';
import '../../constants.dart';

class FeedBack extends StatefulWidget {
  FeedBack(
      {required this.appbartitle, Key? key}): super(key: key);
  final String appbartitle;

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  late final _feedbackController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _loading = false;

  Future<void> _postFeedback() async {
    setState(() {
      _loading = true;
    });
    final feedback = _feedbackController.text;
    final updates = {
      'Feedback': feedback,
      'posted_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('feedback').upsert(updates).execute();
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error!.message),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Posted Feedback!')));
      Timer(Duration(milliseconds: 800), () {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: defaultBackgroundColour,
        appBar: CustomAppBar(
          appbaraccentcolour: OtherAccentColour,
          appbarcolour: AppbarColour,
          appbartitle: widget.appbartitle,
        ),
        body: ListView(
            children: [
              Center(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.only(
                        left:10,
                        right:10,
                    ),
                    width: double.infinity,
                    height: 550,
                    decoration: BoxDecoration(
                      color: AppbarColour,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        enableInteractiveSelection : true,
                        controller: _feedbackController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: 'Enter Feedback or Bugs',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 20) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Feedback is too short')));
                            return '';
                          }
                        },
                      ),
                    ),
                  )
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _postFeedback();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: WorkoutsAccentColour,
                    ),
                    child: Text(
                      _loading ? 'Posting...' : "Post",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
