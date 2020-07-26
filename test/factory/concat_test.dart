import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Concat
 * 
 * 이전 스트림 순서가 성공적으로 종료되는 한 지정된 모든 스트림 순서를 연결합니다.
 * 각 스트림을 하나씩 구독하여 모든 항목을 방출하고 다음 스트림을 구독하기 전에 완료하여이를 수행합니다.
 * 
 * ConcatEager
 * 이전 스트림 순서가 성공적으로 종료되는 한 지정된 모든 스트림 순서를 연결합니다.
 * 다음 스트림 이후에 하나의 스트림을 구독하지 않고 모든 스트림이 즉시 구독됩니다. 그런 다음 이전 스트림이 항목 방출을 완료 한 후 이벤트가 올바른 시간에 캡처되어 생성됩니다.
 * 
 * marble diagram https://rxmarbles.com/#concat
 */

main() {
  group('concat', () {
    test('0,1,2,3,4,5가 순서적으로 발행되야한다 emitsInOrder', () {
      // given
      var a = Stream.fromIterable([0, 1, 2]);
      var b = Stream.fromIterable([3, 4, 5]);

      // when
      final stream = Rx.concat([a, b]);

      // then
      expect(stream, emitsInOrder([0, 1, 2, 3, 4, 5]));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('0,1,2,3,4,5가 순서적으로 발행되야한다 expectAsync1', () {
      // given
      var a = Stream.fromIterable([0, 1, 2]);
      var b = Stream.fromIterable([3, 4, 5]);

      // when
      final stream = Rx.concat([a, b]);

      // then
      stream.listen(expectAsync1(
        (number) {
          expect(number, inInclusiveRange(0, 5));
        },
        count: 6,
      ));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('1,2,3이 순서적으로 발행되어야한다', () {
      // given
      var a = Stream.value(1);
      var b = TimerStream(2, Duration(seconds: 2));
      var c = Stream.value(3);

      // when
      final stream = Rx.concat([a, b, c]);

      // then
      expect(stream, emitsInOrder([1, 2, 3]));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('중간에 에러가 발생하면,에러를 제외한 스트림만 방출해야한다 ', () async {
      // given
      var count = 0;
      var a = Stream.value(1);
      var b = Stream<int>.error(Exception());
      var c = Stream.value(2);
      var expected = [1, 2];

      // when
      final streamWithError = Rx.concat([a, b, c]);

      // then
      streamWithError.listen(
        expectAsync1(
          (number) => expect(number, expected[count++]),
          count: 2,
        ),
        onError: expectAsync2(
          (Exception e, StackTrace s) => expect(e, isException),
        ),
      );
    });
  });

  group('concatEager', () {
    test('0,1,2,3,4,5가 순서적으로 발행되야한다 emitsInOrder', () {
      // given
      var a = Stream.fromIterable([0, 1, 2]);
      var b = Stream.fromIterable([3, 4, 5]);

      // when
      final stream = Rx.concatEager([a, b]);

      // then
      expect(stream, emitsInOrder([0, 1, 2, 3, 4, 5]));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('0,1,2,3,4,5가 순서적으로 발행되야한다 expectAsync1', () {
      // given
      var a = Stream.fromIterable([0, 1, 2]);
      var b = Stream.fromIterable([3, 4, 5]);

      // when
      final stream = Rx.concatEager([a, b]);

      // then
      stream.listen(expectAsync1(
        (number) {
          expect(number, inInclusiveRange(0, 5));
        },
        count: 6,
      ));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('1,2,3이 순서적으로 발행되어야한다', () {
      // given
      var a = Stream.value(1);
      var b = TimerStream(2, Duration(seconds: 2));
      var c = Stream.value(3);

      // when
      final stream = Rx.concatEager([a, b, c]);

      // then
      expect(stream, emitsInOrder([1, 2, 3]));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('중간에 에러가 발생하면,에러를 제외한 스트림만 방출해야한다 ', () async {
      // given
      var count = 0;
      var a = Stream.value(1);
      var b = Stream<int>.error(Exception());
      var c = Stream.value(2);
      var expected = [1, 2];

      // when
      final streamWithError = Rx.concatEager([a, b, c]);

      // then
      streamWithError.listen(
        expectAsync1(
          (number) => expect(number, expected[count++]),
          count: 2,
        ),
        onError: expectAsync2(
          (Exception e, StackTrace s) => expect(e, isException),
        ),
      );
    });
  });
}
