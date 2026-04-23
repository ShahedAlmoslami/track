import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track/data/models/comment_model.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<CommentModel> comments;
  final bool hasMore;
  final bool loadingMore;

  CommentsLoaded({
    required this.comments,
    required this.hasMore,
    this.loadingMore = false,
  });

  CommentsLoaded copyWith({
    List<CommentModel>? comments,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

class CommentsError extends CommentsState {
  final String message;
  CommentsError(this.message);
}

class CommentSubmitting extends CommentsState {}

class CommentSubmitSuccess extends CommentsState {}

class CommentSubmitError extends CommentsState {
  final String message;
  CommentSubmitError(this.message);
}

class PaginationCursor {
  final DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  const PaginationCursor(this.lastDoc);
}
