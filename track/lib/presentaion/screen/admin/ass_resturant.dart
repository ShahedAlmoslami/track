// add_resturant_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/restaurantModel.dart';

import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/data/services/place_rep.dart' as repo;
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/presentaion/screen/admin/function.dart';

class AddResturantScreen extends StatefulWidget {
  const AddResturantScreen({super.key});

  @override
  State<AddResturantScreen> createState() => _AddResturantScreenState();
}

class _AddResturantScreenState extends State<AddResturantScreen> {
  final formKey = GlobalKey<FormState>();

  final cityIdController = TextEditingController();
  final nameController = TextEditingController();

  // cover url
  final coverController = TextEditingController();

  final ratingController = TextEditingController();
  final reviewsController = TextEditingController(); // optional
  final cuisinesController = TextEditingController(); // Egyptian, Italian

  // lista images
  List<String> uploadedImageUrls = [];

  bool uploadingCover = false;
  bool uploadingList = false;

  @override
  void dispose() {
    cityIdController.dispose();
    nameController.dispose();
    coverController.dispose();
    ratingController.dispose();
    reviewsController.dispose();
    cuisinesController.dispose();
    super.dispose();
  }

  // ✅ cover: single image
  Future<void> uploadCover(BuildContext ctx) async {
    final url = await pickAndUploadSingleImage(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) => setState(() => uploadingCover = loading),
    );

    if (url == null) return;

    setState(() => coverController.text = url);
  }

  // ✅ lista: multi images
  Future<void> uploadList(BuildContext ctx) async {
    final urls = await pickAndUploadMultiImages(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) => setState(() => uploadingList = loading),
    );

    if (urls.isEmpty) return;

    setState(() {
      uploadedImageUrls
        ..clear()
        ..addAll(urls);
    });
  }

  List<String>? _parseCuisines() {
    final text = cuisinesController.text.trim();
    if (text.isEmpty) return null;

    final list = text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return list.isEmpty ? null : list;
  }

  // ✅ SUBMIT (مضافة)
  void submit(BuildContext ctx) {
    if (!formKey.currentState!.validate()) return;

    final cityId = cityIdController.text.trim();
    final name = nameController.text.trim();

    final rating = double.tryParse(ratingController.text.trim()) ?? 0.0;

    final reviewsText = reviewsController.text.trim();
    final reviews = reviewsText.isEmpty
        ? null
        : (int.tryParse(reviewsText) ?? 0);

    final cover = coverController.text.trim();
    final cuisines = _parseCuisines();

    // لازم يكون في صورة cover أو صورة على الأقل في الليست
    final mainImage = cover.isNotEmpty
        ? cover
        : (uploadedImageUrls.isNotEmpty ? uploadedImageUrls.first : '');

    if (mainImage.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Please upload a cover or at least one image'),
        ),
      );
    }

    final restaurant = RestaurantModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cityId: cityId,
      name: name,
      imageUrl: mainImage,
      rating: rating,
      reviews: reviews,
      cuisines: cuisines,
      imageList: uploadedImageUrls.isEmpty
          ? null
          : List<String>.from(uploadedImageUrls),
    );

    // ✅ لازم تكون موجودة في AdminCubit: addRestaurant(cityId, restaurant)
    ctx.read<AdminCubit>().addRestaurant(cityId, restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(repo.PlacesRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Restaurant (Admin)'),
          centerTitle: true,
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (ctx, state) {
            if (state is AdminSuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Restaurant added successfully')),
              );

              formKey.currentState?.reset();
              cityIdController.clear();
              nameController.clear();
              coverController.clear();
              ratingController.clear();
              reviewsController.clear();
              cuisinesController.clear();

              setState(() => uploadedImageUrls.clear());
            } else if (state is AdminError) {
              ScaffoldMessenger.of(
                ctx,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (ctx, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    appField(
                      cityIdController,
                      'City ID',
                      hint: 'City Id',
                      validator: (v) {
                        if ((v ?? '').trim().isEmpty) return 'Required';
                        return null;
                      },
                    ),

                    appField(nameController, 'Restaurant Name'),

                    const SizedBox(height: 10),

                    // -------- Cover --------
                    uploadingCover
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.image),
                            label: const Text('Upload Cover (Single)'),
                            onPressed: () => uploadCover(ctx),
                          ),

                    const SizedBox(height: 12),

                    appField(
                      coverController,
                      'Cover URL (Optional)',
                      requiredField: false,
                      onChanged: (_) => setState(() {}),
                    ),

                    if (coverController.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          coverController.text.trim(),
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Text('Cover URL is not a valid image'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // -------- List --------
                    uploadingList
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.collections),
                            label: const Text('Upload Images List (Multi)'),
                            onPressed: () => uploadList(ctx),
                          ),

                    const SizedBox(height: 8),
                    Text(
                      'List: ${uploadedImageUrls.length} images',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    if (uploadedImageUrls.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: uploadedImageUrls.map((url) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  url,
                                  width: 90,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const SizedBox(
                                    width: 90,
                                    height: 70,
                                    child: Center(child: Text('Error')),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () => setState(() {
                                    uploadedImageUrls.remove(url);
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // -------- Fields --------
                    appField(
                      ratingController,
                      'Rating (0 - 5)',
                      isNumber: true,
                    ),

                    appField(
                      reviewsController,
                      'Reviews (Optional)',
                      isNumber: true,
                      requiredField: false,
                    ),

                    appField(
                      cuisinesController,
                      'Cuisines (Optional)',
                      requiredField: false,
                      hint: 'مثال: Egyptian, Italian',
                    ),

                    const SizedBox(height: 24),

                    state is AdminLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => submit(ctx),
                            child: const Text('Add Restaurant'),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
