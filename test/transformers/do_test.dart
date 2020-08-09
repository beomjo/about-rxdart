import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Do
 * 
 * doOnCancel
 * 스트림 구독이 취소되면 지정된 콜백 함수를 호출합니다.
 * 다른 rx구현에서는 종종 doOnUnsubscribe 또는 doOnDispose라고합니다.
 * 
 * 
 * doOnData
 * 스트림이 항목을 내보낼 때 지정된 콜백 함수를 호출합니다. 다른 rx구현에서는이를 doOnNext라고합니다.
 * 
 * 
 * doDone
 * 스트림이 항목 방출을 완료하면 지정된 콜백 함수를 호출합니다. 다른 rx구현에서는이를 doOnComplete라고합니다.
 * 
 * 
 * doOnEach
 * 스트림이 데이터를 내보내거나 error를 내거나 done를 내 보낸 경우 지정된 콜백 함수를 호출합니다.
 * 콜백은 Notification객체를 수신 합니다.
 * Notification(onData, onDone OnError)
 * 
 * 
 * doOnPause
 * 스트림 구독이 일시 중지되면 지정된 콜백 함수를 호출합니다.
 * 
 * 
 * doOnResume
 * 스트림 구독이 항목 수신을 재개 할 때 지정된 콜백 함수를 호출합니다.
 * 
 * 
 * doOnListen
 * 스트림이 처음 수신 될 때 지정된 콜백 함수를 호출합니다.
 */

main() {
  test('스트림이 종료되면 doOnDone이 호출되어야한다', () async {
    //given
    var onDoneCalled = false;
    final a = Stream<void>.empty();

    //when
    final stream = a.doOnDone(() => onDoneCalled = true);

    //then
    await expectLater(stream, emitsDone);
    await expectLater(onDoneCalled, isTrue);
  });

  test('에러가 방출되었을때 doOnError가 호출되어야한다', () async {
    //given
    var onErrorCalled = false;
    final a = Stream<void>.error(Exception());

    //when
    final stream = a.doOnError((dynamic e, dynamic s) => onErrorCalled = true);

    //then

    await expectLater(stream, emitsError(isException));
    await expectLater(onErrorCalled, isTrue);
  });

  test('브로드캐스트 스트림에서 에러가 발생했을때, doOnError는 1번만 호출되어야한다', () async {
    //given
    var count = 0;
    final subject = BehaviorSubject<int>(sync: true);

    //when
    final stream = subject.stream.doOnError(
      (dynamic e, dynamic s) => count++,
    );
    stream.listen(null, onError: (dynamic e, dynamic s) {});
    stream.listen(null, onError: (dynamic e, dynamic s) {});
    subject.addError(Exception());
    subject.addError(Exception());

    //then
    await expectLater(count, 2);
    await subject.close();
  });

  test('subscription을 취소했을때, doOnCancel이 호출되어야한다', () async {
    //given
    var onCancelCalled = false;
    final stream = Stream.value(1);

    //when
    await stream.doOnCancel(() => onCancelCalled = true).listen(null).cancel();

    //then
    await expectLater(onCancelCalled, isTrue);
  });

  test('브로드캐스트 스트림에서 onCanceld은 1번만 호출되어야한다', () async {
    // given
    var count = 0;
    final subject = BehaviorSubject<int>(sync: true);

    // when
    final stream = subject.doOnCancel(() => count++);
    await stream.listen(null).cancel();
    await stream.listen(null).cancel();

    // then
    await expectLater(count, 2);
    await subject.close();
  });

  test('아이템이 방출되었을때, doOnData가 호출되어야한다', () async {
    //given
    var onDataCalled = false;
    var a = Stream.value(1);

    //when
    final stream = a.doOnData((_) => onDataCalled = true);

    //then
    await expectLater(stream, emits(1));
    await expectLater(onDataCalled, isTrue);
  });

  test('브로드캐스트 스트림에서 doOnData는 1번만 호출되어야한다', () async {
    //given
    final actual = <int>[];
    final controller = BehaviorSubject<int>(sync: true);

    //when
    final stream =
        controller.stream.transform(DoStreamTransformer(onData: actual.add));
    stream.listen(null);
    stream.listen(null);
    controller.add(1);
    controller.add(2);

    //then
    await expectLater(actual, const [1, 2]);
    await controller.close();
  });

  test('Data, Error, Done알림이 있을때 doOnEach를 호출해야한다', () async {
    //given
    StackTrace stacktrace;
    final actual = <Notification<int>>[];
    final exception = Exception();
    final a = Stream.value(1).concatWith([Stream<int>.error(exception)]);

    //when
    final stream = a.doOnEach((notification) {
      actual.add(notification);
      if (notification.isOnError) {
        stacktrace = notification.stackTrace;
      }
    });

    //then
    await expectLater(
      stream,
      emitsInOrder(<dynamic>[1, emitsError(isException), emitsDone]),
    );
    await expectLater(actual, [
      Notification.onData(1),
      Notification<void>.onError(exception, stacktrace),
      Notification<void>.onDone()
    ]);
  });

  test('브로드캐스트 스트림에서 doOnEach는 1번만 호출되어야한다', () async {
    //given
    var count = 0;
    final controller = StreamController<int>.broadcast(sync: true);
    final stream = controller.stream.transform(DoStreamTransformer(onEach: (_) {
      count++;
    }));

    //when
    stream.listen(null);
    stream.listen(null);
    controller.add(1);
    controller.add(2);

    //then
    await expectLater(count, 2);
    await controller.close();
  });

  test('subscription엫서 호출시 onPause와 onResume이 호출되어야한다', () async {
    //given
    var onPauseCalled = false, onResumeCalled = false;
    var a = Stream.value(1);

    //when
    final stream = a.doOnPause((_) {
      onPauseCalled = true;
    }).doOnResume(() {
      onResumeCalled = true;
    });

    //then
    stream.listen(null, onDone: expectAsync0(() {
      expect(onPauseCalled, isTrue);
      expect(onResumeCalled, isTrue);
    }))
      ..pause()
      ..resume();
  });
}
