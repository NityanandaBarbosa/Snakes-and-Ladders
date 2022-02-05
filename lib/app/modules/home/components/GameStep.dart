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
  bool colorGreen = false;
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    if (widget.index % 2 == 0) colorGreen = true;
    return Observer(builder: (__) {
      return Container(
        height: widget.height * 0.05,
        width: widget.width * 0.09,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            shape: BoxShape.rectangle,
            color: colorGreen ? Colors.green : Colors.white),
        child: Stack(
          children: [
             Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                  child: Padding(
                    padding:EdgeInsets.fromLTRB(2, 2, 0, 0),
                    child: Text(
                      "${widget.index}",
                    style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
                    ),
                  ),
              )),
            if (widget.index == 1)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.arrow_forward),
                ),
              )
              
            else if (widget.index == 100)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:EdgeInsets.fromLTRB(2, 2, 0, 0),
                    child: Icon(Icons.home),
                  ),
                ),
              ),
            if (widget.isHidePlayer1.value == false)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue.withOpacity(0.8),
                  ),
                ),
              ),
            if (widget.isHidePlayer2.value == false)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.orange.withOpacity(0.8),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
