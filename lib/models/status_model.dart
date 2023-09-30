class StatusModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> statusImagesUrls;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSeeStatus;

  StatusModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.statusImagesUrls,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSeeStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': statusImagesUrls,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSeeStatus,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> json) {
    return StatusModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      statusImagesUrls: List<String>.from(json['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      profilePic: json['profilePic'] ?? '',
      statusId: json['statusId'] ?? '',
      whoCanSeeStatus: List<String>.from(json['whoCanSee']),
    );
  }
}
