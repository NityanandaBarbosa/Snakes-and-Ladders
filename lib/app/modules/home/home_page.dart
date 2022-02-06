import 'package:edge_alerts/edge_alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:snakes_and_ladders/app/modules/home/components/GameStep.dart';
import 'package:snakes_and_ladders/app/modules/home/components/LadderPainter.dart';
import 'package:snakes_and_ladders/app/modules/home/components/SnakePainter.dart';
import 'package:snakes_and_ladders/app/modules/home/entities/CobrasEscadas.dart';
import 'package:snakes_and_ladders/app/modules/home/entities/game_trap.dart';
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
  final snakeAndLadderDelay = Duration(milliseconds: 1500);
  final playerDelay = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    reaction((_) => store.trap.value, (_) {
      edgeAlert(context,
          title: store.trap.value.type,
          description: store.trap.value.message,
          duration: 1,
          icon: Icons.error,
          gravity: Gravity.top,
          backgroundColor: Colors.blue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    initGame(height, width);

    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(color: AppColors.getColor.dellBlueOrYellow),
        backgroundColor: Colors.grey.withOpacity(0.005),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Observer(
          builder: (context) => Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  messageShow(height, width),
                  Stack(
                    children: [
                      Wrap(children: listOfStepChanged),
                      if (showLines.value == true) ...listLines
                    ],
                  ),
                  dicesResult(width)
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Observer(builder: (_) {
        return FloatingActionButton(
            child: Text("Jogar"),
            onPressed: !dice.hasWinner.value
                ? !dice.isDicesBlocked.value
                    ? (() async {
                        await movePlayer(dice.jogar());
                        runInAction(() {
                          dice.isDicesBlocked.value = false;
                          if (!dice.equalsDice.value)
                            if(!dice.hasWinner.value)
                              dice.isPlayer1.value = !dice.isPlayer1.value;
                        });
                      })
                    : null
                : (() {
                    store.endGame(dice);
                  }));
      }),
    );
  }

  void initGame(height, width) {
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
        showLines.value = true;
      });
    }
  }

  Widget messageShow(height, width) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      height: height * 0.13,
      width: width * 0.51,
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Center(
            child: Text(!dice.hasWinner.value
                ? "${dice.equalsDice.value && !dice.isDicesBlocked.value ? "Jogue novamente" : "É a vez do jogador"} ${dice.isPlayer1.value ? "Azul" : "Laranja"}"
                : "Jogador ${dice.isPlayer1.value ? "Azul" : "Laranja"} Venceu!"),
          ),
        ),
      ),
    );
  }

  Widget dicesResult(width) {
    return Wrap(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: dice.dicesPlayer1ResultLabel.value.isNotEmpty,
          child: Container(
            width: width * 0.75,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Azul - ${dice.dicesPlayer1ResultLabel.value}"),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: dice.dicesPlayer2ResultLabel.value.isNotEmpty,
          child: Container(
            width: width * 0.75,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child:
                      Text("Laranja - ${dice.dicesPlayer2ResultLabel.value}"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> isSnakeHead(int index) async {
    if (store.snakesMap[index] != null) {
      runInAction(() {
        store.trap.value = GameTrap(
            message:
                "O jogador parou na cabeça de um cobra! Será movido para casa ${store.snakesMap[index].bottomIndex}",
            type: "Cobra");
      });
      await Future.delayed(snakeAndLadderDelay, () {
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
      await Future.delayed(snakeAndLadderDelay, () {
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
    if (store.laddersMap[index] != null) {
      runInAction(() {
        store.trap.value = GameTrap(
            message:
                "O jogador parou em um escada! Será movido para casa ${store.laddersMap[index].topIndex}",
            type: "Escada");
      });
      await Future.delayed(snakeAndLadderDelay, () {
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
      await Future.delayed(snakeAndLadderDelay, () {
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
    bool goBack = false;
    int currentIndex = 0;
    for (int i = 0; i < sumDices; i++) {
      if (currentIndex >= 100) goBack = true;
      await Future.delayed(playerDelay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = true;
            !goBack ? dice.player1Index.value++ : dice.player1Index.value -= 1;
            currentIndex = dice.player1Index.value + 1;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = true;
            !goBack ? dice.player2Index.value++ : dice.player2Index.value -= 1;
            currentIndex = dice.player2Index.value + 1;
          }
        });
      });
      await Future.delayed(playerDelay, () {
        runInAction(() {
          if (dice.isPlayer1.value) {
            listOfStep[dice.player1Index.value].isHidePlayer1.value = false;
          } else {
            listOfStep[dice.player2Index.value].isHidePlayer2.value = false;
          }
        });
      });
    }
    if (dice.player1Index.value == 99 || dice.player2Index.value == 99) {
      runInAction(() {
        dice.hasWinner.value = true;
      });
    }
    await this.isLadderBottom(currentIndex);
    await this.isSnakeHead(currentIndex);
  }
}
