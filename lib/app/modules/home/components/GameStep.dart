import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class GameStep extends StatefulWidget {
  final double width;
  final double height;
  final int index;
  final isHidePlayer1 = Observable<bool>(true);
  final isHidePlayer2 = Observable<bool>(true);
  GameStep({this.width, this.height, this.index});

  @override
  _GameStepState createState() => _GameStepState();
}

class _GameStepState extends State<GameStep> {
  bool showIndex = true;
  bool colorGreen = false;
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    if ((widget.index == 1) || (widget.index == 100)) showIndex = false;
    if (widget.index % 2 == 0) colorGreen = true;
    return Observer(builder: (__) {
      return Stack(
        children: [
          Container(
            height: widget.height * 0.05,
            width: widget.width * 0.09,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                shape: BoxShape.rectangle,
                color: colorGreen ? Colors.green : Colors.white),
            child: Center(
              child: Text(showIndex ? "${widget.index}" : ""),
            ),
          ),
          if (widget.index == 1)
            Icon(Icons.arrow_forward)
          else if (widget.index == 100)
            Icon(Icons.home),
          if (widget.isHidePlayer1.value == false)
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.blue.withOpacity(0.8),
            ),
          if (widget.isHidePlayer2.value == false)
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.orange.withOpacity(0.8),
            ),
        ],
      );
    });
  }
}
