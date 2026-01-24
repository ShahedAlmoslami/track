import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track/data/models/place_model.dart';
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';

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


  File? selectedImage;
  bool uploadingImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            imageController.clear();
          } else if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  field(nameController, 'Place Name'),

                  uploadingImage
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.image),
                          label: const Text('Pick & Upload Image'),
                          onPressed: _pickAndUploadImage,
                        ),

                  const SizedBox(height: 12),

                  field(imageController, 'Image URL'),
                  field(priceController, 'Price',),
                  field(ratingController, 'Rating (0 - 5)', isNumber: true),
                  field(reviewsController, 'Reviews', isNumber: true),
                  field(cityIdController, 'City ID (ex: cairo)'),

                  const SizedBox(height: 24),

                  state is AdminLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: submit,
                          child: const Text('Add Place'),
                        ),
                ],
              ),
            ),
          );
        },
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
            value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      uploadingImage = true;
    });

    try {
      final url =
          await CloudinaryService.uploadImage(File(picked.path));

      imageController.text = url;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
    } finally {
      setState(() {
        uploadingImage = false;
      });
    }
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      final place = PlaceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        imageUrl: imageController.text,
        rating: double.parse(ratingController.text),
        reviews: int.parse(reviewsController.text),
        price: double.parse(priceController.text),
        currency: 'EGP',
        cityId: cityIdController.text,
      );

      context.read<AdminCubit>().addPlace(place);
    }
  }
}