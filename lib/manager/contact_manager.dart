import 'dart:async';

import 'package:githubflutters/model/contact.dart';
import 'package:githubflutters/service/contact_service.dart';

class ContactManager {
  final StreamController<int> _contactCounter = StreamController<int>();
  Stream<int> get contactCounter => _contactCounter.stream;

  Stream<List<Contact>> get containListView async* {
    yield await ContactService.browse();
  }

  ContactManager() {
    containListView.listen((list) => _contactCounter.add(list.length));
  }
}
