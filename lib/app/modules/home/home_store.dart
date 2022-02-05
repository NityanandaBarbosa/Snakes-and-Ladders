import 'package:mobx/mobx.dart';
import 'package:snakes_and_ladders/app/modules/home/model/SnakeModel.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final mapList = {
    99 : SnakeModel(topCoord: [2, 1],bottomCoord: [1, 3],bottomIndex: 80),
    85 : SnakeModel(topCoord: [6, 1],bottomCoord: [6, 3],bottomIndex: 77),
    92 : SnakeModel(topCoord: [9, 1],bottomCoord: [8, 2],bottomIndex: 88),
    89 : SnakeModel(topCoord: [9, 2],bottomCoord: [8, 4],bottomIndex: 68),
    74 : SnakeModel(topCoord: [7, 3],bottomCoord: [8, 5],bottomIndex: 53),
    62 : SnakeModel(topCoord: [2, 4],bottomCoord: [2, 9],bottomIndex: 19),
    64 : SnakeModel(topCoord: [4, 4],bottomCoord: [1, 5],bottomIndex: 60),
    45 : SnakeModel(topCoord: [6, 6],bottomCoord: [5, 8],bottomIndex: 25),
    49 : SnakeModel(topCoord: [9, 6],bottomCoord: [10, 9],bottomIndex: 11),
    16 : SnakeModel(topCoord: [5, 9],bottomCoord: [6, 10],bottomIndex: 6),
  };
  final snakesIndexs = [99, 85, 92, 89,74, 62, 64, 45, 49, 16];
  
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
