import 'dart:io';

import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/services.dart';
import 'package:borome/utils.dart';
import 'package:flutter/foundation.dart';

class AuthImpl implements AuthRepository {
  AuthImpl({@required this.request, @required this.isDev});

  final Request request;
  final bool isDev;

  @override
  Future<UserModel> getAccount() async {
    final res = Response<dynamic>(await request.post(Endpoints.profile, <String, String>{}), isDev: isDev);
    final Map<String, dynamic> user = res.rawData['user'];
    return UserModel.fromJson(
      user
        ..putIfAbsent('files', () => res.rawData['files'])
        ..putIfAbsent('accounts', () => res.rawData['accounts']),
    );
  }

  @override
  Future<ProfileStatusModel> getProfileStatus() async {
    final res = Response<dynamic>(await request.post(Endpoints.profileStatus, <String, String>{}), isDev: isDev);
    return ProfileStatusModel.fromJson(res.rawData);
  }

  @override
  Future<LoginResponseData> signIn(LoginRequestData data) async {
    final res = Response<LoginResponseData>(
      await request.post(Endpoints.signIn, data.toMap(), headers: {'Is-New-App': 'true', 'Device-Id': data.deviceId}),
      isDev: isDev,
      onTransform: (dynamic data, status, message) {
        if (status.isOk || status.isForbidden) {
          return LoginResponseData(
            user: UserModel.fromJson(data['user']),
            token: data['token'],
            message: message,
          );
        }

        throw BadRequestException(status.status, message);
      },
    );
    return res.data;
  }

  @override
  Future<Pair<int, String>> signUp(SignupRequestData data) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.signUp, data.toMap()),
      isDev: isDev,
    );
    return Pair<int, String>(res.rawData['user']['uid'], res.rawData['token']);
  }

  @override
  Future<UserModel> saveContactInfo(ContactInfoRequestData data) async {
    final res = Response<dynamic>(await request.post(Endpoints.saveContactInformation, data.toMap()), isDev: isDev);
    return UserModel.fromJson(res.rawData['user']);
  }

  @override
  Future<UserModel> savePersonalInfo(PersonalInfoRequestData data) async {
    final res = Response<dynamic>(await request.post(Endpoints.savePersonalInformation, data.toMap()), isDev: isDev);
    return UserModel.fromJson(res.rawData['user']);
  }

  @override
  Future<UserModel> saveNextOfKinDetails(NextOfKinRequestData data) async {
    final res = Response<dynamic>(await request.post(Endpoints.saveNextOfKinInformation, data.toMap()), isDev: isDev);
    return UserModel.fromJson(res.rawData['user']);
  }

  @override
  Future<UserModel> saveWorkDetails(WorkDetailsRequestData data) async {
    final res = Response<dynamic>(await request.post(Endpoints.saveWorkInformation, data.toMap()), isDev: isDev);
    return UserModel.fromJson(res.rawData['user']);
  }

  @override
  Future<bool> saveOtherInfo(OtherInfoRequestData data) async {
    final res = Response<dynamic>(await request.post(Endpoints.saveOtherInformation, data.toMap()), isDev: isDev);
    return res.status.isOk;
  }

  @override
  Future<List<AccountModel>> saveBankingInfo(BankRequestData data) async {
    final res = Response<dynamic>(await request.post(Endpoints.saveBankingInformation, data.toMap()), isDev: isDev);
    return List<dynamic>.from(res.rawData['accounts'])
        .map((dynamic account) => AccountModel.fromJson(account))
        .toList();
  }

  @override
  Future<bool> confirmPhone(String code) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.confirmPhone, <String, String>{'code': code}),
      isDev: isDev,
    );
    return res.status.isOk;
  }

  @override
  Future<bool> confirmEmail(String code) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.confirmEmail, <String, String>{'code': code}),
      isDev: isDev,
    );
    return res.status.isOk;
  }

  @override
  Future<bool> confirmPhoneCode(String phone, String code) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.confirmPhoneCode, <String, String>{'phone': phone, 'code': code}),
      isDev: isDev,
    );
    return res.status.isOk;
  }

  @override
  Future<bool> resendPhoneCode() async {
    final res = Response<dynamic>(await request.get(Endpoints.resendPhoneCode), isDev: isDev);
    return res.status.isOk;
  }

  @override
  Future<bool> resendEmailCode() async {
    final res = Response<dynamic>(await request.get(Endpoints.resendEmailCode), isDev: isDev);
    return res.status.isOk;
  }

  @override
  Future<RateData> saveUploadData(UploadRequestData data) async {
    final res = Response<dynamic>(
      await request.post(
        Endpoints.saveDataUpload,
        data.toMap(),
        options: Options(timeout: Duration(minutes: 5)),
      ),
      isDev: isDev,
    );
    return RateData.fromJson(res.rawData);
  }

  @override
  Future<bool> savePictureInfo(File image) async {
    final res = Response<dynamic>(
      await request.form(Endpoints.saveProfileImage, files: {'image': image}),
      isDev: isDev,
    );
    return res.status.isOk;
  }

  @override
  Future<DashboardData> fetchDashboard(SortType duration) async {
    final res = Response<dynamic>(
      await request.post(
        '${Endpoints.dashboard}?duration=${duration.value}',
        <String, String>{},
        options: Options(cache: true),
      ),
      isDev: isDev,
    );
    return DashboardData.fromJson(res.rawData);
  }

  @override
  Future<String> completeForgotPassword(PasswordResetData data) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.finishForgotPassword, data.toMap()),
      isDev: isDev,
    );
    return res.message;
  }

  @override
  Future<String> changePassword(PasswordRequestData data) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.updatePassword, data.toMap()),
      isDev: isDev,
    );
    return res.message;
  }

  @override
  Future<bool> startForgotPassword(String phone) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.startForgotPassword, <String, String>{'phone': phone}),
      isDev: isDev,
    );
    return res.status.isOk;
  }

  @override
  Future<List<AccountModel>> setDefaultAccount(int id) async {
    final res = Response<dynamic>(
      await request.post(Endpoints.makeAccountDefault, <String, int>{'accountid': id}),
      isDev: isDev,
    );
    return List<dynamic>.from(res.rawData['accounts'])
        .map((dynamic account) => AccountModel.fromJson(account))
        .toList();
  }

  @override
  Future<String> deleteFile(int id) async {
    final res = Response<dynamic>(await request.delete('/${Endpoints.fileDetails}?fid=$id'), isDev: isDev);
    return res.message;
  }

  @override
  Future<String> deleteFileGroup(String name) async {
    final res = Response<dynamic>(await request.delete('${Endpoints.files}?file_name=$name'), isDev: isDev);
    return res.message;
  }

  @override
  Future<List<String>> fetchRequestedFiles() async {
    final res = Response<dynamic>(await request.get(Endpoints.requestedFiles), isDev: isDev);
    return List<dynamic>.from(res.rawData['requested_files']).map((dynamic item) => item['name'].toString()).toList();
  }

  @override
  Future<String> uploadFile(UploadFileRequestData data) async {
    final res = Response<dynamic>(
      await request.form(
        Endpoints.addFile,
        data: data.toMap(),
        files: {'file': data.file},
        options: Options(timeout: const Duration(minutes: 5)),
      ),
      isDev: isDev,
    );
    return res.message;
  }
}
