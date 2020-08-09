import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * DistinctUnique
 * 
 * 데이터 이벤트가 이전에 이미 발생한 경우 건너 뛰는 Stream을 만듭니다.
 * 
 * 같음은 제공된 equals 및 hashCode 메서드에 의해 결정됩니다.
 * 생략하면 마지막으로 제공된 데이터 요소의 '=='연산자와 hashCode가 사용됩니다.
 * 이 스트림이있는 경우 반환 된 스트림은 브로드 캐스트 스트림입니다. 
 * 브로드 캐스트 스트림이 두 번 이상 수신되는 경우 각 구독은 equals 및 hashCode 테스트를 개별적으로 수행합니다.
 * 
 */

main() {
  test('distinctUnique (클래스의 equals 및 hascode와 함께 작동)', () async {
    // given
    final a = Stream.fromIterable(const [
      _TestObject('a'),
      _TestObject('a'),
      _TestObject('b'),
      _TestObject('a'),
      _TestObject('b'),
      _TestObject('c'),
      _TestObject('a'),
      _TestObject('b'),
      _TestObject('c'),
      _TestObject('a')
    ]);

    // when
    final result = a.distinctUnique();

    // then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[
        const _TestObject('a'),
        const _TestObject('b'),
        const _TestObject('c'),
        emitsDone
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('distinctUnique (조건으로 제공된 equals 및 해시 코드로 작동)', () async {
    // given
    final a = Stream.fromIterable(const [
      _TestObject('a'),
      _TestObject('a'),
      _TestObject('b'),
      _TestObject('a'),
      _TestObject('b'),
      _TestObject('c'),
      _TestObject('a'),
      _TestObject('b'),
      _TestObject('c'),
      _TestObject('a')
    ]);

    // when
    final result = a.distinctUnique(
        equals: (a, b) => a.key == b.key, hashCode: (o) => o.key.hashCode);

    // then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[
        const _TestObject('a'),
        const _TestObject('b'),
        const _TestObject('c'),
        emitsDone
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}

class _TestObject {
  final String key;

  const _TestObject(this.key);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestObject &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => key;
}
