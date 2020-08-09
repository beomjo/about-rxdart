import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * StartWith
 * 
 * 소스 앞에 값을 추가합니다 Stream.
 */

main() {
  Stream<int> _getStream() => Stream.fromIterable(const [1, 2, 3, 4]);
  test('startWith', () async {
    // given
    final a = _getStream();

    // when
    final result = a.startWith(0);

    // then
    await expectLater(result, emitsInOrder([0, 1, 2, 3, 4]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
