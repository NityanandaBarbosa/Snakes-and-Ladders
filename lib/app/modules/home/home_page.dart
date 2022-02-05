import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:snakes_and_ladders/app/modules/home/components/GameStep.dart';
import 'package:snakes_and_ladders/app/modules/home/components/LadderPainter.dart';
import 'package:snakes_and_ladders/app/modules/home/components/SnakePainter.dart';
import 'package:snakes_and_ladders/app/modules/home/home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  final listOfStep = <GameStep>[];
  List<Widget> listOfStepChanged = [];
  final listLines = <Widget>[];
  final showLines = Observable<bool>(false);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (store.listIndex.isEmpty) {
      store.addIndexs();
      store.listOfIndexSorted.forEach((element) {
        final cardStep = GameStep(
          height: height,
          width: width,
          index: element,
        );
        listOfStep.add(cardStep);
      });

      store.listIndex.forEach((element) {
        listOfStepChanged.add(listOfStep[element - 1]);
      });
    }

    if (listLines.isEmpty) {
      runInAction(() {
        store.snakesIndexs.forEach((element) {
          final top = Offset((width * 0.085) * store.snakesMap[element].bottomCoord[0], (height * 0.048) * store.snakesMap[element].bottomCoord[1]);
          final bottom = Offset((width * 0.083) * store.snakesMap[element].topCoord[0], (height * 0.045) * store.snakesMap[element].topCoord[1]);
          listLines.add(CustomPaint(
            foregroundPainter: SnakePainter(top: top, bottom: bottom),
          ));
        });
        store.ladderIndexs.forEach((element) {
          final top = Offset((width * 0.085) * store.laddersMap[element].bottomCoord[0], (height * 0.048) * store.laddersMap[element].bottomCoord[1]);
          final bottom = Offset((width * 0.083) * store.laddersMap[element].topCoord[0], (height * 0.045) * store.laddersMap[element].topCoord[1]);
          listLines.add(CustomPaint(
            foregroundPainter: LadderPainter(top: top, bottom: bottom),
          ));
        });
        print("List of lines size : ${listLines.length}");
        showLines.value = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Snakes and Ladders'),
      ),
      body: SafeArea(
        child: Observer(
          builder: (context) => Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    height: height * 0.1,
                    width: width * 0.5,
                    child: Card(
                      child: Center(
                        child: Text("Inciar Jogo"),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Wrap(children: listOfStepChanged),
                      if (showLines.value == true) ...listLines
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
