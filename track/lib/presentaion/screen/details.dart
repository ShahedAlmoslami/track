import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/services/place_model.dart';
import 'package:track/logic/experience_model.dart/Cubit.dart';
import 'package:track/logic/experience_model.dart/state.dart';
import 'package:track/presentaion/widgets/button_with_row.dart';
import 'package:track/presentaion/widgets/details.dart';
import 'package:track/presentaion/widgets/experience.dart';

class DetailsScreen extends StatefulWidget {
  final String placeId;
  const DetailsScreen({super.key, required this.placeId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ExperienceCuibt(PlacesRepo())..getExperience(widget.placeId),
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
                      child: DetailsWidget(
                        itemCount: 3,
                        detailsName: "Mountain View",
                        rating: "4.5",
                        imageName: [
                          'assets/images/details.png',
                        ],
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
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Comment',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: ButtonwithRow(
                        buttonHight: 60,
                        buttonWidth: 336,
                        buttonText: "Book Now",
                      ),
                    ),

                    const SizedBox(height: 16),

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

                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // ===== Activities (Experiences) =====
              BlocBuilder<ExperienceCuibt, ExperienceState>(
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

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final exp = state.experiences[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ExperienceWidget(
                              images: exp.images ?? const [],
                              experience: exp.title ?? '',
                              price: '\$${exp.price ?? 0}',
                            ),
                          );
                        }, childCount: state.experiences.length),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
