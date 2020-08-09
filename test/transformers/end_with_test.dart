import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * EndWith
 * 
 * Stream닫기 전에 소스에 값을 추가합니다 .
 * 
 */

main() {
  Stream<int> _getStream() => Stream.fromIterable(const [1, 2, 3, 4]);
  test('endWith', () async {
    // given
    final a = _getStream();

    // when
    final result = a.endWith(5);

    // then
    await expectLater(result, emitsInOrder([1, 2, 3, 4, 5]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
