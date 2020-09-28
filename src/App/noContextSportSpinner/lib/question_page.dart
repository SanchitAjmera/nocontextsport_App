import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'main.dart';
import 'board_view.dart';
import 'model.dart';
import 'questions.dart';
import 'home_page.dart';
import 'dart:async';
import 'dart:io';
import 'truth_page.dart';

class QuestionPage extends StatefulWidget {

  String name;
  List<String> names;

  //contructor enabling passing of name details
  QuestionPage({Key key, @required this.name, @required this.names}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionPageState(name, names);
  }
}

class _QuestionPageState extends State<QuestionPage>
    with SingleTickerProviderStateMixin {

  String name;
  Questions questions = new Questions();
  List<int> ordering = null;
  List<String> names;
  Map<String, bool> question = null;
  Color _colorContainer1 = Colors.white;
  Color _colorContainer2 = Colors.white;
  Color _colorContainer3 = Colors.white;

  static int DELAY = 1;

  _QuestionPageState(String name, List<String> names){
    this.name  = name;
    this.names = names;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.pinkAccent[400].withOpacity(0.8), Colors.deepOrangeAccent[400].withOpacity(0.7)])),
        child: Center(
          child: new AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 200,
                  child: new Text(getQuestion().keys.toList()[0]),
                ),
                InkWell(
                  child: Container(
                    width: 300,
                    height: 70,
                    color: _colorContainer1,
                    child: new Text(getQuestion().keys.toList()[getOrdering()[0]]),
                  ),
                  onTap: () {
                    setState(() {
                      _colorContainer1 = question.values.toList()[getOrdering()[0]] ?
                            Colors.green :
                            Colors.red;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    width: 300,
                    height: 70,
                    color: _colorContainer2,
                    child: new Text(getQuestion().keys.toList()[getOrdering()[1]]),
                  ),
                  onTap: () {
                    bool res = question.values.toList()[getOrdering()[1]];
                    setState(() {
                      _colorContainer2 = res ? Colors.green : Colors.red;
                    });
                    if (res){
                      Future.delayed(Duration(seconds: DELAY), () {
                        Navigator.pop(context);
                      });
                    } else {
                      Future.delayed(Duration(seconds: DELAY), () {
                        navigateToTruth(context);
                      });
                    }
                  },
                ),
                InkWell(
                  child: Container(
                    width: 300,
                    height: 70,
                    color: _colorContainer3,
                    child: new Text(getQuestion().keys.toList()[getOrdering()[2]]),
                  ),
                  onTap: () {
                    setState(() {
                      _colorContainer3 = question.values.toList()[getOrdering()[2]] ?
                            Colors.green :
                            Colors.red;
                    });
                  },
                ),
              ]
            )
          ),
        ),
      ),
    );
  }

  Map<String, bool> getQuestion(){
    if (question == null){
      question = questions.getQuestion();
    }
    return question;
  }

  List<int> getOrdering(){
    if (ordering == null){
      ordering = questions.getOrdering();
    }
    return ordering;
  }

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  Future navigateToTruth(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TruthPage(name: name, names: names)));
  }
}
