import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * ForkJoin
 * 
 * 이 연산자는 스트림 그룹이 있고 "각각의 최종 방출 값"에만 관심이있는 경우에 가장 적합합니다. 
 * 이에 대한 한 가지 일반적인 사용 사례는 페이지로드 (또는 다른 이벤트)에서 여러 요청을 발행하고,
 *  모두에 대한 응답이 수신 된 경우에만 조치를 수행하려는 경우입니다.
 * 
 * forkJoin 오류에 공급 된 내부 스트림 중 하나라도 내부 스트림에서 오류를 올바르게 포착하지 않으면,
 *  이미 완료되었거나 완료된 다른 스트림의 값을 잃게됩니다.
 * 
 * 모든 내부 스트림 만 성공적으로 완료되는 데 관심이있는 경우 외부에서 오류를 잡을 수 있습니다. 
 * 또한 하나 이상의 항목을 방출하는 스트림이 있고 이전 배출 포크 우려가 우려되는 경우 올바른 선택이 아닙니다.
 * 
 * 이 경우 combineLatest 또는 zip과 같은 연산자를 사용하는 것이 좋습니다.
 * 
 * marble diagram https://rxjs-dev.firebaseapp.com/api/index/function/forkJoin
 */

main() {
  test('ForkJoin list', () async {
    // given
    var a = Stream.fromIterable(['a']),
        b = Stream.fromIterable(['b']),
        c = Stream.fromIterable(['C', 'D']);

    // when
    final stream = ForkJoinStream.list<String>([a, b, c]);

    // then
    await expectLater(
        stream,
        emitsInOrder([
          ['a', 'b', 'D'],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('ForkJoin 결합 조건 추가', () async {
    // given
    var a = Stream.fromIterable(['a']),
        b = Stream.fromIterable(['b']),
        c = Stream.fromIterable(['C', 'D']);

    // when
    final stream =
        ForkJoinStream([a, b, c], (List<String> values) => values.last);

    // then
    await expectLater(stream, emitsInOrder(['D', emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('ForkJoin N개의(특정수의) 스트림 존재', () async {
    // given
    var a = Stream.fromIterable(['1']), b = Stream.fromIterable(['2', '3']);

    // when
    final stream = ForkJoinStream.combine2(a, b, (a, b) => a + b);

    // then
    await expectLater(stream, emitsInOrder(['13', emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('ForkJoin 스트림중 에러가 포함되어있으면 에러를 방출한다', () async {
    // given
    var a = Stream.value(1),
        b = Stream.value(1),
        c = Stream<int>.error(Exception());

    // when
    final stream =
        CombineLatestStream.combine3(a, b, c, (a, b, c) => a + b + c);

    // then
    await expectLater(stream, emitsError(TypeMatcher<Exception>()));
  }, timeout: Timeout(Duration(seconds: 5)));
}
