import 'package:flutter/foundation.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;
  AuthController(this.repository);

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  Future<bool> login(LoginRequest request) async {
    _start();
    try {
      currentUser = await repository.login(request);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = _message(e);
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _start();
    try {
      currentUser = await repository.register(request);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = _message(e);
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> sendPasswordResetCode(String identifier) async {
    _start();
    try {
      await repository.sendPasswordResetCode(
        PasswordResetRequest(identifier: identifier),
      );
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = _message(e);
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> resetPassword(String otp, String newPassword) async {
    _start();
    try {
      await repository.resetPassword(
        ResetPasswordRequest(otp: otp, newPassword: newPassword),
      );
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = _message(e);
      return false;
    } finally {
      _finish();
    }
  }

  void _start() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
  }

  void _finish() {
    isLoading = false;
    notifyListeners();
  }

  String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}
