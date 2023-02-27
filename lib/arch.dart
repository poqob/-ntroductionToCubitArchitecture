import 'package:bloc/bloc.dart';

int calculate() {
  return 6 * 7;
}

class CounterCubit extends Cubit<int> {
  CounterCubit(int initialValue) : super(initialValue);
  //emit is only accessable in cubit class.
  //emit is notifies changes to class.
  //changes are accesible from outside the class via state keyword.
  void increament() => emit(state + 1);

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print("on change called $change"); //data manipulation.
  }
}

Future<void> example1() async {
  final cubit = CounterCubit(0);

  final subscription = cubit.stream.listen((event) async => print(event));
  subscription.onData((data) => print("on data ${data * 100}"));
  cubit.increament();
  cubit.increament();
  cubit.increament();
  cubit.increament();
  cubit.increament();
  await Future.delayed(
      Duration.zero); //to prevent canceling subscription and cubit immediately.
  await subscription.cancel();
  await cubit.close();
}

Future<void> example2() async {
  CounterCubit(9)
    ..increament()
    ..close();
}

Future<void> example0() async {
  //sumStream(countStream(100)).then((_) {print('result: $_');});
  final Stream<int> stream = countStream(100);
  final int future = await sumStream(stream);
  print(future);
}

Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    await Future.delayed(Duration(milliseconds: 50), () {});

    yield i;
  }
}

Future<int> sumStream(Stream<int> stream) async {
  int sum = 0;
  await for (int value in stream) {
    sum += value;
    print("current: $value sum: $sum");
  }
  return sum;
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void example3() {
  Bloc.observer = SimpleBlocObserver();
  CounterCubit(10)
    ..increament()
    ..close();
}
