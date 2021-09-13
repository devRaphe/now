import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';

import 'coordinators.dart';
import 'error_handling.dart';
import 'repository.dart';
import 'screens.dart';
import 'services.dart';

class Registry {
  Registry() : _injector = Injector.appInstance {
    _injector.registerSingleton<Registry>(() => this);
  }

  static Registry get di => Injector.appInstance.get<Registry>();

  final Injector _injector;

  void add<T>(T instance) {
    _injector.registerDependency<T>(() => instance);
  }

  @visibleForTesting
  void replace<T>(T instance) {
    _injector.registerDependency<T>(() => instance, override: true);
  }

  @visibleForTesting
  void dispose() {
    _injector.clearAll();
  }
}

extension RegistryX on Registry {
  Repository get repository => _injector.get<Repository>();

  Session get session => _injector.get<Session>();

  Permissions get permissions => _injector.get<Permissions>();

  AppDeviceInfo get appDeviceInfo => _injector.get<AppDeviceInfo>();

  SharedPrefs get sharedPref => _injector.get<SharedPrefs>();

  LoanApplicationService get loanApplication => _injector.get<LoanApplicationService>();

  ErrorReporter get error => _injector.get<ErrorReporter>();

  CameraClient get camera => _injector.get<CameraClient>();

  LocalAuthService get localAuth => _injector.get<LocalAuthService>();

  ContactsClient get contacts => _injector.get<ContactsClient>();

  LocationClient get location => _injector.get<LocationClient>();

  Coordinator get coordinator => _injector.get<Coordinator>();
}
