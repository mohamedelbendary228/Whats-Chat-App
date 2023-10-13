import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectGroupContactsProvider = StateProvider<List<Contact>>((ref) => []);
