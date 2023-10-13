import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedGroupContactsProvider = StateProvider<List<Contact>>((ref) => []);
