import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * RetryWhen
 * 
 * 에러가 발생하였을때 소스 스트림을 재생성하고 다시들을 스트림을 만듭니다. 소스 스트림에 오류가 발생하거나 완료되면 스트림이 종료됩니다.
 * retryWhenFactory오류를 방출하는 RetryError가 발생합니다. RetryError는 실패를 일으킨 모든 Error 및 StackTrace 를 포함합니다 .
 */

Stream<int> Function() _sourceStream(int i, [int throwAt]) {
  return throwAt == null
      ? () => Stream.fromIterable(range(i))
      : () =>
          Stream.fromIterable(range(i)).map((i) => i == throwAt ? throw i : i);
}

Stream<int> _alwaysThrow(dynamic e, StackTrace s) =>
    Stream<int>.error(Error(), StackTrace.fromString('S'));

Stream<void> _neverThrow(dynamic e, StackTrace s) => Stream.value('');

Iterable<int> range(int startOrStop, [int stop, int step]) sync* {
  final start = stop == null ? 0 : startOrStop;
  stop ??= startOrStop;
  step ??= 1;

  if (step == 0) throw ArgumentError('step cannot be 0');
  if (step > 0 && stop < start) {
    throw ArgumentError('if step is positive,'
        ' stop must be greater than start');
  }
  if (step < 0 && stop > start) {
    throw ArgumentError('if step is negative,'
        ' stop must be less than start');
  }

  for (var value = start;
      step < 0 ? value > stop : value < stop;
      value += step) {
    yield value;
  }
}

main() {
  test('retryWhen 에러가 발생하지 않았을때', () {
    // givne
    var a = _sourceStream(3);
    var whenFactory = _alwaysThrow;

    // when
    var stream = Rx.retryWhen(a, whenFactory);

    //then
    expect(
      stream,
      emitsInOrder(<dynamic>[0, 1, 2, emitsDone]),
    );
  });

  test('retryWhen Stream 에러가 발생하지 않았을때', () {
    // givne
    var a = _sourceStream(3);
    var whenFactory = _alwaysThrow;

    // when
    var stream = RetryWhenStream(a, whenFactory);

    //then
    expect(
      stream,
      emitsInOrder(<dynamic>[0, 1, 2, emitsDone]),
    );
  });

  test('retryWhen 에러발생시에 whenFactory에서 다시 스트림으로 변환 하여, 무한으로 재시도 해야한다', () {
    // given
    var a = _sourceStream(1000, 2);
    var whenFactory = _neverThrow;

    // when
    final stream = RetryWhenStream(a, whenFactory).take(6);

    // then
    expect(
      stream,
      emitsInOrder(<dynamic>[0, 1, 0, 1, 0, 1, emitsDone]),
    );
  });
  test('retryWhen 에러발생시에 whenFactory에서도 에러가 발생하면 RetryError를 반환해야한다', () {
    // given
    var a = _sourceStream(3, 0);
    var whenFactory = _alwaysThrow;

    // when

    final streamWithError = RetryWhenStream(a, whenFactory);

    // then
    expect(
      streamWithError,
      emitsInOrder(<dynamic>[emitsError(TypeMatcher<RetryError>()), emitsDone]),
    );
  });

  test('retryWhen 에러발생시에 whenFactory에서도 에러가 발생하면 RetryError를 반환해야한다', () async {
    // given
    var a = _sourceStream(3, 0);
    var whenFactory = _alwaysThrow;

    // when
    final streamWithError = RetryWhenStream(a, whenFactory);

    // then
    await expectLater(
        streamWithError,
        emitsInOrder(<dynamic>[
          emitsError(
            predicate<RetryError>((a) {
              return a.errors.length == 1 &&
                  a.errors
                      .every((es) => es.error != null && es.stackTrace != null);
            }),
          ),
          emitsDone,
        ]));
  });
}
