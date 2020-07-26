import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Retry
 * 
 * Stream이 성공적으로 종료 될 때까지 지정된 횟수만큼 소스 스트림을 재생성하고 다시 수신 할 Stream 을 만듭니다 .
 * 재시도 횟수를 지정하지 않으면 무기한 재 시도합니다. 재시도 횟수에 도달 했지만 스트림이 성공적으로 종료되지 않은 경우 RetryError 가 발생합니다.
 *  RetryError에는 오류를 일으킨 모든 오류 및 StackTrace가 포함됩니다.
 * 
 */

main() {
  Stream<int> Function() _getRetryStream(int failCount) {
    var count = 0;

    return () {
      if (count < failCount) {
        count++;
        return Stream<int>.error(Error(), StackTrace.fromString('S'));
      } else {
        return Stream.value(1);
      }
    };
  }

  test('retry', () async {
    // given
    const retries = 3;
    var a = _getRetryStream(retries);

    // when
    final stream = Rx.retry(a, retries);

    await expectLater(
      stream,
      emitsInOrder(<dynamic>[1, emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('retry stream', () async {
    // given
    const retries = 3;
    var a = _getRetryStream(retries);

    // when
    final stream = Rx.retry(a, retries);

    await expectLater(
      stream,
      emitsInOrder(<dynamic>[1, emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('무한 재시도해야한다', () async {
    // given
    const retries = 1000;
    var a = _getRetryStream(retries);

    // when
    final stream = Rx.retry(a);

    await expectLater(
      stream,
      emitsInOrder(<dynamic>[1, emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
