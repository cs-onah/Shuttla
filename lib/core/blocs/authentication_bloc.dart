import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttla/constants/firebase_errors.dart';
import 'package:shuttla/core/data_models/app_user.dart';
import 'package:shuttla/core/services/auth_service.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  late AuthService authService;

  AuthenticationBloc([AuthService? _auth])
      : authService = _auth ?? AuthService(), super(AuthLoggedOutState()) {

    on<AuthPassengerRegister>((event, emit) async {
      emit(AuthAuthenticatingState());
      try {
        AppUser? data = await authService.registerPassenger(
          event.nickName,
          event.email,
          event.password,
        );
        return emit(AuthAuthenticatedState(data));
      } on FirebaseAuthException catch (e) {
        return emit(AuthErrorState(SignUpWithEmailAndPasswordFailure.fromCode(e.code).message));
      } catch (error) {
        return emit(AuthErrorState(error));
      }
    });

    on<AuthDriverRegister>((event, emit) async {
      emit(AuthAuthenticatingState());
      try {
        AppUser? data = await authService.registerDriver(
          nickName: event.nickName,
          email: event.email,
          password: event.password,
          carColor: event.carColor,
          carModel: event.carModel,
          carManufacturer: event.carManufacturer,
          plateNumber: event.plateNumber,
        );
        return emit(AuthAuthenticatedState(data));
      } on FirebaseAuthException catch (e) {
        return emit(AuthErrorState(SignUpWithEmailAndPasswordFailure.fromCode(e.code).message));
      } catch (error) {
        return emit(AuthErrorState(error));
      }
    });

    on<AuthLoginEvent>((event, emit) async {
      emit(AuthAuthenticatingState());
      try {
        AppUser? data = await authService.loginUser(
          event.email,
          event.password,
        );
        return emit(AuthAuthenticatedState(data));
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        return emit(AuthErrorState(LogInWithEmailAndPasswordFailure.fromCode(e.code).message));
      } catch (error) {
        print(error.toString());
        return emit(AuthErrorState(error));
      }
    });

    on<AuthUserLogout>((event, emit) async {
      authService.logOut();
      return emit(AuthLoggedOutState());
    });
  }

  Future<AppUser?> currentUser() async{
    AppUser? user;
    try{
      user = await authService.getCurrentUser();
    } catch(e){
      print("$e");
    }
    return user;
  }
}

///Authentication events
abstract class AuthenticationEvent {}
class AuthUserLogout extends AuthenticationEvent {}
class AuthPassengerRegister extends AuthenticationEvent {
  final String nickName, email, password;
  AuthPassengerRegister(this.nickName, this.email, this.password);
}
class AuthLoginEvent extends AuthenticationEvent{
  final String email, password;
  AuthLoginEvent(this.email, this.password);
}
class AuthDriverRegister extends AuthenticationEvent {
  final String nickName, email, password;
  final String plateNumber, carManufacturer, carModel, carColor;
  AuthDriverRegister({
    required this.nickName,
    required this.email,
    required this.password,
    required this.plateNumber,
    required this.carManufacturer,
    required this.carModel,
    required this.carColor,
  });
}

///Authentication states
abstract class AuthenticationState {}
class AuthLoggedOutState extends AuthenticationState {}
class AuthAuthenticatingState extends AuthenticationState {}
class AuthErrorState extends AuthenticationState {
  final dynamic error;
  AuthErrorState(this.error);
}
class AuthAuthenticatedState extends AuthenticationState {
  final AppUser? user;
  AuthAuthenticatedState(this.user);
}
