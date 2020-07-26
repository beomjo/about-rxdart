import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Never
 * 
 * 무한 지속 시간을 나타내는 데 사용할 수있는 종료되지 않는 스트림 시퀀스를 반환합니다.
 * never 연산자는 매우 구체적이고 제한된 동작을 가진 연산자입니다. 
 * 이는 테스트 목적으로 유용하며 때로는 다른 스트림과 함께 또는 다른 스트림을 매개 변수로 기대하는 운영자에게 매개 변수로 결합하는 데 유용합니다.
 * 
 */

main() {
  test('never', () async {
    // given
    var onDataCalled = false, onDoneCalled = false, onErrorCalled = false;

    // when
    final stream = Rx.never<Null>();

    final subscription = stream.listen(
        expectAsync1((_) {
          onDataCalled = true;
        }, count: 0),
        onError: expectAsync2((Exception e, StackTrace s) {
          onErrorCalled = false;
        }, count: 0),
        onDone: expectAsync0(() {
          onDataCalled = true;
        }, count: 0));

    await Future<Null>.delayed(Duration(milliseconds: 10));

    await subscription.cancel();

    // 어떤 에러나 데이터등을 리턴하는 콜백함수가 모두 호출되지않아 초기상태 모두 false임
    await expectLater(onDataCalled, isFalse);
    await expectLater(onDoneCalled, isFalse);
    await expectLater(onErrorCalled, isFalse);
  }, timeout: Timeout(Duration(seconds: 5)));
}
