import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * Repeat
 * 
 * Stream 이 성공적으로 종료 될 때까지 지정된 횟수만큼 소스 스트림을 재생성하고 다시 수신 할 Stream 을 만듭니다 .
 */

main() {
  Stream<String> Function(int) _getRepeatStream(String symbol) =>
      (int repeatIndex) async* {
        yield await Future.delayed(
          const Duration(milliseconds: 20),
          () => '$symbol$repeatIndex',
        );
      };

  Stream<String> Function(int) _getErroneusRepeatStream(String symbol) =>
      (int repeatIndex) {
        return Stream.value('A0')
            // Emit the error
            .concatWith([Stream<String>.error(Error())]);
      };

  test('repeat', () async {
    // given
    const repeatCount = 3;
    var a = _getRepeatStream('A');

    // when
    final stream = Rx.repeat(a, repeatCount);

    // then
    await expectLater(
      stream,
      emitsInOrder(<dynamic>['A0', 'A1', 'A2', emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('repeat stream', () async {
    // given
    const repeatCount = 3;
    var a = _getRepeatStream('A');

    // when
    final stream = RepeatStream(a, repeatCount);

    // then
    await expectLater(
      stream,
      emitsInOrder(<dynamic>['A0', 'A1', 'A2', emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('도중 에러가 발생하여도 지정된 횟수를 반복해야한다', () async {
    // given
    const repeatCount = 2;
    var a = _getErroneusRepeatStream('A');

    // when
    final streamWithError = RepeatStream(a, repeatCount);

    // then
    await expectLater(
        streamWithError,
        emitsInOrder(<dynamic>[
          'A0',
          emitsError(TypeMatcher<Error>()),
          'A0',
          emitsError(TypeMatcher<Error>()),
          emitsDone
        ]));
  });
}
