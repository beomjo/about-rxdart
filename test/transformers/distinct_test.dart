import 'package:flutter_test/flutter_test.dart';

/**
 * Distinct
 * 
 * 현재 스트림에서 중복을 제거합니다.
 * 
 */

main() {
  test('distinct', () async {
    // given
    final a = Stream.fromIterable(const [1, 1]);

    // when
    final result = a.distinct();

    // then
    await expectLater(result, emitsInOrder(<dynamic>[1, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
