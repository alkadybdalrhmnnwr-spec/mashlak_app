import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const AuthScaffold({
    super.key, required this.title, required this.subtitle, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.school_rounded, size: 58, color: Color(0xFFC6A15B)),
                  const SizedBox(height: 14),
                  Text(title, textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(subtitle, textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.blueGrey)),
                  const SizedBox(height: 26),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  const PasswordField({super.key, required this.controller, required this.label, required this.validator});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hidden = true;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    obscureText: hidden,
    validator: widget.validator,
    decoration: InputDecoration(
      labelText: widget.label,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        onPressed: () => setState(() => hidden = !hidden),
        icon: Icon(hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
      ),
    ),
  );
}

class LoadingButton extends StatelessWidget {
  final bool loading;
  final String label;
  final VoidCallback onPressed;
  const LoadingButton({super.key, required this.loading, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: FilledButton(
      onPressed: loading ? null : onPressed,
      child: loading
        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
  );
}
