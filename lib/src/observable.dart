import 'package:mobx/src/global_state.dart';
import 'package:mobx/src/reaction.dart';

class Atom {
  String name;

  bool isPendingUnobservation = false;

  Atom(String this.name);

  Set<Derivation> observers = Set();

  reportObserved() {
    global.reportObserved(this);
  }

  reportChanged() {
    global.startBatch();
    global.propagateChanged(this);
    global.endBatch();
  }

  addObserver(Derivation d) {
    observers.add(d);
  }

  removeObserver(Derivation d) {
    observers.removeWhere((ob) => ob == d);
    if (observers.isEmpty) {
      global.enqueueForUnobservation(this);
    }
  }
}

class ObservableValue<T> extends Atom {
  T _value;

  ObservableValue(String name) : super(name);

  ObservableValue.of(String name, this._value) : super(name);

  T get value {
    reportObserved();
    return _value;
  }

  set value(T value) {
    _value = value;
    reportChanged();
  }
}
