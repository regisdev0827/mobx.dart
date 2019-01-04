import 'package:mobx/src/core/action.dart';
import 'package:mobx/src/core/atom_derivation.dart';

abstract class Listenable {
  List<Function> changeListeners;
  Function observe<T>(void Function(ChangeNotification<T>) handler,
      {bool fireImmediately});
}

bool hasListeners(Listenable obj) {
  return obj.changeListeners != null && obj.changeListeners.length > 0;
}

Function registerListener(Listenable obj, Function handler) {
  final listeners = obj.changeListeners ?? (obj.changeListeners = List());
  listeners.add(handler);

  return () {
    final index = listeners.indexOf(handler);
    if (index != -1) {
      listeners.removeAt(index);
    }
  };
}

notifyListeners<T>(Listenable obj, ChangeNotification<T> change) {
  untracked(() {
    if (obj.changeListeners == null) {
      return;
    }

    final listeners = obj.changeListeners.toList(growable: false);
    for (var i = 0; i < listeners.length; i++) {
      final listener = listeners[i];

      listener(change);
    }
  });
}
