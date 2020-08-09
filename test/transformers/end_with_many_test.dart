import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * EndWith
 * 
 * Stream닫기 전에 값 시퀀스를 최종 이벤트로 소스에 추가합니다 .
 * 
 */

main() {
  Stream<int> _getStream() => Stream.fromIterable(const [1, 2, 3, 4]);
  test('endWith', () async {
    // given
    final a = _getStream();

    // when
    final result = a.endWithMany([5, 6]);

    // then
    await expectLater(result, emitsInOrder([1, 2, 3, 4, 5, 6]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
