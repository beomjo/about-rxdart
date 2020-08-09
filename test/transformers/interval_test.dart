import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Interval
 * 
 * 	지정된 기간 후에 Stream의 각 항목을 내보내는 Stream을 만듭니다.
 */

main() {
  Stream<int> _getStream() => Stream.fromIterable(const [0, 1, 2, 3, 4]);

  test('interval', () async {
    //given
    var a = _getStream();
    const expectedOutput = [0, 1, 2, 3, 4];
    var count = 0, lastInterval = -1;
    final stopwatch = Stopwatch()..start();

    //when
    final result = a.interval(const Duration(milliseconds: 1));

    //then
    result.listen(
        expectAsync1((result) {
          expect(expectedOutput[count++], result);

          if (lastInterval != -1) {
            expect(stopwatch.elapsedMilliseconds - lastInterval >= 1, true);
          }

          lastInterval = stopwatch.elapsedMilliseconds;
        }, count: expectedOutput.length),
        onDone: stopwatch.stop);
  }, timeout: Timeout(Duration(seconds: 5)));
}
