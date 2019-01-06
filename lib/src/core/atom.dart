import 'package:mobx/src/core/context.dart';
import 'package:mobx/src/core/derivation.dart';

enum _ListenerKind {
  onBecomeObserved,
  onBecomeUnobserved,
}

class Atom {
  Atom(this._context, {String name, Function onObserve, Function onUnobserve})
      : name = name ?? _context.nameFor('Atom') {
    if (onObserve != null) {
      onBecomeObserved(onObserve);
    }

    if (onUnobserve != null) {
      onBecomeUnobserved(onUnobserve);
    }
  }

  final ReactiveContext _context;

  final String name;

  bool isPendingUnobservation = false;

  DerivationState lowestObserverState = DerivationState.notTracking;

  bool isBeingObserved = false;

  Set<Derivation> observers = Set();

  final Map<_ListenerKind, Set<Function()>> _observationListeners = {};

  void reportObserved() {
    _context.reportObserved(this);
  }

  void reportChanged() {
    _context
      ..startBatch()
      ..propagateChanged(this)
      ..endBatch();
  }

  void addObserver(Derivation d) {
    observers.add(d);

    if (lowestObserverState.index > d.dependenciesState.index) {
      lowestObserverState = d.dependenciesState;
    }
  }

  void removeObserver(Derivation d) {
    observers.removeWhere((ob) => ob == d);
    if (observers.isEmpty) {
      _context.enqueueForUnobservation(this);
    }
  }

  void notifyOnBecomeObserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeObserved];
    listeners?.forEach(_notifyListener);
  }

  static void _notifyListener(Function() listener) => listener();

  void notifyOnBecomeUnobserved() {
    final listeners = _observationListeners[_ListenerKind.onBecomeUnobserved];
    listeners?.forEach(_notifyListener);
  }

  void Function() onBecomeObserved(Function fn) =>
      _addListener(_ListenerKind.onBecomeObserved, fn);

  void Function() onBecomeUnobserved(Function fn) =>
      _addListener(_ListenerKind.onBecomeUnobserved, fn);

  void Function() _addListener(_ListenerKind kind, Function fn) {
    if (fn == null) {
      throw MobXException('$kind handler cannot be null');
    }

    if (_observationListeners[kind] == null) {
      _observationListeners[kind] = Set()..add(fn);
    } else {
      _observationListeners[kind].add(fn);
    }

    return () {
      if (_observationListeners[kind] == null) {
        return;
      }

      _observationListeners[kind].removeWhere((f) => f == fn);
      if (_observationListeners[kind].isEmpty) {
        _observationListeners[kind] = null;
      }
    };
  }
}

class WillChangeNotification<T> {
  WillChangeNotification({this.type, this.newValue, this.object});

  /// One of add | update | delete
  final OperationType type;

  T newValue;
  final dynamic object;

  static WillChangeNotification unchanged = WillChangeNotification();
}

enum OperationType { add, update, delete }

class ChangeNotification<T> {
  ChangeNotification({this.type, this.newValue, this.oldValue, this.object});

  /// One of add | update | delete
  final OperationType type;

  final T oldValue;
  T newValue;

  dynamic object;
}
