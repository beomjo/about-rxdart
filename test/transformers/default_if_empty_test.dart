import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * DefaultIfEmpty
 * 
 * 소스 스트림에서 항목을 내보내거나 소스 스트림에서 아무것도 내 보내지 않는 경우 단일 기본 항목을 내 보냅니다.
 * 
 */

main() {
  test('소스스트림이 값을 방출하지 않았을때, default값(true_를 내보내야한다', () async {
    // given
    var a = Stream<bool>.empty();

    // when
    final result = a.defaultIfEmpty(true);

    // then
    await expectLater(result, emitsInOrder(<dynamic>[true, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('소스스트림이 값을 방출했을때, default값을 내보내지않아야한다', () async {
    // given
    var a = Stream.fromIterable(const [false, false, false]);

    // when
    final result = a.defaultIfEmpty(true);

    // then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[false, false, false, emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
