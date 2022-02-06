import 'dart:math';

import 'package:mobx/mobx.dart';

class CobrasEscadas {
  final isPlayer1 = Observable<bool>(true);
  final equalsDice = Observable<bool>(false);
  final isDicesBlocked = Observable<bool>(false);
  final player1Index = Observable<int>(0);
  final player2Index = Observable<int>(0);
  final dicesResultLabel = Observable<String>("");

  int jogar() {
    Random random = Random();
    int dado1 = random.nextInt(6) + 1;
    int dado2 = random.nextInt(6) + 1;
    runInAction(() {
      isDicesBlocked.value = true;
      equalsDice.value = false;
      if (dado1 == dado2) equalsDice.value = true;
      dicesResultLabel.value = "Dado1 : $dado1 | Dado2 : $dado2 | Soma : ${dado1+dado2}";
    });
    print("soma $dado1 + $dado2");
    return dado1 + dado2;
  }
}
