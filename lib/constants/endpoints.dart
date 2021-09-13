class Endpoints {
  /// Auth
  static const String profile = '/profile';
  static const String profileStatus = '/profile-status';
  static const String dashboard = '/dashboard';
  static const String requestedFiles = '/requested-files';
  static const String resendPhoneCode = '/resend-phone-code';
  static const String resendEmailCode = '/resend-email-code';
  static const String signIn = '/sign-in';
  static const String saveContactInformation = '/save-contact-information';
  static const String savePersonalInformation = '/save-personal-information';
  static const String saveNextOfKinInformation = '/save-next-of-kin-information';
  static const String saveWorkInformation = '/save-work-information';
  static const String saveBankingInformation = '/save-banking-information';
  static const String makeAccountDefault = '/make-account-default';
  static const String finishForgotPassword = '/finish-forgot-password';
  static const String updatePassword = '/update-password';
  static const String saveOtherInformation = '/save-other-information';
  static const String confirmPhoneCode = '/confirm-phone-code';
  static const String confirmPhone = '/confirm-phone';
  static const String confirmEmail = '/confirm-email';
  static const String startForgotPassword = '/start-forgot-password';
  static const String fileDetails = '/file-details';
  static const String files = '/files';
  static const String signUp = '/sign-up';
  static const String saveDataUpload = '/save-data-upload';
  static const String addFile = '/add-file';
  static const String saveProfileImage = '/save-profile-image';

  /// Loans
  static const String loanDetails = '/loan-details';
  static const String applyForLoan = '/apply-for-loan';
  static const String approvedAmount = '/approved-amount';
  static const String cancelApprovedAmount = '/cancel-approved-amount';
  static const String previewLoan = '/preview-loan';
  static const String loanSummary = '/loan-summary';
  static const String chargeLoan = '/charge-loan';

  /// Payments
  static const String accountDebit = '/account-debit';
  static const String bankTransferCheck = '/bank-transfer-check';

  /// Notices
  static const String notifications = '/notifications';
  static const String readNotification = '/read-notification';
  static const String notificationDetails = '/notification-details';
  static const String addDeviceToken = '/add-device-token';

  /// Setup
  static const String setup = '/setup';
  static const String resolveAccount = '/resolve-account';
}
