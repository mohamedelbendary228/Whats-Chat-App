import 'package:whats_chat_app/features/chats_contacts/repository/chats_contact_repository.dart';
import 'package:whats_chat_app/models/chat_contact_model.dart';

class ChatsContactsController {
  final ChatContactRepository chatContactRepository;

  ChatsContactsController({required this.chatContactRepository});

  Stream<List<ChatContact>> getChatContacts() {
    return chatContactRepository.getChatContacts();
  }
}
