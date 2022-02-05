import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:snakes_and_ladders/app/modules/home/components/GameStep.dart';
import 'package:snakes_and_ladders/app/modules/home/components/LadderPainter.dart';
import 'package:snakes_and_ladders/app/modules/home/components/SnakePainter.dart';
import 'package:snakes_and_ladders/app/modules/home/entities/CobrasEscadas.dart';
import 'package:snakes_and_ladders/app/modules/home/home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  final dice = Modular.get<CobrasEscadas>();
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
        if (element == 1)
          runInAction(() {
            cardStep.isHidePlayer1.value = false;
            cardStep.isHidePlayer2.value = false;
          });
      });

      store.listIndex.forEach((element) {
        listOfStepChanged.add(listOfStep[element - 1]);
      });
    }

    if (listLines.isEmpty) {
      runInAction(() {
        store.snakesIndexs.forEach((element) {
          final top = Offset(
              (width * 0.085) * store.snakesMap[element].bottomCoord[0],
              (height * 0.048) * store.snakesMap[element].bottomCoord[1]);
          final bottom = Offset(
              (width * 0.083) * store.snakesMap[element].topCoord[0],
              (height * 0.045) * store.snakesMap[element].topCoord[1]);
          listLines.add(CustomPaint(
            foregroundPainter: SnakePainter(top: top, bottom: bottom),
          ));
        });
        store.ladderIndexs.forEach((element) {
          final top = Offset(
              (width * 0.085) * store.laddersMap[element].bottomCoord[0],
              (height * 0.048) * store.laddersMap[element].bottomCoord[1]);
          final bottom = Offset(
              (width * 0.083) * store.laddersMap[element].topCoord[0],
              (height * 0.045) * store.laddersMap[element].topCoord[1]);
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
                        child: Text(
                            "É a vez do jogador ${dice.isPlayer1.value ? "Azul" : "Laranja"}"),
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
      floatingActionButton: Observer(builder: (_) {
        return FloatingActionButton(
            child: Text("Jogar"),
            onPressed: !dice.isDicesBlocked.value
                ? (() async {
                    final sumDices = dice.jogar();
                    await movePlayer(sumDices);
                    runInAction(() {
                      dice.isDicesBlocked.value = false;
                      if(!dice.equalsDice.value)
                        dice.isPlayer1.value = !dice.isPlayer1.value;
                    });
                  })
                : null);
      }),
    );
  }

  Future<void> isSnakeHead(int index) async {
    final delay = Duration(milliseconds: 350);
    if (store.snakesMap[index] != null) {
      await Future.delayed(delay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = true;
            dice.player1Index.value = store.snakesMap[index].bottomIndex - 1;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = true;
            dice.player2Index.value = store.snakesMap[index].bottomIndex - 1;
          }
        });
      });
      await Future.delayed(delay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = false;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = false;
          }
        });
      });
    }
  }

  Future<void> isLadderBottom(int index) async {
    final delay = Duration(milliseconds: 350);
    if (store.laddersMap[index] != null) {
      await Future.delayed(delay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = true;
            dice.player1Index.value = store.laddersMap[index].topIndex - 1;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = true;
            dice.player2Index.value = store.laddersMap[index].topIndex - 1;
          }
        });
      });
      await Future.delayed(delay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = false;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = false;
          }
        });
      });
    }
  }

  Future<void> movePlayer(int sumDices) async {
    final delay = Duration(milliseconds: 350);
    int currentIndex = 0;
    for (int i = 0; i < sumDices; i++) {
      await Future.delayed(delay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = true;
            dice.player1Index.value++;
            currentIndex = dice.player1Index.value + 1;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = true;
            dice.player2Index.value++;
            currentIndex = dice.player2Index.value + 1;
          }
        });
      });
      await Future.delayed(delay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = false;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = false;
          }
        });
      });
    }
    await this.isLadderBottom(currentIndex);
    await this.isSnakeHead(currentIndex);
  }
}
