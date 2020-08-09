import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * SkipUntil
 * 
 * 지정된 스트림이 항목을 방출 한 후에 만 ​​항목 방출을 시작합니다.
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

  test('skipUntil', () async {
    // given
    final a = _getStream();

    // when
    final result = a.skipUntil(_getOtherStream());

    // then
    await expectLater(result, emitsInOrder([3, 4]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
