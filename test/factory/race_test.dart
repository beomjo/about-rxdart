import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Race
 * 
 * 두 개 이상의 source가 주어지면 streams처음 항목에서만 모든 항목 streams을 내보내 항목이나 알림을 내 보냅니다.
 * 
 * marble diagram  https://rxmarbles.com/#race
 */

main() {
  test('race', () {
    // given
    var a = Rx.timer(1, Duration(seconds: 3)),
        b = Rx.timer(2, Duration(seconds: 2)),
        c = Rx.timer(3, Duration(seconds: 1));

    // when
    final stream = Rx.race([a, b, c]);

    // then
    stream.listen(expectAsync1(
      (value) => expect(value, 3),
      count: 1,
    ));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('race 수행중 에러발생', () async {
    // given
    var a = Rx.timer(1, Duration(seconds: 1)),
        b = Stream<Null>.error(Exception('oh noes!'));

    // when
    final stream = Rx.race([a, b]);

    // then
    stream.listen(
      null,
      onError: expectAsync2((e, s) => expect(e, isException)),
    );
  });
}
