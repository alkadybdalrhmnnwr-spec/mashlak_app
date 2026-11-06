class FormValidators {
  static String? requiredText(String? value, {String label = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label مطلوب';
    }
    return null;
  }

  static String? loginIdentifier(String? value) {
    final required = requiredText(value, label: 'المعرف الأكاديمي أو البريد');
    if (required != null) return required;
    if (value!.trim().length < 5) {
      return 'يجب ألا يقل المعرف عن 5 خانات';
    }
    return null;
  }

  static String? loginPassword(String? value) {
    final required = requiredText(value, label: 'كلمة المرور');
    if (required != null) return required;
    if (value!.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 محارف على الأقل';
    }
    return null;
  }

  static String? fullName(String? value) {
    final required = requiredText(value, label: 'الاسم الكامل');
    if (required != null) return required;
    if (value!.trim().length < 3) {
      return 'الاسم يجب أن يتكون من 3 محارف على الأقل';
    }
    return null;
  }

  static String? academicId(String? value) {
    final required = requiredText(value, label: 'الرقم الأكاديمي');
    if (required != null) return required;
    if (!RegExp(r'^\d{9,10}$').hasMatch(value!.trim())) {
      return 'أدخل 9 أو 10 أرقام فقط';
    }
    return null;
  }

  static String? email(String? value) {
    final required = requiredText(value, label: 'البريد الجامعي');
    if (required != null) return required;

    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value!.trim())) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  static String? strongPassword(String? value) {
    final required = requiredText(value, label: 'كلمة المرور');
    if (required != null) return required;

    if (value!.length < 8 ||
        !RegExp(r'\d').hasMatch(value) ||
        !RegExp(r'[A-Z]').hasMatch(value)) {
      return 'استخدم 8 محارف على الأقل، ورقماً وحرفاً كبيراً';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final required = requiredText(value, label: 'تأكيد كلمة المرور');
    if (required != null) return required;
    if (value != original) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  static String? otp(String? value) {
    final required = requiredText(value, label: 'رمز التحقق');
    if (required != null) return required;

    if (!RegExp(r'^\d{6}$').hasMatch(value!.trim())) {
      return 'رمز التحقق يجب أن يتكون من 6 أرقام';
    }
    return null;
  }
}