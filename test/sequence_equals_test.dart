import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * SequenceEqual
 * 
 * 두 스트림이 동일한 순서의 항목을 방출하는지 확인합니다. 등식을 결정하기 위해 선택적인 등호 처리기를 제공 할 수 있습니다.
 * 
 * marble diagram https://rxmarbles.com/#sequenceEqual
 */

main() {
  group('SequenceEqual', () {
    test('SequenceEqual 두 스트림이 같아야한다', () {
      // given
      var a = Stream.fromIterable([0, 1, 2, 3, 4]);
      var b = Stream.fromIterable([0, 1, 2, 3, 4]);

      // when
      final stream = Rx.sequenceEqual(a, b);

      // then
      expect(stream, emitsInOrder([true]));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('SequenceEqualStream 두 스트림이 같아야한다', () {
      // given
      var a = Stream.fromIterable([0, 1, 2, 3, 4]);
      var b = Stream.fromIterable([0, 1, 2, 3, 4]);

      // when
      final stream = SequenceEqualStream(a, b);

      // then
      expect(stream, emitsInOrder([true]));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('시간차가 있어도 두스트림이 같은지 비교해야한다', () {
      // given
      var a = Stream.periodic(const Duration(milliseconds: 100), (i) => i + 1)
          .take(5);
      var b = Stream.fromIterable(const [1, 2, 3, 4, 5]);

      // when
      final stream = Rx.sequenceEqual(a, b);

      // then
      expect(stream, emitsInOrder([true]));
    }, timeout: Timeout(Duration(seconds: 5)));

    test('비교 조건을 커스텀하여 항상 true일때 비교값은 true이다', () {
      // given
      var a = Stream.fromIterable(const [1, 1, 1, 1, 1]);
      var b = Stream.fromIterable(const [2, 2, 2, 2, 2]);

      // when
      final stream = Rx.sequenceEqual(a, b, equals: (int a, int b) => true);

      // then
      expect(stream, emitsInOrder([true]));
    }, timeout: Timeout(Duration(seconds: 5)));
  });

  test('비교하여 같지않아야한다', () async {
    // given
    var a = Stream.fromIterable(const [1, 1, 1, 1, 1]);
    var b = Stream.fromIterable(const [2, 2, 2, 2, 2]);

    // when
    final stream = Rx.sequenceEqual(a, b);

    // then
    expect(stream, emitsInOrder([false]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('에러가 같은지 비교해야한다', () async {
    // given
    var a = Stream<void>.error(ArgumentError('error A'));
    var b = Stream<void>.error(ArgumentError('error A'));

    // when
    final stream = Rx.sequenceEqual(a, b);

    // then
    expect(stream, emitsInOrder([true]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('에러가 같은지 비교하여 달라야한다', () async {
    // given
    var a = Stream<void>.error(ArgumentError('error A'));
    var b = Stream<void>.error(ArgumentError('error B'));

    // when
    final stream = Rx.sequenceEqual(a, b);

    // then
    expect(stream, emitsInOrder([false]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
