import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * TakeUntil
 * 
 * 다른 Stream 시퀀스가 ​​값을 생성 할 때까지만
 * 소스 Stream 시퀀스의 값을 반환합니다.
 */

main() {
  Stream<int> _getStream() {
    final controller = StreamController<int>();

    Timer(const Duration(milliseconds: 100), () => controller.add(1));
    Timer(const Duration(milliseconds: 200), () => controller.add(2));
    Timer(const Duration(milliseconds: 300), () => controller.add(3));
    Timer(const Duration(milliseconds: 400), () {
      controller.add(4);
      controller.close();
    });

    return controller.stream;
  }

  Stream<int> _getOtherStream() {
    final controller = StreamController<int>();

    Timer(const Duration(milliseconds: 250), () {
      controller.add(1);
      controller.close();
    });

    return controller.stream;
  }

  test('다른스트림의 값이 방출될때까지만, 소스스트림의 값들을 방출해야한다', () async {
    // given
    final a = _getStream();

    // when
    final result = a.takeUntil(_getOtherStream());

    // then
    await expectLater(result, emitsInOrder([1, 2]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
