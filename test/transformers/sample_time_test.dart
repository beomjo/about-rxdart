import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * SampleTime
 * 
 * Stream반복 방출 시간 범위 내에서 이전 방출 이후 소스에서 방출 된 가장 최근에 방출 된 값이있는경우 방출합니다.
 */

Stream<int> getStream() =>
    Stream<int>.periodic(const Duration(milliseconds: 20), (count) => count)
        .take(5);

// sample
// time          0ms    20ms    40ms    60ms    80ms    100ms    120ms    140ms
// source       |       0       1       2       3       4
// sampleStream |                    1               3                 4
// s_event      |                    O               O                 o

main() {
  test('SampleTime', () async {
    // given

    // when
    final stream = getStream().sampleTime(const Duration(milliseconds: 35));

    // then
    await expectLater(stream, emitsInOrder(<dynamic>[1, 3, 4, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
