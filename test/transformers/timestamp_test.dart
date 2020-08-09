import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * TimeStamp
 * 
 * 소스 스트림에서 내 보낸 각 항목을 내 보낸 Timestamped항목과 항목이 내 보낸 시간을 포함 하는 개체에 래핑합니다 .
 */

main() {
  test('timeStamp', () async {
    // given
    final a = Stream.fromIterable(const [1, 2, 3]);

    // when
    final result = a.timestamp();

    // then
    await expectLater(
        result,
        emitsInOrder([
          TypeMatcher<Timestamped>(),
          TypeMatcher<Timestamped>(),
          TypeMatcher<Timestamped>(),
        ]));

    // TimeStamp{timestamp: 2020-08-10 00:58:57.052087, value: 1}
    // TimeStamp{timestamp: 2020-08-10 00:58:57.053311, value: 2}
    // TimeStamp{timestamp: 2020-08-10 00:58:57.053397, value: 3}
  }, timeout: Timeout(Duration(seconds: 5)));
}
