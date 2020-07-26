import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Sample
 * 
 * sampleStream 에서 방출 된 Stream이후 소스에서 방출 된 가장 최근에 방출 된 항목 (있는 경우)을 방출 합니다 .
 */

Stream<int> getStream() =>
    Stream<int>.periodic(const Duration(milliseconds: 20), (count) => count)
        .take(5);

Stream<int> getSampleStream() =>
    Stream<int>.periodic(const Duration(milliseconds: 35), (count) => count)
        .take(10);

// sample
// time          0ms    20ms    40ms    60ms    80ms    100ms    120ms    140ms  
// source       |       0       1       2       3       4                   
// sampleStream |                    1               3                 4
// s_event      |                    O               O                 o    

main() {
  test('Sample', () async {
    // given
    var a = getStream();

    // when
    final result = a.sample(getSampleStream());

    // then

    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          1,
          3,
          4,
          emitsDone,
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
