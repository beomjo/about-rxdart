import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * ConcatWith
 * 
 * 현재 Stream에서 모든 항목을 내 보낸 다음 지정된 스트림의 모든 항목을 차례로 내보내는 Stream을 반환합니다.
 * 
 */

main() {
  test('concatWith', () async {
    // given
    final delayedStream = Rx.timer(1, Duration(milliseconds: 10));
    final immediateStream = Stream.value(2);

    // when
    final result = delayedStream.concatWith([immediateStream]);

    // then
    await expectLater(result, emitsInOrder(<dynamic>[1, 2, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
