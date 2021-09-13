@TestOn('vm')
import 'dart:convert';

import 'package:borome/constants.dart';
import 'package:borome/data.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../models.dart';
import '../request.dart';

class AuthMockRequest extends MockRequestImpl {
  @override
  Future<http.Response> get(String url) async {
    switch (url) {
      case "/${Endpoints.dashboard}?duration=day":
      case "/${Endpoints.dashboard}?duration=month":
      case "/${Endpoints.dashboard}?duration=year":
      case "/${Endpoints.dashboard}?duration=all":
        return http.Response(await jsonRawReader("dashboard_success"), 200);
      case Endpoints.requestedFiles:
        return http.Response(
          json.encode({
            "requested_files": [
              {"name": "a"},
              {"name": "b"},
              {"name": "c"}
            ]
          }),
          200,
        );
      case Endpoints.resendPhoneCode:
      case Endpoints.resendEmailCode:
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }

  @override
  Future<http.Response> post(String url) async {
    switch (url) {
      case Endpoints.profile:
        return http.Response(await jsonRawReader("profile"), 200);
      case Endpoints.profileStatus:
        return http.Response(await jsonRawReader("profile_status_success"), 200);
      case Endpoints.signUp:
        return http.Response(await jsonRawReader("signup_success"), 200);
      case Endpoints.saveDataUpload:
        return http.Response(await jsonRawReader("rate_success"), 200);
      case Endpoints.signIn:
        return http.Response(await jsonRawReader("login_success"), 200);
      case Endpoints.saveContactInformation:
      case Endpoints.savePersonalInformation:
      case Endpoints.saveNextOfKinInformation:
      case Endpoints.saveWorkInformation:
        return http.Response(await jsonRawReader("user_update_success"), 200);
      case Endpoints.saveBankingInformation:
      case Endpoints.makeAccountDefault:
        return http.Response(await jsonRawReader("accounts_success"), 200);
      case Endpoints.finishForgotPassword:
      case Endpoints.updatePassword:
      case Endpoints.saveOtherInformation:
      case Endpoints.confirmPhone:
      case Endpoints.confirmEmail:
      case Endpoints.confirmPhoneCode:
      case Endpoints.startForgotPassword:
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }

  @override
  Future<http.Response> delete(String url) async {
    switch (url) {
      case "${Endpoints.fileDetails}?fid=1":
      case "${Endpoints.files}?file_name=a":
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }

  @override
  Future<http.Response> form(String url) async {
    switch (url) {
      case Endpoints.addFile:
      case Endpoints.saveProfileImage:
      default:
        return http.Response("{}", 200, reasonPhrase: "");
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("AuthRepository", () {
    run("Impl", AuthImpl(request: MockRequest(AuthMockRequest()), isDev: true));
    run("MockImpl", AuthMockImpl(Duration.zero));
  });
}

void run(String title, AuthRepository repo) {
  group("$title", () {
    test("getAccount", () async {
      expect(await repo.getAccount(), isA<UserModel>());
    });

    test("getProfileStatus", () async {
      expect(await repo.getProfileStatus(), isA<ProfileStatusModel>());
    });

    test("signIn", () async {
      expect(
        await repo.signIn(LoginRequestData(phone: "a", password: "b", deviceId: "12345")),
        isA<LoginResponseData>(),
      );
    });

    test("signUp", () async {
      expect(await repo.signUp(SignupRequestData(deviceId: "12345")), isA<Pair<int, String>>());
    });

    test("savePersonalInfo", () async {
      expect(await repo.savePersonalInfo(PersonalInfoRequestData()), isA<UserModel>());
    });

    test("saveContactInfo", () async {
      expect(await repo.saveContactInfo(ContactInfoRequestData()), isA<UserModel>());
    });

    test("saveWorkDetails", () async {
      expect(await repo.saveWorkDetails(WorkDetailsRequestData()), isA<UserModel>());
    });

    test("saveNextOfKinDetails", () async {
      expect(await repo.saveNextOfKinDetails(NextOfKinRequestData()), isA<UserModel>());
    });

    test("saveBankingInfo", () async {
      expect(await repo.saveBankingInfo(BankRequestData()), isA<List<AccountModel>>());
    });

    test("saveOtherInfo", () async {
      expect(await repo.saveOtherInfo(OtherInfoRequestData()), isA<bool>());
    });

    test("savePictureInfo", () async {
      expect(await repo.savePictureInfo(MockFile()), isA<bool>());
    });

    test("confirmPhone", () async {
      expect(await repo.confirmPhone(""), isA<bool>());
    });

    test("confirmEmail", () async {
      expect(await repo.confirmEmail(""), isA<bool>());
    });

    test("confirmPhoneCode", () async {
      expect(await repo.confirmPhoneCode("", ""), isA<bool>());
    });

    test("resendPhoneCode", () async {
      expect(await repo.resendPhoneCode(), isA<bool>());
    });

    test("resendEmailCode", () async {
      expect(await repo.resendEmailCode(), isA<bool>());
    });

    test("saveUploadData", () async {
      final data = UploadRequestData(contacts: [], location: LocationData(lng: 1, lat: 2), os: "os");
      expect(await repo.saveUploadData(data), isA<RateData>());
    });

    test("fetchDashboard", () async {
      expect(await repo.fetchDashboard(SortType.month), isA<DashboardData>());
    });

    test("startForgotPassword", () async {
      expect(await repo.startForgotPassword(""), isA<bool>());
    });

    test("completeForgotPassword", () async {
      expect(await repo.completeForgotPassword(PasswordResetData(phone: "", password: "", code: "")), isA<String>());
    });

    test("uploadFile", () async {
      expect(await repo.uploadFile(UploadFileRequestData(file: MockFile(), description: "", name: "")), isA<String>());
    });

    test("deleteFile", () async {
      expect(await repo.deleteFile(1), isA<String>());
    });

    test("deleteFileGroup", () async {
      expect(await repo.deleteFileGroup(""), isA<String>());
    });

    test("fetchRequestedFiles", () async {
      expect(await repo.fetchRequestedFiles(), isA<List<String>>());
    });

    test("changePassword", () async {
      expect(await repo.changePassword(PasswordRequestData()), isA<String>());
    });

    test("setDefaultAccount", () async {
      expect(await repo.setDefaultAccount(1), isA<List<AccountModel>>());
    });
  });
}
