import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/hotelModel.dart';

import 'package:track/data/services/place_rep.dart' as repo;
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/presentaion/screen/admin/function.dart';

// عدّلي حسب مكان الموديل

class AddHotelScreen extends StatefulWidget {
  const AddHotelScreen({super.key});

  @override
  State<AddHotelScreen> createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  final formKey = GlobalKey<FormState>();

  final cityIdController = TextEditingController();
  final nameController = TextEditingController();

  // ✅ Cover URL
  final coverController = TextEditingController();

  final ratingController = TextEditingController();
  final reviewsController = TextEditingController(); // optional
  final priceFromController = TextEditingController();
  final currencyController = TextEditingController(text: 'EGP');
  final starsController = TextEditingController(); // optional

  // ✅ Gallery list
  List<String> uploadedImageUrls = [];

  bool uploadingCover = false;
  bool uploadingGallery = false;

  @override
  void dispose() {
    cityIdController.dispose();
    nameController.dispose();
    coverController.dispose();
    ratingController.dispose();
    reviewsController.dispose();
    priceFromController.dispose();
    currencyController.dispose();
    starsController.dispose();
    super.dispose();
  }

  Future<void> uploadCover(BuildContext ctx) async {
    final url = await pickAndUploadSingleImage(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) => setState(() => uploadingCover = loading),
    );

    if (url == null) return;
    setState(() => coverController.text = url);
  }

  Future<void> uploadGallery(BuildContext ctx) async {
    final urls = await pickAndUploadMultiImages(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) => setState(() => uploadingGallery = loading),
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

    final cityId = cityIdController.text.trim();

    final rating = double.tryParse(ratingController.text.trim()) ?? 0.0;

    final reviewsText = reviewsController.text.trim();
    final reviews = reviewsText.isEmpty
        ? null
        : (int.tryParse(reviewsText) ?? 0);

    final priceFrom = double.tryParse(priceFromController.text.trim()) ?? 0.0;

    final currency = currencyController.text.trim().isEmpty
        ? 'EGP'
        : currencyController.text.trim();

    final starsText = starsController.text.trim();
    final stars = starsText.isEmpty ? null : int.tryParse(starsText);

    // ✅ imageUrl = cover (ولو فاضي خذ أول صورة من الليست إذا موجودة)
    final coverUrl = coverController.text.trim();
    final mainImage = coverUrl.isNotEmpty
        ? coverUrl
        : (uploadedImageUrls.isNotEmpty ? uploadedImageUrls.first : '');

    final hotel = HotelModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cityId: cityId,
      name: nameController.text.trim(),
      imageUrl: mainImage,
      rating: rating,
      reviews: reviews,
      priceFrom: priceFrom,
      currency: currency,
      stars: stars,
      imageList: uploadedImageUrls.isEmpty
          ? null
          : List<String>.from(uploadedImageUrls),
    );

    // لازم يكون عندك addHotel في AdminCubit
    ctx.read<AdminCubit>().addHotel(cityId, hotel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(repo.PlacesRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Hotel (Admin)'),
          centerTitle: true,
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (ctx, state) {
            if (state is AdminSuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Hotel added successfully')),
              );

              formKey.currentState!.reset();
              cityIdController.clear();
              nameController.clear();
              coverController.clear();
              ratingController.clear();
              reviewsController.clear();
              priceFromController.clear();
              currencyController.text = 'EGP';
              starsController.clear();

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
                      'City ID (ex: cairo)',
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Required';
                        return null;
                      },
                    ),

                    appField(nameController, 'Hotel Name'),

                    const SizedBox(height: 8),

                    // ✅ Cover upload
                    uploadingCover
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.image),
                            label: const Text('Pick & Upload Cover'),
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

                    // ✅ Gallery upload
                    uploadingGallery
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.collections),
                            label: const Text('Pick & Upload Gallery Images'),
                            onPressed: () => uploadGallery(ctx),
                          ),

                    const SizedBox(height: 8),
                    Text(
                      'Gallery: ${uploadedImageUrls.length} images',
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
                                  onTap: () {
                                    setState(() {
                                      uploadedImageUrls.remove(url);
                                    });
                                  },
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
                    appField(priceFromController, 'Price From', isNumber: true),
                    appField(
                      currencyController,
                      'Currency (default EGP)',
                      requiredField: false,
                    ),
                    appField(
                      starsController,
                      'Stars (Optional)',
                      isNumber: true,
                      requiredField: false,
                    ),

                    const SizedBox(height: 24),

                    state is AdminLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => submit(ctx),
                            child: const Text('Add Hotel'),
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
