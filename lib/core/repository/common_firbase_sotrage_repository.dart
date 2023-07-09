import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageProvider =
    Provider<CommonFirebaseStorageRepository>((ref) {
  return CommonFirebaseStorageRepository(
      firebaseStorage: FirebaseStorage.instance);
});

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRepository({required this.firebaseStorage});

  // Stores a file to firebase storage and return the url
  Future<String> storeFileToFirebase(String ref, File file) async {
    // upload a file to a specific path "ref" on firebaseStorage
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
