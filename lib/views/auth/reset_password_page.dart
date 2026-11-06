import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  final AuthController controller;
  const ResetPasswordPage({super.key, required this.controller});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() { _otp.dispose(); _password.dispose(); _confirm.dispose(); super.dispose(); }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await widget.controller.resetPassword(_otp.text.trim(), _password.text);
    if (!mounted) return;
    if (ok) {
      await showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 42),
        title: const Text('تم تحديث كلمة المرور'),
        content: const Text('يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('موافق'))],
      ));
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      showError(context, widget.controller.errorMessage ?? 'تعذر تحديث كلمة المرور');
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => AuthScaffold(
      title: 'تعيين كلمة مرور جديدة',
      subtitle: 'أدخل رمز التحقق ثم اختر كلمة مرور جديدة',
      child: Form(key: _formKey, child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextFormField(controller: _otp, keyboardType: TextInputType.number,
            maxLength: 6, validator: FormValidators.otp,
            decoration: const InputDecoration(labelText: 'رمز التحقق (6 أرقام)', prefixIcon: Icon(Icons.verified_user_outlined))),
          const SizedBox(height: 10),
          PasswordField(controller: _password, label: 'كلمة المرور الجديدة', validator: FormValidators.strongPassword),
          const SizedBox(height: 14),
          PasswordField(controller: _confirm, label: 'تأكيد كلمة المرور الجديدة',
            validator: (v) => FormValidators.confirmPassword(v, _password.text)),
          const SizedBox(height: 18),
          LoadingButton(loading: widget.controller.isLoading, label: 'تحديث كلمة المرور', onPressed: _reset),
        ],
      )),
    ),
  );
}
