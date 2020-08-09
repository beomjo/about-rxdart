import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * ZipWith
 * 
 * 주어진 지퍼 함수를 ​​사용하여 현재 스트림을 다른 스트림과 결합하는 Stream을 반환합니다.
 */

main() {
  test('WhereType', () async {
    // given
    final a = Stream<int>.value(1);

    // when
    final result =
        a.zipWith(Stream<int>.value(2), (int one, int two) => one + two);

    // then
    await expectLater(result, emitsInOrder([3]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
