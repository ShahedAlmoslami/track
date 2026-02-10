import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track/data/models/experience_model.dart';
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/data/services/place_model.dart';
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';

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

  List<String> uploadedImageUrls = [];
  bool uploadingImage = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    ratingController.dispose();
    reviewsController.dispose();
    placeIdController.dispose();
    super.dispose();
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
              uploadedImageUrls.clear();
              // إذا بدك تنظف الحقول كمان:
              nameController.clear();
              priceController.clear();
              ratingController.clear();
              reviewsController.clear();
              placeIdController.clear();
              setState(() {}); // عشان تحديث "Uploaded: x images"
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
                      field(nameController, 'Experience Name'),

                      uploadingImage
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.image),
                              label: const Text('Pick & Upload Images'),
                              onPressed: () => _pickAndUploadImages(ctx),
                            ),

                      const SizedBox(height: 12),
                      Text(
                        'Uploaded: ${uploadedImageUrls.length} images',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 12),
                      field(priceController, 'Price', isNumber: true),
                      field(ratingController, 'Rating (0 - 5)', isNumber: true),
                      field(reviewsController, 'Reviews', isNumber: true),
                      field(placeIdController, 'Place ID'),

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

  Widget field(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImages(BuildContext ctx) async {
    final picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();

    if (pickedImages.isEmpty) return;

    setState(() => uploadingImage = true);

    try {
      uploadedImageUrls.clear();

      for (final image in pickedImages) {
        final url = await CloudinaryService.uploadImage(File(image.path));
        uploadedImageUrls.add(url);
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('All images uploaded successfully')),
      );
    } catch (_) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
    } finally {
      setState(() => uploadingImage = false);
    }
  }

  void submit(BuildContext ctx) {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (uploadedImageUrls.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    // ملاحظة: لو المستخدم دخل rating فاضي/غير رقم، double.parse رح يفجّر.
    // بس بما انك عامل validator Required، رح يكون موجود. ومع هيك، هاي parse قاسية.
    final experience = ExperienceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: nameController.text.trim(),
      images: List<String>.from(uploadedImageUrls),
      rating: double.parse(ratingController.text.trim()),
      reviews: int.parse(reviewsController.text.trim()),
      price: double.parse(priceController.text.trim()),
      currency: 'EGP',
    );

    ctx.read<AdminCubit>().addExperience(
          placeIdController.text.trim(),
          experience,
        );

    debugPrint('Place ID: ${placeIdController.text}');
  }
}
