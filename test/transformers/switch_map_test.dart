import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * SwitchMap
 * 
 * 	주어진 매퍼 함수를 ​​사용하여 방출 된 각 항목을 Stream으로 변환합니다. 
 *  새로 생성 된 스트림은 항목을 수신하고 방출을 시작하며 이전에 생성 된 스트림은 방출을 중지합니다.
 *  switchMap 연산자는 flatMap 및 concatMap 메서드와 유사하지만 가장 최근에 생성 된 Stream에서만 항목을 내 보냅니다.
 *  예를 들어 비동기 API의 최신 상태 만 원할 때 유용 할 수 있습니다.
 */

main() {
  Stream<int> _getStream() {
    final controller = StreamController<int>();

    Timer(const Duration(milliseconds: 10), () => controller.add(1));
    Timer(const Duration(milliseconds: 20), () => controller.add(2));
    Timer(const Duration(milliseconds: 30), () => controller.add(3));
    Timer(const Duration(milliseconds: 40), () {
      controller.add(4);
      controller.close();
    });

    return controller.stream;
  }

  Stream<int> _getOtherStream(int value) {
    final controller = StreamController<int>();

    Timer(const Duration(milliseconds: 15), () => controller.add(value + 1));
    Timer(const Duration(milliseconds: 25), () => controller.add(value + 2));
    Timer(const Duration(milliseconds: 35), () => controller.add(value + 3));
    Timer(const Duration(milliseconds: 45), () {
      controller.add(value + 4);
      controller.close();
    });

    return controller.stream;
  }

  test('switchMap', () async {
    //given
    var a = _getStream();

    //when
    final result = a.switchMap(_getOtherStream);

    //then
    await expectLater(
      result,
      emitsInOrder(
        [5, 6, 7, 8],
      ),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('mapTo with Error', () async {
    //given
    var a = Rx.range(1, 4).concatWith([Stream<int>.error(Error())]);

    //when
    final result = a.mapTo(true);

    //then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[
        true,
        true,
        true,
        true,
        emitsError(TypeMatcher<Error>()),
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
