import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/comments/comment_state.dart';
import 'package:track/logic/experience/Cubit.dart';
import 'package:track/logic/experience/state.dart';
import 'package:track/presentaion/screen/book.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/button_with_row.dart';
import 'package:track/presentaion/widgets/details.dart';
import 'package:track/presentaion/widgets/experience.dart';

// ✅ imports التعليقات
import 'package:track/logic/comments/comments_cubit.dart';
import 'package:track/presentaion/widgets/smartButton.dart';

class DetailsScreen extends StatefulWidget {
  final String placeId;
  final String cityId;

  const DetailsScreen({
    super.key,
    required this.placeId,
    required this.cityId,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  bool forComments = false;
  bool forDetails = true;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExperienceCubit(PlacesRepo())
            ..getExperiences(widget.cityId, widget.placeId),
        ),
        BlocProvider(
          create: (_) => CommentsCubit()..fetchFirstPage(widget.placeId),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ===== Header / Details =====
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: BlocBuilder<ExperienceCubit, ExperienceState>(
                        builder: (context, state) {
                          if (state is ExperienceLoadingState) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is ExperienceErrorState) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text('Error: ${state.message}'),
                            );
                          }

                          if (state is ExperienceSuccessState) {
                            if (state.experiences.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No CoverImage Found'),
                              );
                            }

                            return DetailsWidget(
                              itemCount: 3,
                              expName: "pyramids",
                              rating: "4.5",
                              imageName: state.experiences[0].detailsImages,
                              idF: state.experiences[0].id!,
                              type: 'place',
                              idS: widget.placeId,
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'pyramids',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              forComments = false;
                              forDetails = true;
                              setState(() {});
                            },
                            child: Smartbutton(
                              forDetails: forDetails,
                              buttonName: 'Detalies',
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              forDetails = false;
                              forComments = true;
                              setState(() {});
                            },
                            child: Smartbutton(
                              forDetails: forComments,
                              buttonName: 'Comments',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookScreen(),
                            ),
                          );
                        },
                        child: ButtonwithRow(
                          buttonHight: 60,
                          buttonWidth: 336,
                          buttonText: "Book Now",
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (forDetails)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Activites',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ===== Activities (Experiences) =====
              BlocBuilder<ExperienceCubit, ExperienceState>(
                builder: (context, state) {
                  if (state is ExperienceLoadingState) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (state is ExperienceErrorState) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: ${state.message}'),
                      ),
                    );
                  }

                  if (state is ExperienceSuccessState) {
                    if (state.experiences.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: Text('No experiences found')),
                        ),
                      );
                    }

                    if (forDetails) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final exp = state.experiences[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ExperienceWidget(
                                  images: exp.images,
                                  experience: exp.title,
                                  price: exp.price,
                                ),
                              );
                            },
                            childCount: state.experiences.length,
                          ),
                        ),
                      );
                    }
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              // ===== Comments Header + Input =====
              if (forComments)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                final text = _commentController.text.trim();
                                if (text.isEmpty) return;

                                context.read<CommentsCubit>().addComment(
                                      placeId: widget.placeId,
                                      userId: 'userId',
                                      userName: 'userName',
                                      text: text,
                                    );

                                _commentController.clear();
                              },
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // ===== Comments List + Pagination =====
              if (forComments)
                BlocBuilder<CommentsCubit, CommentsState>(
                  builder: (context, state) {
                    if (state is CommentsLoading) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    }

                    if (state is CommentsError) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Error: ${state.message}'),
                        ),
                      );
                    }

                    if (state is CommentsLoaded) {
                      if (state.comments.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No comments yet'),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < state.comments.length) {
                                final c = state.comments[index];

                                if (index == state.comments.length - 2 &&
                                    state.hasMore &&
                                    !state.loadingMore) {
                                  context
                                      .read<CommentsCubit>()
                                      .fetchNextPage(widget.placeId);
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                              }

                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            childCount: state.comments.length +
                                (state.loadingMore ? 1 : 0),
                          ),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomBar(
          currentIndex: 1,
        ),
      ),
    );
  }
}