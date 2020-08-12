import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * EndWith
 * 
 * 소스스트림이 값을 방출한후, 방출한값 뒤에 값을 추가합니다 
 * 
 */

main() {
  Stream<int> _getStream() => Stream.fromIterable(const [1, 2, 3, 4]);
  test('소스트림이 값을 방출한후 ,5을 추가해야한다', () async {
    // given
    final a = _getStream();

    // when
    final result = a.endWith(5);

    // then
    await expectLater(result, emitsInOrder([1, 2, 3, 4, 5]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
