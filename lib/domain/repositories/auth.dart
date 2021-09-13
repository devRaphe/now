import 'dart:io' as io;

import '../models.dart';
import '../primitives.dart';

abstract class AuthRepository {
  Future<LoginResponseData> signIn(LoginRequestData data);

  Future<Pair<int, String>> signUp(SignupRequestData data);

  Future<UserModel> getAccount();

  Future<ProfileStatusModel> getProfileStatus();

  Future<UserModel> savePersonalInfo(PersonalInfoRequestData data);

  Future<UserModel> saveContactInfo(ContactInfoRequestData data);

  Future<UserModel> saveWorkDetails(WorkDetailsRequestData data);

  Future<UserModel> saveNextOfKinDetails(NextOfKinRequestData data);

  Future<List<AccountModel>> saveBankingInfo(BankRequestData data);

  Future<bool> saveOtherInfo(OtherInfoRequestData data);

  Future<bool> savePictureInfo(io.File image);

  Future<bool> confirmPhone(String pin);

  Future<bool> confirmEmail(String pin);

  Future<bool> confirmPhoneCode(String phone, String pin);

  Future<bool> resendPhoneCode();

  Future<bool> resendEmailCode();

  Future<RateData> saveUploadData(UploadRequestData data);

  Future<DashboardData> fetchDashboard(SortType duration);

  Future<bool> startForgotPassword(String phone);

  Future<String> completeForgotPassword(PasswordResetData data);

  Future<String> uploadFile(UploadFileRequestData data);

  Future<String> deleteFile(int id);

  Future<String> deleteFileGroup(String name);

  Future<List<String>> fetchRequestedFiles();

  Future<String> changePassword(PasswordRequestData data);

  Future<List<AccountModel>> setDefaultAccount(int id);
}
