xcode:
	open ios/Runner.xcworkspace

test_coverage:
	flutter test --no-pub --coverage

build_coverage:
	make test_coverage && genhtml -o coverage coverage/lcov.info

open_coverage:
	make build_coverage && open coverage/index.html

built_value_build:
	flutter packages pub run build_runner build --delete-conflicting-outputs

built_value_watch:
	flutter packages pub run build_runner watch --delete-conflicting-outputs

# iOS
mock_ios:
	flutter build ios --flavor mock --dart-define=env.mode=mock

prod_ios:
	flutter build ios --flavor prod --dart-define=env.mode=prod

staging_ios:
	flutter build ios --flavor staging --dart-define=env.mode=staging

install_ios_dev:
	flutter build ios --flavor dev --dart-define=env.mode=dev && flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039

install_ios_mock:
	make mock_ios && flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039

install_ios_prod:
	make prod_ios && flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039

install_ios_staging:
	make staging_ios && flutter install -d aa61c6e8701a763b7aa199eea33bbc5bb708b039

# Android
mock_android:
	flutter build apk --flavor mock --dart-define=env.mode=mock

prod_android:
	flutter build apk --flavor prod --dart-define=env.mode=prod

staging_android:
	flutter build apk --flavor staging --dart-define=env.mode=staging

install_android_dev:
	flutter build apk --flavor dev --dart-define=env.mode=dev && flutter install -d 2a71eab236027ece

install_android_mock:
	make mock_android && flutter install -d 2a71eab236027ece

install_android_staging:
	make staging_android && flutter install -d 2a71eab236027ece

install_android_prod:
	make prod_android && flutter install -d 2a71eab236027ece
