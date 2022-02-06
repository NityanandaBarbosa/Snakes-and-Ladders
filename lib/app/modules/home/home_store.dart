import 'package:mobx/mobx.dart';
import 'package:snakes_and_ladders/app/modules/home/entities/CobrasEscadas.dart';
import 'package:snakes_and_ladders/app/modules/home/entities/game_trap.dart';
import 'package:snakes_and_ladders/app/modules/home/model/LadderModel.dart';
import 'package:snakes_and_ladders/app/modules/home/model/SnakeModel.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  
  final trap = Observable<GameTrap>(GameTrap(message: "initGame"));

  final snakesMap = {
    99: SnakeModel(topCoord: [2, 1], bottomCoord: [1, 3], bottomIndex: 80),
    95: SnakeModel(topCoord: [6, 1], bottomCoord: [6, 3], bottomIndex: 75),
    92: SnakeModel(topCoord: [9, 1], bottomCoord: [8, 2], bottomIndex: 88),
    89: SnakeModel(topCoord: [9, 2], bottomCoord: [8, 4], bottomIndex: 68),
    74: SnakeModel(topCoord: [7, 3], bottomCoord: [8, 5], bottomIndex: 53),
    62: SnakeModel(topCoord: [2, 4], bottomCoord: [2, 9], bottomIndex: 19),
    64: SnakeModel(topCoord: [4, 4], bottomCoord: [1, 5], bottomIndex: 60),
    46: SnakeModel(topCoord: [6, 6], bottomCoord: [5, 8], bottomIndex: 25),
    49: SnakeModel(topCoord: [9, 6], bottomCoord: [10, 9], bottomIndex: 11),
    16: SnakeModel(topCoord: [5, 9], bottomCoord: [6, 10], bottomIndex: 6),
  };
  final snakesIndexs = [99, 95, 92, 89, 74, 62, 64, 46, 49, 16];

  final laddersMap = {
    87: LadderModel(topCoord: [7, 2], bottomCoord: [7, 1], topIndex: 94), //ok
    78: LadderModel(topCoord: [3, 1], bottomCoord: [3, 3], topIndex: 98), //ok
    71: LadderModel(topCoord: [10, 1], bottomCoord: [10, 3], topIndex: 91), //ok
    51: LadderModel(topCoord: [7, 4], bottomCoord: [10, 5], topIndex: 67), //ok
    36: LadderModel(topCoord: [4, 6], bottomCoord: [5, 7], topIndex: 44), //ok
    21: LadderModel(topCoord: [2, 6], bottomCoord: [1, 8], topIndex: 42), //ok
    28: LadderModel(topCoord: [4, 2], bottomCoord: [8, 8], topIndex: 84), //ok
    15: LadderModel(topCoord: [6, 8], bottomCoord: [6, 9], topIndex: 26), //ok
    2: LadderModel(topCoord: [3, 7], bottomCoord: [2, 10], topIndex: 38), //ok
    7: LadderModel(topCoord: [7, 9], bottomCoord: [7, 10], topIndex: 14), //ok
    8: LadderModel(topCoord: [10, 7], bottomCoord: [8, 10], topIndex: 31),
  };
  final ladderIndexs = [87, 78, 71, 51, 36, 21, 28, 15, 2, 7, 8];

  List<int> listIndex = [];
  List<int> listOfIndexSorted = [];

  void addIndexs() {
    for (int i = 10; i >= 1; i--) {
      if (i == 1) {
        for (int j = 1; j < 11; j++) {
          listIndex.add(j);
        }
      } else {
        if (i % 2 == 0) {
          for (int j = (i * 10) + 1; j != ((i + 1) * 10) + 1; j++) {
            if (j <= 100) {
              listIndex.add(j);
            }
          }
          for (int j = (i * 10); j > (i - 1) * 10; j--) {
            listIndex.add(j);
          }
        }
      }
    }
    for (int i = 1; i < 101; i++) {
      listOfIndexSorted.add(i);
    }
  }
}
