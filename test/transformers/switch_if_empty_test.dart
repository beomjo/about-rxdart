import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * SwitchIfEmpty
 * 
 * 원래 Stream이 항목을 내 보내지 않으면이 연산자는 지정된 대체 스트림을 구독하고 대신 해당 Stream에서 항목을 내 보냅니다.
 * 이는 여러 소스의 데이터를 사용할 때 특히 유용 할 수 있습니다. 
 * 
 * 예를 들어, 레포지토리 패턴을 사용할 때. 로드해야 할 데이터가 있다고 가정하면 
 * 가장 빠른 액세스 포인트로 시작하고 가장 느린 포인트로 계속 돌아가는 것이 좋습니다. 
 * 
 * 예를 들어 먼저 메모리 내 데이터베이스를 쿼리 한 다음 파일 시스템의 데이터베이스를 쿼리 한 다음 
 * 데이터가 로컬 시스템에 없으면 네트워크 호출을 쿼리합니다.
 * 
 * 이것은 switchIfEmpty로 아주 간단하게 달성 할 수 있습니다
 * 
 * ex)
 * Stream<Data> memory;
 * Stream<Data> disk;
 * Stream<Data> network;
 * 
 * 
 * Stream<Data> getThatData =
 *    memory.switchIfEmpty(disk).switchIfEmpty(network);
 */

main() {
  test('switchIfEmpty is Empty', () async {
    // given
    final a = Stream<int>.empty();

    // when
    final result = a.switchIfEmpty(Stream.value(1));

    // then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[1, emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
  test('switchIfEmpty is Not Empty', () async {
    // given
    final a = Stream.value(99);

    // when
    final result = a.switchIfEmpty(Stream.value(1));

    // then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[99, emitsDone]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
