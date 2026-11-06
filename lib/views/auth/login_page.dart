import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/login_request.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final AuthController controller;
  const LoginPage({super.key, required this.controller});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await widget.controller.login(LoginRequest(
      identifier: _identifier.text.trim(),
      password: _password.text,
      rememberMe: _rememberMe,
    ));
    if (!mounted) return;
    if (ok) {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('تم تسجيل الدخول'),
        content: Text('مرحباً ${widget.controller.currentUser!.fullName}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
      ));
    } else {
      showError(context, widget.controller.errorMessage ?? 'تعذر تسجيل الدخول');
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => AuthScaffold(
      title: 'تسجيل الدخول',
      subtitle: 'الدخول إلى حسابك الجامعي',
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextFormField(controller: _identifier, validator: FormValidators.loginIdentifier,
            decoration: const InputDecoration(labelText: 'المعرف الأكاديمي أو البريد', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 16),
          PasswordField(controller: _password, label: 'كلمة المرور', validator: FormValidators.loginPassword),
          Row(children: [
            Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? false)),
            const Text('تذكرني'),
            const Spacer(),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => ForgotPasswordPage(controller: widget.controller))),
              child: const Text('نسيت كلمة المرور؟')),
          ]),
          LoadingButton(loading: widget.controller.isLoading, label: 'تسجيل الدخول', onPressed: _login),
          const SizedBox(height: 14),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => RegisterPage(controller: widget.controller))),
            child: const Text('إنشاء حساب جديد')),
        ]),
      ),
    ),
  );
}
