import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * CombineLatest
 * 
 * 소스 스트림 시퀀스 중 하나가 항목을 방출 할 때마다 결합하여
 * 스트림을 하나의 스트림 시퀀스로 병합합니다.
 * 모든 스트림이 하나 이상의 아이템을 방출 할 때까지 스트림이 방출되지 않습니다.
 * 
 * marble diagram https://rxmarbles.com/#combineLatest
 */

main() {
  test('CombineLatest list', () async {
    // given
    var a = Stream.fromIterable(['a']),
        b = Stream.fromIterable(['b']),
        c = Stream.fromIterable(['C', 'D']);

    // when
    final stream = CombineLatestStream.list<String>([a, b, c]);

    // then
    await expectLater(
        stream,
        emitsInOrder([
          ['a', 'b', 'C'],
          ['a', 'b', 'D'],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('CombineLatest 결합 조건 추가', () async {
    // given
    var a = Stream.fromIterable(['a']),
        b = Stream.fromIterable(['b']),
        c = Stream.fromIterable(['C', 'D']);

    // when
    final stream =
        CombineLatestStream([a, b, c], (List<String> values) => values.last);

    // then
    await expectLater(stream, emitsInOrder(['C', 'D', emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('CombineLatest N개의(특정수의) 스트림 존재', () async {
    // given
    var a = Stream.fromIterable(['1']), b = Stream.fromIterable(['2', '3']);

    // when
    final stream = CombineLatestStream.combine2(a, b, (a, b) => a + b);

    // then
    await expectLater(stream, emitsInOrder(['12', '13', emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('CombineLatest 스트림중 에러가 포함되어있으면 에러를 방출한다', () async {
    // given
    var a = Stream.value(1),
        b = Stream.value(1),
        c = Stream<int>.error(Exception());

    // when
    final stream =
        CombineLatestStream.combine3(a, b, c, (a, b, c) => a + b + c);

    // then
    await expectLater(stream, emitsError(TypeMatcher<Exception>()));
  }, timeout: Timeout(Duration(seconds: 5)));
}
