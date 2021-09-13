import 'dart:async';

Map<int, Timer> _timeouts = {};

///
/// target should be defined as a function and not as a callback so that it maintains a singular hashCode
/// See tests
void debounce(int timeoutMS, Function target, List<dynamic> arguments) {
  final hashCode = target.hashCode;
  if (_timeouts.containsKey(hashCode)) {
    _timeouts[hashCode].cancel();
  }

  final timer = Timer(Duration(milliseconds: timeoutMS), () => Function.apply(target, arguments));

  _timeouts[hashCode] = timer;
}
