import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:track/data/models/experience_model.dart';
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/presentaion/screen/admin/function.dart'; // appField + pickAndUploadMultiImages

class AddExperienceScreen extends StatefulWidget {
  const AddExperienceScreen({super.key});

  @override
  State<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final ratingController = TextEditingController();
  final reviewsController = TextEditingController();
  final placeIdController = TextEditingController();
  final cityIdController = TextEditingController();

  List<String> uploadedImageUrls = [];
  bool uploadingImage = false;
    bool uploadingImageForSingle = false;
  List<String> uploadedImage2 = [];


  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    ratingController.dispose();
    reviewsController.dispose();
    placeIdController.dispose();
    cityIdController.dispose();
    super.dispose();
  }
Future<void> uploadSingleImage(BuildContext ctx) async {
    final urls = await pickAndUploadSingleImage(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) => setState(() => uploadingImageForSingle = loading),
    );


    setState(() {
      uploadedImage2
        ..clear()
        ..add(urls!);});
  }
  Future<void> uploadImages(BuildContext ctx) async {
    final urls = await pickAndUploadMultiImages(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) => setState(() => uploadingImage = loading),
    );

    if (urls.isEmpty) return;

    setState(() {
      uploadedImageUrls
        ..clear()
        ..addAll(urls);
    });
  }

  void submit(BuildContext ctx) {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (uploadedImageUrls.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    final rating = double.tryParse(ratingController.text.trim()) ?? 0.0;
    final reviews = int.tryParse(reviewsController.text.trim()) ?? 0;
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;

    final experience = ExperienceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: nameController.text.trim(),
      detailsImages: uploadedImage2.isNotEmpty ? uploadedImage2.first : '',
      rating: rating,
      reviews: reviews,
      price: price,
      currency: 'EGP',
       images: List<String>.from(uploadedImageUrls),

    );

    ctx.read<AdminCubit>().addExperience(
      cityIdController.text.trim(),
      placeIdController.text.trim(),
      experience,
    );

    debugPrint('Place ID: ${placeIdController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(PlacesRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Experience (Admin)'),
          centerTitle: true,
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (ctx, state) {
            if (state is AdminSuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Experience added successfully')),
              );

              formKey.currentState?.reset();
              nameController.clear();
              priceController.clear();
              ratingController.clear();
              reviewsController.clear();
              placeIdController.clear();
              cityIdController.clear();

              setState(() {
                uploadedImageUrls.clear();
              });
            } else if (state is AdminError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (ctx, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      appField(nameController, 'Experience Name'),
                      uploadingImageForSingle
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.image),
                              label: const Text('Pick & Upload Cover Images'),
                              onPressed: () => uploadSingleImage(ctx),
                            ),
                                
                     uploadingImage
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.image),
                              label: const Text('Pick & Upload Images'),
                              onPressed: () => uploadImages(ctx),
                            ),

                      const SizedBox(height: 12),
                      Text(
                        'Uploaded: ${uploadedImageUrls.length} images',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 12),
                      appField(priceController, 'Price', isNumber: true),
                      appField(ratingController, 'Rating (0 - 5)',
                          isNumber: true),
                      appField(reviewsController, 'Reviews', isNumber: true),
                      appField(cityIdController, 'City ID'),
                      appField(placeIdController, 'Place ID'),

                      const SizedBox(height: 24),
                      state is AdminLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () => submit(ctx),
                              child: const Text('Add Experience'),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}