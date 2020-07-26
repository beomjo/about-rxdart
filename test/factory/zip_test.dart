import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * Zip
 * 
 * 모든 스트림 시퀀스가 ​​해당 최소 1개씩값을 방출할때마다 
 * 지정된 지퍼 함수를 ​​사용하여 지정된 스트림을 하나의 스트림 시퀀스로 병합합니다.
 * 
 * marble diagram https://rxmarbles.com/#zip
 */

main() {
  test('Zip', () async {
    // given
    var a = Stream.fromIterable(['A']),
        b = Stream.fromIterable(['B']),
        c = Stream.fromIterable(['C', 'D']);

    // when
    final stream = ZipStream([a, b, c], (values) => values);

    // then
    await expectLater(
        stream,
        emitsInOrder([
          ['A', 'B', 'C'],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('Zip N개의(특정수의) 스트림 존재', () async {
    // given
    var a = Stream.fromIterable(['1']), b = Stream.fromIterable(['2', '3']);

    // when
    final stream = ZipStream.zip2(a, b, (a, b) => a + b);

    // then
    await expectLater(stream, emitsInOrder(['12', emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('Zip 스트림중 에러가 포함되어있으면 에러를 방출한다', () async {
    // given
    var a = Stream.value(1),
        b = Stream.value(1),
        c = Stream<int>.error(Exception());

    // when
    final stream = ZipStream.zip3(a, b, c, (a, b, c) => a + b + c);

    // then
    await expectLater(stream, emitsError(TypeMatcher<Exception>()));
  }, timeout: Timeout(Duration(seconds: 5)));
}
