import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String placeId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String text;
  final double? rating;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.text,
    this.rating,
    required this.createdAt,
  });

  factory CommentModel.fromDoc({
    required String placeId,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    final data = doc.data() ?? {};
    final ts = data['createdAt'];

    return CommentModel(
      id: doc.id,
      placeId: placeId,
      userId: (data['userId'] ?? '').toString(),
      userName: (data['userName'] ?? '').toString(),
      userAvatar: data['userAvatar']?.toString(),
      text: (data['text'] ?? '').toString(),
      rating: data['rating'] == null ? null : (data['rating'] as num).toDouble(),
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'text': text,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
