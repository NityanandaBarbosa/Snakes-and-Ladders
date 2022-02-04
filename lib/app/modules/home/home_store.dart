import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
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
