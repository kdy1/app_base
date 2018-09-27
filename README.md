# app_base

My own commons library for flutter.

## Usage

### Dependency injection

```dart
void main(){
  return runApp(Module().register<Service>(ServiceImpl()).build(MyApp()));
}
```

```dart
final svc = inject<Service>(context);
```

