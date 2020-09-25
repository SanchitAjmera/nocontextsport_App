import 'dart:math';

import 'package:flutter/material.dart';
import 'question_page.dart';
import 'board_view.dart';
import 'model.dart';

class HomePage extends StatefulWidget {

  List<String> names;

  //contructor enabling passing of name details
  HomePage({Key key, @required this.names}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState(names: names);
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  AnimationController _ctrl;
  Animation _ani;
  List<Luck> _items = [];
  var _value;
    // Luck("Sami", Colors.accents[0]),
    // Luck("Rajun", Colors.accents[2]),
    // Luck("Max", Colors.accents[4]),
    // Luck("Sanch", Colors.accents[6]),
    // Luck("Emir", Colors.accents[8]),
    // Luck("Ali", Colors.accents[10]),
//  ];
  List<String> names;

  _HomePageState({Key key, @required this.names});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // time duration of wheel spinning
    var _duration = Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);

    int accent = 0;
    for (String name in names){
      _items.add(Luck(name, Colors.accents[accent]));
      accent += 2;

    }
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
        child: AnimatedBuilder(
            animation: _ani,
            builder: (context, child) {
              // value is the future endpoint of the wheel
              _value = _ani.value;
              //print(_value);
              // angle is angle the wheel spins
              final _angle = _value * this._angle;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  BoardView(items: _items, current: _current, angle: _angle),
                  _buildGo(),
                  _buildResult(_value),
                ],
              );
            }),
      ),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.white,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: Text(
            "SPIN",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _animation,
      ),
    );
  }

_animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();
        print("stopped animating");
        navigateToHomePage(context);
        print("done popup");
      });
    }
  }

  int _calIndex(value) {
    // base is the index of the randomly chosen component
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }
  // function which outputs results at the bottom of the screen
  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    // items[index] refers to the chosen picture to display
    String _asset = _items[_index].asset;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: new Text(
          _asset,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        )//Image.asset(_asset, height: 80, width: 80),
      ),
    );
  }

  Future navigateToHomePage(context) async {
    var _index = _calIndex(_value * _angle + _current);
    Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionPage(name: _items[_index].asset)));
  }
}
