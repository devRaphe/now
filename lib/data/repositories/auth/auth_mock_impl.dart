import 'dart:io';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';

class AuthMockImpl implements AuthRepository {
  AuthMockImpl([this.delay = const Duration(milliseconds: 1000)]);

  final Duration delay;

  @override
  Future<UserModel> getAccount() async {
    final data = await jsonReader("profile", delay);
    return UserModel.fromJson(data["user"]);
  }

  @override
  Future<ProfileStatusModel> getProfileStatus() async {
    final data = await jsonReader("profile_status_success", delay);
    return ProfileStatusModel.fromJson(data);
  }

  @override
  Future<LoginResponseData> signIn(LoginRequestData data) async {
    final data = await jsonReader("login_success", delay);
    return LoginResponseData(
      user: UserModel.fromJson(data["user"]),
      token: data["token"],
      message: AppStrings.successMessage,
    );
  }

  @override
  Future<Pair<int, String>> signUp(SignupRequestData data) async {
    final data = await jsonReader("signup_success", delay);
    return Pair<int, String>(data["user"]["uid"], data["token"]);
  }

  @override
  Future<UserModel> saveContactInfo(ContactInfoRequestData data) async {
    final data = await jsonReader("user_update_success", delay);
    return UserModel.fromJson(data["user"]);
  }

  @override
  Future<UserModel> savePersonalInfo(PersonalInfoRequestData data) async {
    final data = await jsonReader("user_update_success", delay);
    return UserModel.fromJson(data["user"]);
  }

  @override
  Future<UserModel> saveNextOfKinDetails(NextOfKinRequestData data) async {
    final data = await jsonReader("user_update_success", delay);
    return UserModel.fromJson(data["user"]);
  }

  @override
  Future<UserModel> saveWorkDetails(WorkDetailsRequestData data) async {
    final data = await jsonReader("user_update_success", delay);
    return UserModel.fromJson(data["user"]);
  }

  @override
  Future<bool> saveOtherInfo(OtherInfoRequestData data) async {
    return true;
  }

  @override
  Future<List<AccountModel>> saveBankingInfo(BankRequestData data) async {
    final data = await jsonReader("accounts_success", delay);
    return List<dynamic>.from(data["accounts"]).map((dynamic account) => AccountModel.fromJson(account)).toList();
  }

  @override
  Future<bool> confirmPhone(String pin) async {
    return true;
  }

  @override
  Future<bool> confirmEmail(String pin) async {
    return true;
  }

  @override
  Future<bool> confirmPhoneCode(String phone, String pin) async {
    return true;
  }

  @override
  Future<bool> resendPhoneCode() async {
    return true;
  }

  @override
  Future<bool> resendEmailCode() async {
    return true;
  }

  @override
  Future<RateData> saveUploadData(UploadRequestData data) async {
    final data = await jsonReader("rate_success", delay);
    return RateData.fromJson(data);
  }

  @override
  Future<bool> savePictureInfo(File image) async {
    return true;
  }

  @override
  Future<DashboardData> fetchDashboard(SortType duration) async {
    final data = await jsonReader("dashboard_success", delay);
    return DashboardData.fromJson(data);
  }

  @override
  Future<String> completeForgotPassword(PasswordResetData data) async {
    return "Success";
  }

  @override
  Future<String> changePassword(PasswordRequestData data) async {
    return "Success";
  }

  @override
  Future<bool> startForgotPassword(String phone) async {
    return true;
  }

  @override
  Future<List<AccountModel>> setDefaultAccount(int id) async {
    final data = await jsonReader("accounts_success", delay);
    return List<dynamic>.from(data["accounts"]).map((dynamic account) => AccountModel.fromJson(account)).toList();
  }

  @override
  Future<String> deleteFile(int id) async {
    return "Success";
  }

  @override
  Future<String> deleteFileGroup(String name) async {
    return "Success";
  }

  @override
  Future<List<String>> fetchRequestedFiles() async {
    return ["hello", "world", "again"];
  }

  @override
  Future<String> uploadFile(UploadFileRequestData data) async {
    return "Success";
  }
}
