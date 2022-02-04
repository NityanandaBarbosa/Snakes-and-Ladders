import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:snakes_and_ladders/app/modules/home/components/GameStep.dart';
import 'package:snakes_and_ladders/app/modules/home/home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  final listOfStep = <GameStep>[];
  List<GameStep> listOfStepChanged = [];
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
    runInAction(() {
        listOfStep[80].isHidePlayer2.value = false;
      });

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
                  Flexible(
                      child: Wrap(
                    children: listOfStepChanged,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
