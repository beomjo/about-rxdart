import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * SwitchLatestStream
 * 
 * 상위스트림에서 가장 최근 방출 된 스트림의 항목만을 방출하는 용도
 * 이 스트림은 소스 스트림에서 새 스트림이 방출 될 때 이전에 방출 된 스트림에서 구독을 취소합니다.
 * 
 * 상위스트림 ex) Stream.value(Stream.value())
 * 
 */

Stream<Stream<String>> get testStream => Stream.fromIterable([
      Rx.timer('A', Duration(seconds: 2)),
      Rx.timer('B', Duration(seconds: 1)),
      Stream.value('C'),
    ]);

Stream<Stream<String>> get errorStream => Stream.fromIterable([
      Rx.timer('A', Duration(seconds: 2)),
      Rx.timer('B', Duration(seconds: 1)),
      Stream.error(Exception()),
    ]);

main() {
  group('SwitchLatestStream', () {
    test('상위 스트림의에서 리스트데이터를 방출', () {
      // given
      var a = Stream.value(Stream.fromIterable(const ['A', 'B', 'C']));

      // when
      final stream = Rx.switchLatest(a);

      // then
      expect(
        stream,
        emitsInOrder(<dynamic>['A', 'B', 'C', emitsDone]),
      );
    }, timeout: Timeout(Duration(seconds: 5)));

    test('상위스트림의 가장 최근값이 먼저 방출되어야한다', () {
      // given

      // when
      final stream = Rx.switchLatest(testStream);

      // then
      expect(
        stream,
        emits('C'),
      );
    }, timeout: Timeout(Duration(seconds: 5)));

    test('상위 스트림에서 방출된 오류를 방출해야한다', () {
      // given
      var a = Stream<Stream<void>>.error(Exception());

      // when
      final stream = Rx.switchLatest(a);

      // then
      expect(
        stream,
        emitsError(isException),
      );
    }, timeout: Timeout(Duration(seconds: 5)));
    test('상위 스트림에서 방출된 오류를 방출해야한다2', () {
      // given

      // when
      final stream = Rx.switchLatest(errorStream);

      // then
      expect(
        stream,
        emitsError(isException),
      );
    }, timeout: Timeout(Duration(seconds: 5)));

    test('상위스트림에서 마지막 이벤트가 방출된 이후 이후에 닫혀야한다', () {
      // given

      // when
      final stream = Rx.switchLatest(testStream);

      // then
      expect(
        stream,
        emitsThrough(emitsDone),
      );
    }, timeout: Timeout(Duration(seconds: 5)));

    test('상위스트림에서 empty가 방출되면 닫혀야한다', () {
      // given
      var a = Stream<Stream<void>>.empty();

      // when
      final stream = Rx.switchLatest(a);

      // then
      expect(
        stream,
        emitsThrough(emitsDone),
      );
    }, timeout: Timeout(Duration(seconds: 5)));
  });
}
