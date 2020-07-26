import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Defer
 * 
 * 지연 팩토리는 옵저버가 구독 할 때까지 기다린 다음 지정된 팩토리 기능으로 스트림 을 만듭니다 .
 * 경우에 따라 스트림을 생성하기 위해 마지막 순간까지 (즉 구독 시간까지) 대기하면이 스트림에 최신 데이터가 포함됩니다.
 * 기본적으로 DeferStreams는 단일 구독입니다. 그러나 재사용 할 수 있습니다.
 */

main() {
  test('defer', () {
    // given
    var a = Stream.value(1);

    // when
    final stream = Rx.defer(() => a);

    // then
    stream.listen(expectAsync1(
      (value) {
        expect(value, 1);
      },
      count: 1,
    ));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('defer는 기본적으로 단일구독이므로, 여러번 구독햇을때 실패해야한다', () {
    // given
    var a = Stream.value(1);

    // when
    final stream = Rx.defer(() => a);

    // then
    try {
      stream.listen(null);
      stream.listen(null);
      expect(true, false);
    } catch (e) {
      // 'Bad state: Stream has already been listened to.'
      expect(e, isStateError);
    }
  }, timeout: Timeout(Duration(seconds: 5)));

  test('reusable이 true일때 defer는 재사용 가능해야한다', () {
    // given
    const value = 1;

    // when
    final stream = Rx.defer(
      () => Stream.fromFuture(
        Future.delayed(
          Duration(seconds: 1),
          () => value,
        ),
      ),
      reusable: true,
    );

    // then
    stream.listen(
      expectAsync1(
        (actual) => expect(actual, value),
        count: 1,
      ),
    );
    stream.listen(
      expectAsync1(
        (actual) => expect(actual, value),
        count: 1,
      ),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
