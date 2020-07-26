import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Merge
 * 
 * 지정된 항목에서 방출 된 항목을 streams단일 스트림 시퀀스로 병합합니다 .
 * 단일구독만이 가능합니다.(여러번 구독 불가능)
 * 
 * marble diagram http://rxmarbles.com/#merge
 */

main() {
  test('merge', () async {
    // given
    var a = Stream.periodic(const Duration(seconds: 1), (count) => count)
            .take(3),
        b = Stream.fromIterable(const [1, 2, 3, 4]);

    // when
    final stream = Rx.merge([a, b]);

    // then
    await expectLater(stream, emitsInOrder([1, 2, 3, 4, 0, 1, 2]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('merge를 여러번 구독할시 상태에러가 발생한다', () async {
    // givne
    var a = Stream.periodic(const Duration(seconds: 1), (count) => count)
            .take(3),
        b = Stream.fromIterable(const [1, 2, 3, 4]);

    // when
    final stream = Rx.merge([a, b]);

    // then
    stream.listen(null);
    await expectLater(() => stream.listen(null), throwsA(isStateError));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('merge 스트림중 에러 발생시에 에러를 리턴해야한다.', () async {
    // given
    var a = Stream.periodic(const Duration(seconds: 1), (count) => count)
            .take(3),
        b = Stream.fromIterable(const [1, 2, 3, 4]),
        c = Stream<int>.error(Exception());

    // when
    final streamWithError = Rx.merge([a, b, c]);

    //then
    streamWithError.listen(
      null,
      onError: expectAsync2((e, s) => expect(e, isException)),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
