import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:track/data/models/place_model.dart';
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/presentaion/screen/admin/function.dart'; // فيها appField + pickAndUploadMultiImages

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final imageController = TextEditingController();
  final priceController = TextEditingController();
  final ratingController = TextEditingController();
  final reviewsController = TextEditingController();
  final cityIdController = TextEditingController();
  final historyController = TextEditingController();

  List<String> uploadedImageUrls = [];

  bool uploadingImage = false;
  bool isPopular = false;

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();
    priceController.dispose();
    ratingController.dispose();
    reviewsController.dispose();
    cityIdController.dispose();
    historyController.dispose();
    super.dispose();
  }

  Future<void> uploadGalleryImages(BuildContext ctx) async {
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
    if (!formKey.currentState!.validate()) return;

    final reviewsText = reviewsController.text.trim();
    final reviews = reviewsText.isEmpty ? 0 : (int.tryParse(reviewsText) ?? 0);

    final rating = double.tryParse(ratingController.text.trim()) ?? 0.0;
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final cityId = cityIdController.text.trim();

    // إذا ما كتبتي Image URL وخترتي صور، خليه ياخد أول صورة تلقائيًا
    final mainImage = imageController.text.trim().isNotEmpty
        ? imageController.text.trim()
        : (uploadedImageUrls.isNotEmpty ? uploadedImageUrls.first : '');

    final place = PlaceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      imageUrl: mainImage,
      rating: rating,
      reviews: reviews,
      price: price,
      currency: 'EGP',
      isPopular: isPopular,
      imageList: List<String>.from(uploadedImageUrls),
      history: historyController.text.trim().isEmpty
          ? null
          : historyController.text.trim(),
    );

    ctx.read<AdminCubit>().addPlace(cityId, place);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(PlacesRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Place (Admin)'),
          centerTitle: true,
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {
            if (state is AdminSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Place added successfully')),
              );

              formKey.currentState!.reset();
              nameController.clear();
              imageController.clear();
              priceController.clear();
              ratingController.clear();
              reviewsController.clear();
              cityIdController.clear();
              historyController.clear();

              setState(() {
                isPopular = false;
                uploadedImageUrls.clear();
              });
            } else if (state is AdminError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (ctx, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    appField(nameController, 'Place Name'),

                    uploadingImage
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.image),
                            label: const Text('Pick & Upload Images'),
                            onPressed: () => uploadGalleryImages(ctx),
                          ),

                    if (uploadedImageUrls.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Uploaded: ${uploadedImageUrls.length} images'),
                    ],

                    const SizedBox(height: 12),

                    appField(imageController, 'Image URL', requiredField: false),
                    appField(priceController, 'Price', isNumber: true),
                    appField(ratingController, 'Rating (0 - 5)',
                        isNumber: true),
                    appField(
                      reviewsController,
                      'Reviews',
                      isNumber: true,
                      requiredField: false,
                    ),
                    appField(cityIdController, 'City ID (ex: cairo)'),
                    appField(historyController, 'History', requiredField: false),

                    const SizedBox(height: 12),

                    SwitchListTile(
                      title: const Text('Popular'),
                      value: isPopular,
                      onChanged: (v) => setState(() => isPopular = v),
                    ),

                    const SizedBox(height: 24),

                    state is AdminLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => submit(ctx),
                            child: const Text('Add Place'),
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