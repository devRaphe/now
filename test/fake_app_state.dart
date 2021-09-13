import 'package:borome/domain.dart';
import 'package:borome/store.dart';
import 'package:built_collection/built_collection.dart';
import 'package:clock/clock.dart';
import 'package:faker/faker.dart';

AppState fakeAppState() {
  final setupModel = SetUpData(
    banks: [],
    heardFrom: [],
    industry: [],
    occupation: [],
    states: [],
    workStatus: [],
    relationships: [],
    loanReasons: [],
    cities: <String, List<String>>{"A": []},
    bankImages: <String, String>{"A": ""},
    fees: FeesModel.empty(),
    paymentUrl: '',
  );
  final userModel = UserModel(
    (b) => b
      ..id = 1
      ..email = faker.internet.email()
      ..phone = "080${faker.randomGenerator.numbers(9, 8).join()}"
      ..address = faker.address.streetAddress()
      ..state = faker.address.citySuffix()
      ..city = faker.address.city()
      ..landmark = faker.address.city()
      ..maritalStatus = "Single"
      ..firstname = faker.person.firstName()
      ..surname = faker.person.lastName()
      ..dob = "12-02-1991"
      ..gender = "Male"
      ..educationLevel = "University"
      ..workStatus = "Employee"
      ..industry = "IT"
      ..occupation = faker.company.position()
      ..companyName = faker.company.name()
      ..companyPhone = "080${faker.randomGenerator.numbers(9, 8).join()}"
      ..companyAddress = faker.address.streetAddress()
      ..payday = "3"
      ..monthlyIncome = "100000.00"
      ..guarantorName = faker.person.name()
      ..guarantorPhone = "080${faker.randomGenerator.numbers(9, 8).join()}"
      ..guarantorEmail = faker.internet.disposableEmail()
      ..guarantorRelationship = "sister"
      ..refCode = "BMNE1U1P"
      ..bvn = faker.randomGenerator.numbers(9, 11).join()
      ..isPhoneVerified = 1
      ..isEmailVerified = 1
      ..isBanned = 0
      ..isBvnVerified = 0
      ..hasActiveLoan = 1
      ..isProfileComplete = 0
      ..hasTakenLoan = 1
      ..canEdit = 1
      ..creditScore = 100
      ..status = "verified"
      ..createdAt = clock.now()
      ..virtualAccountNumber = "1232343545"
      ..virtualBankName = "My Bank"
      ..repaymentAccountNumber = "1232343545"
      ..repaymentAccountName = "Account Name"
      ..repaymentBankName = "My Bank"
      ..eligibleAmount = "1234"
      ..accounts = ListBuilder(
        <AccountModel>[
          AccountModel(
            (b) => b
              ..id = 1
              ..userId = 1
              ..accountBank = faker.company.name()
              ..bankCode = faker.randomGenerator.numbers(9, 3).join()
              ..accountName = faker.person.name()
              ..accountNumber = faker.randomGenerator.numbers(9, 10).join()
              ..accountVerified = 0
              ..createdAt = clock.now()
              ..isDefault = 0,
          ),
        ],
      )
      ..files = ListBuilder(
        <FileModel>[
          FileModel(
            (b) => b
              ..id = 2
              ..userId = 1
              ..name = faker.company.name()
              ..description = faker.lorem.word()
              ..url = faker.internet.httpsUrl()
              ..status = "pending"
              ..createdAt = clock.now(),
          ),
        ],
      ),
  );
  final dashboardModel = DashboardData(
    maxRate: 2000,
    duration: SortType.all,
    adImage: null,
    lastLoan: null,
    loans: [],
  );
  final listOfNoticeModel = <NoticeModel>[
    NoticeModel(
      (b) => b
        ..id = 1
        ..isRead = 0
        ..from = "2"
        ..sentBy = "5"
        ..createdAt = clock.now()
        ..images = ListBuilder(<String>[])
        ..userId = 1
        ..content = faker.lorem.sentence()
        ..title = faker.lorem.word(),
    ),
  ];
  final profileStatusModel = ProfileStatusModel(
    (b) => b
      ..workId = true
      ..profileImage = true
      ..nokInformation = true
      ..workInformation = true
      ..contactInformation = true
      ..personalInformation = true
      ..bankAccount = true
      ..bankAccountConnectionLink = 'link'
      ..paymentVerification = true
      ..paymentVerificationLink = 'link',
  );
  return AppState(
    (b) => b
      ..user = SubState(value: userModel)
      ..setup = SubState(value: setupModel)
      ..profileStatus = SubState(value: profileStatusModel)
      ..dashboard = SubState(value: dashboardModel)
      ..notice = SubState(value: listOfNoticeModel),
  );
}
