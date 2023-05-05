import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:equatable/equatable.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState.unauthenticated());

  void login() {
    emit(const LoginState.authenticated());
  }

  void logout() {
    emit(const LoginState.unauthenticated());
  }
}
