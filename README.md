# mobx

![](doc/dart.png) + ![](doc/mobx.png)

[MobX](https://github.com/mobxjs/mobx) for the Dart language.

> Supercharge the state-management in your Dart apps with Transparent Functional Reactive Programming (TFRP)

## Building blocks

### Observables 

- [x] Create `ObservableValue<T>` via `observable<T>()`
- [ ] Create `ObservableList<T>`
- [ ] Create `ObservableMap<K, T>`

### Computed Observables 

- [x] Create `ComputedValue<T>` via `computed<T>()`
- [x] 2-phase change propagation

### Reactions 

- [x] Create `Reaction` with `autorun()`
- [x] Create `Reaction` with `reaction()`
- [x] Create `Reaction` with `when()`
- [x] Create `Reaction` with `when()` returning `Future<T>`
 

### Actions 

- [x] Create `Action` with `action()`
- [x] Create untracked-action with `untracked<T>()`
- [x] Create transaction with `transaction<T>()`


## Cross cutting features

- [ ] Observability API
- [ ] Spying and Tracing
- [ ] Exception handling and Error recovery


## Public facing

- [ ] Logo
- [ ] Documentation
- [ ] Website (published on github.io)

