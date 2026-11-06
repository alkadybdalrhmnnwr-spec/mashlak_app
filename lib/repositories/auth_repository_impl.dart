import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/password_reset_request.dart';
import 'auth_repository.dart';

/// تنفيذ تجريبي يحاكي الاتصال بالخادم باستخدام ذاكرة التطبيق.
class AuthRepositoryImpl implements AuthRepository {
  final List<UserModel> _users = [];
  String? _resetIdentifier;
  static const String demoOtp = '123456';

  Future<void> _networkDelay() =>
      Future.delayed(const Duration(milliseconds: 900));

  @override
  Future<UserModel> register(RegisterRequest request) async {
    await _networkDelay();
    final exists = _users.any((u) =>
        u.email.toLowerCase() == request.email.toLowerCase() ||
        u.academicId == request.academicId);
    if (exists) {
      throw Exception('البريد أو الرقم الأكاديمي مسجل مسبقاً');
    }
    final user = UserModel(
      fullName: request.fullName,
      academicId: request.academicId,
      email: request.email,
      password: request.password,
    );
    _users.add(user);
    return user;
  }

  @override
  Future<UserModel> login(LoginRequest request) async {
    await _networkDelay();
    final user = _users.where((u) =>
      (u.email.toLowerCase() == request.identifier.toLowerCase() ||
       u.academicId == request.identifier) &&
      u.password == request.password
    ).firstOrNull;
    if (user == null) {
      throw Exception('بيانات الدخول غير صحيحة أو الحساب غير موجود');
    }
    return user;
  }

  @override
  Future<void> sendPasswordResetCode(PasswordResetRequest request) async {
    await _networkDelay();
    final userExists = _users.any((u) =>
      u.email.toLowerCase() == request.identifier.toLowerCase() ||
      u.academicId == request.identifier
    );
    if (!userExists) throw Exception('لا يوجد حساب مطابق لهذه البيانات');
    _resetIdentifier = request.identifier;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _networkDelay();
    if (request.otp != demoOtp) throw Exception('رمز التحقق غير صحيح');
    final index = _users.indexWhere((u) =>
      u.email.toLowerCase() == _resetIdentifier?.toLowerCase() ||
      u.academicId == _resetIdentifier
    );
    if (index < 0) throw Exception('تعذر العثور على الحساب');
    final old = _users[index];
    _users[index] = UserModel(
      fullName: old.fullName,
      academicId: old.academicId,
      email: old.email,
      password: request.newPassword,
    );
    _resetIdentifier = null;
  }
}
