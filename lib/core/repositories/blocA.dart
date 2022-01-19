
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocA extends Bloc<CounterEvent, int>{
  BlocA() : super(0){
    on<IncrementEvent>((event, emit) => emit(event.value + this.state));
  }
}

///Events
abstract class CounterEvent {}

class SetStateEvent extends CounterEvent {
  final int newState;
  SetStateEvent(this.newState);
}

class IncrementEvent extends CounterEvent {
  final int value;
  IncrementEvent(this.value);
}
