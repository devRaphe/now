import 'package:borome/constants.dart';
import 'package:borome/domain.dart';
import 'package:borome/utils.dart';
import 'package:contacts_service/contacts_service.dart';

import 'exceptions.dart';

class ContactsClient {
  Future<List<ContactData>> fetchContacts() async {
    try {
      return (await ContactsService.getContacts(withThumbnails: false))
          .map((contact) => ContactData(
                name: contact.displayName,
                email: contact.emails.isEmpty ? "" : contact.emails.first.value,
                phone: contact.phones.isEmpty ? "" : contact.phones.first.value,
              ))
          .toList();
    } catch (e, st) {
      AppLog.e(e, st);
      throw AppException(AppStrings.contactsUnavailable);
    }
  }
}
