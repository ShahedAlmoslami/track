import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/city_modle.dart';
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/data/services/place_rep.dart' as repo;
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/presentaion/screen/admin/function.dart';

class AddCityScreen extends StatefulWidget {
  const AddCityScreen({super.key});

  @override
  State<AddCityScreen> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final coverController = TextEditingController();
  final descriptionController = TextEditingController();

  List<String> uploadedImageUrls = [];

  bool uploadingCover = false;
  bool uploadingList = false;

  @override
  void dispose() {
    nameController.dispose();
    coverController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ✅ Upload Cover
  Future<void> uploadCover(BuildContext ctx) async {
    final url = await pickAndUploadSingleImage(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) =>
          setState(() => uploadingCover = loading),
    );

    if (url == null) return;

    setState(() {
      coverController.text = url;
    });
  }

  // ✅ Upload List
  Future<void> uploadList(BuildContext ctx) async {
    final urls = await pickAndUploadMultiImages(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) =>
          setState(() => uploadingList = loading),
    );

    if (urls.isEmpty) return;

    setState(() {
      uploadedImageUrls = List.from(urls);
    });
  }

  void submit(BuildContext ctx) {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final cover = coverController.text.trim();
    final desc = descriptionController.text.trim();

    final city = CityModel(
      name: name,
      coverImage: cover.isEmpty ? '' : cover,
      description: desc.isEmpty ? null : desc,
      imageList: List.from(uploadedImageUrls),
    );

    ctx.read<AdminCubit>().addCitym(city);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(repo.PlacesRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add City (Admin)'),
          centerTitle: true,
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {
            if (state is AdminSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('City added successfully')),
              );

              formKey.currentState!.reset();
              nameController.clear();
              coverController.clear();
              descriptionController.clear();
              setState(() => uploadedImageUrls.clear());
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

                    // ---------------- Name ----------------
                    appField(
                      nameController,
                      'City Name (ex: Cairo / القاهرة)',
                    ),

                    const SizedBox(height: 16),

                    // ---------------- Cover ----------------
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
                      'Cover Image URL (Optional)',
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
                              const Text('Invalid image URL'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ---------------- Image List ----------------
                    uploadingList
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.collections),
                            label: const Text('Upload Images List (Multi)'),
                            onPressed: () => uploadList(ctx),
                          ),

                    const SizedBox(height: 8),

                    Text(
                      'Images: ${uploadedImageUrls.length}',
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

                    const SizedBox(height: 20),

                    // ---------------- Description ----------------
                    appField(
                      descriptionController,
                      'Description (Optional)',
                      requiredField: false,
                    ),

                    const SizedBox(height: 30),

                    state is AdminLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => submit(ctx),
                            child: const Text('Add City'),
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