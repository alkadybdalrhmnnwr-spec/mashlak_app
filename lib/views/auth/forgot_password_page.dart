import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AuthController controller;
  const ForgotPasswordPage({super.key, required this.controller});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();

  @override
  void dispose() { _identifier.dispose(); super.dispose(); }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final value = _identifier.text.trim();
    final ok = await widget.controller.sendPasswordResetCode(value);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تم إرسال رمز التحقق بنجاح (رمز العرض: 123456)'),
        backgroundColor: Colors.green));
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ResetPasswordPage(controller: widget.controller)));
    } else {
      showError(context, widget.controller.errorMessage ?? 'تعذر إرسال الرمز');
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => AuthScaffold(
      title: 'استعادة كلمة المرور',
      subtitle: 'استعد الوصول إلى حسابك الجامعي',
      child: Form(key: _formKey, child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Icon(Icons.info_outline, color: Color(0xFFC6A15B)),
              SizedBox(width: 10),
              Expanded(child: Text('أدخل بريدك الجامعي أو رقمك الأكاديمي. سيُرسل رمز تحقق إلى وسيلة الاتصال المرتبطة بالحساب.')),
            ]),
          )),
          const SizedBox(height: 18),
          TextFormField(controller: _identifier, validator: FormValidators.loginIdentifier,
            decoration: const InputDecoration(labelText: 'البريد أو الرقم الأكاديمي', prefixIcon: Icon(Icons.alternate_email))),
          const SizedBox(height: 16),
          LoadingButton(loading: widget.controller.isLoading, label: 'إرسال رمز التحقق', onPressed: _send),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('العودة لتسجيل الدخول')),
        ],
      )),
    ),
  );
}
