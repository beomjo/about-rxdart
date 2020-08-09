import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * GroupBy
 * 
 * 	각 값을 그룹지어 GroupByStream으로 방출합니다
 *  GroupByStream은 일반 스트림처럼 작동하지만
 *  Function Type에서 값 을받는 'key'속성이 있습니다.
 */

main() {
  String _toEventOdd(int value) => value == 0 ? 'even' : 'odd';

  test('groupBy', () async {
    //given
    var a = Stream.fromIterable([1, 2, 3, 4]);

    //when
    final result = a.groupBy((value) => value);

    //then
    await expectLater(
      result,
      emitsInOrder(<Matcher>[
        TypeMatcher<GroupByStream<int, int>>()
            .having((stream) => stream.key, 'key', 1),
        TypeMatcher<GroupByStream<int, int>>()
            .having((stream) => stream.key, 'key', 2),
        TypeMatcher<GroupByStream<int, int>>()
            .having((stream) => stream.key, 'key', 3),
        TypeMatcher<GroupByStream<int, int>>()
            .having((stream) => stream.key, 'key', 4),
        emitsDone
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('groupBy, Map으로 각각 방출', () async {
    //given
    var a = Stream.fromIterable([1, 2, 3, 4]);

    //when
    final result = a
        .groupBy((value) => _toEventOdd(value % 2))
        .flatMap((stream) => stream.map((event) => {stream.key: event}));

    //then

    await expectLater(
      result,
      emitsInOrder(<dynamic>[
        {'odd': 1},
        {'even': 2},
        {'odd': 3},
        {'even': 4},
        emitsDone
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('groupBy, Map으로 묶어 방출', () async {
    //given
    var a = Stream.fromIterable([1, 2, 3, 4]);

    //when
    final result = a
        .groupBy((value) => _toEventOdd(value % 2))
        .map((stream) async => await stream.fold(
              {stream.key: <int>[]},
              (Map<String, List<int>> previous, element) {
                return previous..[stream.key].add(element);
              },
            ));
    // fold is called when onDone triggers on the Stream

    //then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[
        {
          'odd': [1, 3]
        },
        {
          'even': [2, 4]
        },
        emitsDone
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
