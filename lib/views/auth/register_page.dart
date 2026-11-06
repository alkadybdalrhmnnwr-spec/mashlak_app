import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/register_request.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  final AuthController controller;
  const RegisterPage({super.key, required this.controller});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _accepted = false;

  @override
  void dispose() {
    _name.dispose(); _id.dispose(); _email.dispose();
    _password.dispose(); _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_accepted) {
      showError(context, 'يجب الموافقة على اللوائح والشروط الأكاديمية');
      return;
    }
    final ok = await widget.controller.register(RegisterRequest(
      fullName: _name.text.trim(), academicId: _id.text.trim(),
      email: _email.text.trim(), password: _password.text,
    ));
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تم إنشاء الحساب بنجاح'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      showError(context, widget.controller.errorMessage ?? 'تعذر إنشاء الحساب');
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => AuthScaffold(
      title: 'إنشاء حساب',
      subtitle: 'أدخل بياناتك الجامعية لإنشاء حساب جديد',
      child: Form(key: _formKey, child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextFormField(controller: _name, validator: FormValidators.fullName,
            decoration: const InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.badge_outlined))),
          const SizedBox(height: 13),
          TextFormField(controller: _id, keyboardType: TextInputType.number,
            validator: FormValidators.academicId,
            decoration: const InputDecoration(labelText: 'الرقم الأكاديمي (9-10 أرقام)', prefixIcon: Icon(Icons.numbers))),
          const SizedBox(height: 13),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
            validator: FormValidators.email,
            decoration: const InputDecoration(labelText: 'البريد الجامعي', prefixIcon: Icon(Icons.email_outlined))),
          const SizedBox(height: 13),
          PasswordField(controller: _password, label: 'كلمة المرور', validator: FormValidators.strongPassword),
          const SizedBox(height: 13),
          PasswordField(controller: _confirm, label: 'تأكيد كلمة المرور',
            validator: (v) => FormValidators.confirmPassword(v, _password.text)),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero, value: _accepted,
            onChanged: (v) => setState(() => _accepted = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('أوافق على اللوائح والشروط الأكاديمية'),
          ),
          const SizedBox(height: 10),
          LoadingButton(loading: widget.controller.isLoading, label: 'إنشاء الحساب', onPressed: _register),
        ],
      )),
    ),
  );
}
