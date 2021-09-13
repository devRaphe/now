import 'package:borome/services/contacts_client.dart';
import 'package:borome/services/exceptions.dart';
import 'package:clock/clock.dart';
import 'package:faker/faker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final client = ContactsClient();

  group("ContactsClient", () {
    test("works normally", () async {
      final contacts = List.generate(1, (i) => contactMapFn());
      _channel.setMockMethodCallHandler(getContacts(contacts));

      final result = await client.fetchContacts();
      expect(result.length, 1);
      expect(result.first.email, contacts.first["emails"].first["value"]);
      expect(result.first.phone, contacts.first["phones"].first["value"]);

      _channel.setMockMethodCallHandler(null);
    });

    test("works normally without contacts", () async {
      _channel.setMockMethodCallHandler(getContacts([]));

      final result = await client.fetchContacts();
      expect(result.length, 0);

      _channel.setMockMethodCallHandler(null);
    });

    test("works normally without emails", () async {
      final contacts = List.generate(1, (i) => contactMapFn(emails: 0));
      _channel.setMockMethodCallHandler(getContacts(contacts));

      final result = await client.fetchContacts();
      expect(result.length, 1);
      expect(result.first.email, "");
      expect(result.first.phone, contacts.first["phones"].first["value"]);

      _channel.setMockMethodCallHandler(null);
    });

    test("works normally without phones", () async {
      final contacts = List.generate(1, (i) => contactMapFn(phones: 0));
      _channel.setMockMethodCallHandler(getContacts(contacts));

      final result = await client.fetchContacts();
      expect(result.length, 1);
      expect(result.first.email, contacts.first["emails"].first["value"]);
      expect(result.first.phone, "");

      _channel.setMockMethodCallHandler(null);
    });

    test("handles errors gracefully", () async {
      _channel.setMockMethodCallHandler(getContacts([], error: PlatformException(code: "1")));

      expect(() => client.fetchContacts(), throwsA(isA<AppException>()));

      _channel.setMockMethodCallHandler(null);
    });
  });
}

const MethodChannel _channel = MethodChannel('github.com/clovisnicolas/flutter_contacts');

dynamic Function(MethodCall) getContacts(List<Map<String, dynamic>> contacts, {dynamic error}) {
  return (MethodCall methodCall) async {
    if (methodCall.method == "getContacts") {
      if (error != null) {
        throw error;
      }
      return contacts;
    }
    return null;
  };
}

final contactMapFn = ({int emails = 2, int phones = 2}) => <String, dynamic>{
      "identifier": faker.randomGenerator.string(6, min: 6),
      "displayName": faker.person.name(),
      "givenName": faker.person.name(),
      "middleName": faker.person.name(),
      "familyName": faker.person.name(),
      "prefix": faker.person.prefix(),
      "suffix": faker.person.suffix(),
      "company": faker.company.name(),
      "jobTitle": faker.company.position(),
      "androidAccountType": "",
      "androidAccountName": "",
      "emails": List.generate(emails, (i) => {"label": "label", "value": faker.internet.disposableEmail()}),
      "phones": List.generate(phones, (i) => {"label": "label", "value": faker.randomGenerator.numbers(9, 10).join()}),
      "postalAddresses": null,
      "avatar": null,
      "birthday": clock.now().toString()
    };
