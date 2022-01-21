
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocA extends Bloc<CounterEvent, CounterState>{
  BlocA() : super(CounterInitial()){
    on<CounterIncrement>((event, emit) => emit(CounterLoadInProgress()));
  }
}

///Events
///BlocSubject + Noun (optional) + Verb (event)
abstract class CounterEvent {}

class CounterReset extends CounterEvent {
  final int newState;
  CounterReset(this.newState);
}

class CounterIncrement extends CounterEvent {
  final int value;
  CounterIncrement(this.value);
}

///State
///BlocSubject + Verb (action) + State
///BlocSubject + State
abstract class CounterState {}
class CounterInitial extends CounterState {}
class CounterLoadInProgress extends CounterState {}
class CounterLoadSuccess extends CounterState {}
