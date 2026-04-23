import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/logic/comments/comment_state.dart';
import 'package:track/logic/comments/comments_cubit.dart';

class CommentsSheet extends StatelessWidget {
  final String placeId;
  final TextEditingController controller;

  const CommentsSheet({
    super.key,
    required this.placeId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Comments',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // ===== input =====
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;

                      context.read<CommentsCubit>().addComment(
                            placeId: placeId,
                            userId: 'userId',
                            userName: 'userName',
                            text: text,
                          );

                      controller.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== list =====
              Expanded(
                child: BlocBuilder<CommentsCubit, CommentsState>(
                  builder: (context, state) {
                    if (state is CommentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CommentsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }

                    if (state is CommentsLoaded) {
                      if (state.comments.isEmpty) {
                        return const Center(child: Text('No comments yet'));
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount:
                            state.comments.length + (state.loadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.comments.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (index == state.comments.length - 2 &&
                              state.hasMore &&
                              !state.loadingMore) {
                            context
                                .read<CommentsCubit>()
                                .fetchNextPage(placeId);
                          }

                          final c = state.comments[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(c.text),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
