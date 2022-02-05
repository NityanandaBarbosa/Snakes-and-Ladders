import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final mapList = {
    99 : [[2, 1],[1, 3]],
    85 : [[6, 1],[6, 3]],
    92 : [[9, 1],[8, 2]],
    89 : [[9, 2],[8, 4]],
    74 : [[7, 3],[8, 5]],
    62 : [[2, 4],[2, 9]],
    64 : [[4, 4],[1, 5]],
    45 : [[6, 6],[5, 8]],
    49 : [[9, 6],[10, 9]],
    16 : [[5, 9],[6, 10]],
  };
  final snakesIndexs = [99,85, 92, 89,74, 62, 64, 45, 49, 16];
  
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
