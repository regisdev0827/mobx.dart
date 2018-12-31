import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

main() {
  test('intercept', () {
    var x = observable(10);
    var executed = false;

    var dispose = x.intercept<int>((change) {
      // prevent a change
      change.newValue = 33;
      executed = true;
      return change;
    });

    x.value = 100;
    expect(x.value, equals(33));
    expect(executed, isTrue);

    dispose();
  });

  test('intercept prevents a change', () {
    var x = observable(10);

    var dispose = x.intercept<int>((change) {
      return null;
    });

    x.value = 100;
    expect(x.value, equals(10));

    dispose();
  });

  test('intercept can be chained', () {
    var x = observable(10);

    var dispose1 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    var dispose2 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    x.value = 100;
    expect(x.value, equals(120));

    dispose1();
    dispose2();
  });

  test('intercept chain can be short-circuited', () {
    var x = observable(10);

    var dispose1 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    var dispose2 = x.intercept<int>((change) {
      return null;
    });

    var dispose3 = x.intercept<int>((change) {
      change.newValue = change.newValue + 10;
      return change;
    });

    x.value = 100;
    expect(x.value, equals(10)); // no change as the interceptor-2 has nullified

    dispose1();
    dispose2();
    dispose3();
  });
}
