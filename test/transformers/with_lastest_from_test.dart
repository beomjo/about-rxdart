import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * WithLatestFrom
 * 
 * 소스 Stream을 다른 Stream에서 마지막으로 내 보낸 항목과 병합하는 기능으로 Stream 클래스를 확장합니다
 * (두 Stream중 첫번째 Stream에서 아이템이 방출될 때마다 그 아이템을 두번째 Stream의 가장 최근 아이템과 결합해 방출합니다.)
 * 
 * marble diagram https://rxjs-dev.firebaseapp.com/api/operators/withLatestFrom
 */

main() {
  List<Stream<int>> _createTestStreams() {
    const intervals = [22, 50, 30, 40, 60];
    final ticker =
        Stream<int>.periodic(const Duration(milliseconds: 1), (index) => index)
            .skip(1)
            .take(300)
            .asBroadcastStream();
			 // 1~300
			

    return [
      ticker
          .where((index) => index % intervals[0] == 0) //22 ,44 ,66 ....
          .map((index) => index ~/ intervals[0] - 1), //1  ,2 , 3  ...
      ticker
          .where((index) => index % intervals[1] == 0) //50, 100, 150....
          .map((index) => index ~/ intervals[1] - 1), //1 , 2, 3 ...
      ticker
          .where((index) => index % intervals[2] == 0) //30, 60, 90....
          .map((index) => index ~/ intervals[2] - 1), //1 , 2, 3 ...
      ticker
          .where((index) => index % intervals[3] == 0) //40, 80, 120...
          .map((index) => index ~/ intervals[3] - 1), //1 , 2, 3 ...
      ticker
          .where((index) => index % intervals[4] == 0) //60, 120, 180...
          .map((index) => index ~/ intervals[4] - 1) //1 , 2, 3 ...
    ];

	// 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4.....
  }

  test('withLatestFrom', () async {
    // given
    final a = _createTestStreams();

    // when
    final result = a.first
        .withLatestFrom(a[1], (first, int second) => Pair(first, second))
        .take(5);

    // then

    await expectLater(
      result,
      emitsInOrder(
        [
          Pair(2, 0),
          Pair(3, 0),
          Pair(4, 1),
          Pair(5, 1),
          Pair(6, 2),
        ],
      ),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}

class Pair {
  final int first;
  final int second;

  const Pair(this.first, this.second);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Pair && first == other.first && second == other.second;
  }

  @override
  int get hashCode {
    return first.hashCode ^ second.hashCode;
  }

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}
