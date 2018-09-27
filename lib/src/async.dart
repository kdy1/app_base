import 'dart:async';

/// `src`가 새로운 값을 내보냈을 때, `dur`동안만 그 값을 유지하고 그 다음 다시 null로 돌아가는 스트림을 만듭니다.
Stream<T> nullAfter<T>(Stream<T> src, Duration dur) async* {
  assert(src != null);
  assert(dur != null);

  await for (final e in src) {
    yield e;
    await Future.delayed(dur);
    yield null;
  }
}
