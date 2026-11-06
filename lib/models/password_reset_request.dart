class PasswordResetRequest {
  final String identifier;
  const PasswordResetRequest({required this.identifier});
}

class ResetPasswordRequest {
  final String otp;
  final String newPassword;
  const ResetPasswordRequest({required this.otp, required this.newPassword});
}
