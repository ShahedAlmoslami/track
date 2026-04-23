import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track/data/models/comment_model.dart';
import 'package:track/logic/comments/comment_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit() : super(CommentsInitial());

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const int _pageSize = 10;

  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  bool _hasMore = true;
  bool _isLoading = false;

  CollectionReference<Map<String, dynamic>> _col(String placeId) =>
      _db.collection('places').doc(placeId).collection('comments');

  Future<void> fetchFirstPage(String placeId) async {
    if (_isLoading) return;
    _isLoading = true;
    emit(CommentsLoading());

    try {
      _lastDoc = null;
      _hasMore = true;

      final q = await _col(placeId)
          .orderBy('createdAt', descending: true)
          .limit(_pageSize)
          .get();

      final docs = q.docs;
      final comments =
          docs.map((d) => CommentModel.fromDoc(placeId: placeId, doc: d)).toList();

      _lastDoc = docs.isNotEmpty ? docs.last : null;
      _hasMore = docs.length == _pageSize;

      emit(CommentsLoaded(comments: comments, hasMore: _hasMore));
    } catch (e) {
      emit(CommentsError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  /// تحميل المزيد (Pagination)
  Future<void> fetchNextPage(String placeId) async {
    final current = state;
    if (current is! CommentsLoaded) return;
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    emit(current.copyWith(loadingMore: true));

    try {
      Query<Map<String, dynamic>> query = _col(placeId)
          .orderBy('createdAt', descending: true)
          .limit(_pageSize);

      if (_lastDoc != null) {
        query = query.startAfterDocument(_lastDoc!);
      }

      final q = await query.get();
      final docs = q.docs;

      final newComments =
          docs.map((d) => CommentModel.fromDoc(placeId: placeId, doc: d)).toList();

      _lastDoc = docs.isNotEmpty ? docs.last : _lastDoc;
      _hasMore = docs.length == _pageSize;

      emit(CommentsLoaded(
        comments: [...current.comments, ...newComments],
        hasMore: _hasMore,
        loadingMore: false,
      ));
    } catch (e) {
      // خليه يرجّع للحالة القديمة بدون loadingMore
      emit(current.copyWith(loadingMore: false));
    } finally {
      _isLoading = false;
    }
  }

  /// إضافة تعليق
  Future<void> addComment({
    required String placeId,
    required String userId,
    required String userName,
    required String text,
    String? userAvatar,
    double? rating,
  }) async {
    if (text.trim().isEmpty) return;

    emit(CommentSubmitting());

    try {
      final docRef = _col(placeId).doc();
      final model = CommentModel(
        id: docRef.id,
        placeId: placeId,
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        text: text.trim(),
        rating: rating,
        createdAt: DateTime.now(),
      );

      await docRef.set(model.toMap());

      emit(CommentSubmitSuccess());

      // بعد الإضافة: نزّل أول صفحة من جديد (عشان يظهر فوق)
      await fetchFirstPage(placeId);
    } catch (e) {
      emit(CommentSubmitError(e.toString()));
    }
  }
}
