import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 *  MergeWith
 * 
 * 	여러 스트림에서 내 보낸 항목을 단일 항목 스트림으로 결합합니다. 항목은 소스에서 방출되는 순서대로 방출됩니다.
 */

main() {
  test('mergeWith', () async {
    //given
    final delayedStream = Rx.timer(1, Duration(milliseconds: 10));
    final immediateStream = Stream.value(2);

    //when
    final result = delayedStream.mergeWith([immediateStream]);

    //then
    await expectLater(result, emitsInOrder([2, 1]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
