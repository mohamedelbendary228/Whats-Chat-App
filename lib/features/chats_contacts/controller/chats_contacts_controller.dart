import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_chat_app/features/chats_contacts/repository/chats_contact_repository.dart';
import 'package:whats_chat_app/models/chat_contact_model.dart';
import 'package:whats_chat_app/models/group_chat_model.dart';

final chatsContactsControllerProvider =
    Provider<ChatsContactsController>((ref) {
  final chatContactRepository = ref.watch(chatsContactsRepositoryProvider);
  return ChatsContactsController(chatContactRepository: chatContactRepository);
});

class ChatsContactsController {
  final ChatContactRepository chatContactRepository;

  ChatsContactsController({required this.chatContactRepository});

  Stream<List<ChatContact>> getChatContacts() {
    return chatContactRepository.getChatContacts();
  }

  Stream<List<GroupModel>> getChatGroups() {
    return chatContactRepository.getChatGroups();
  }
}
