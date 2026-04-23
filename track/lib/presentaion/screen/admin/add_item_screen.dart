import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:track/data/models/item_model.dart';
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/presentaion/screen/admin/function.dart'; // appField + pickAndUploadMultiImages

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddItemScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final restaurantIdController = TextEditingController();
  final cityIdController = TextEditingController();
    final coverController = TextEditingController();


    bool uploadingImageForSingle = false;
String ?uploadedImage2;

  @override
  void dispose() {
    nameController.dispose();
    restaurantIdController.dispose();
    cityIdController.dispose();
    coverController.dispose();
    super.dispose();
  }
Future<void> uploadSingleImage(BuildContext ctx) async {
    final urls = await pickAndUploadSingleImage(
      context: ctx,
      upload: (file) => CloudinaryService.uploadImage(file),
      onLoading: (loading) => setState(() => uploadingImageForSingle = loading),
    );


    setState(() {
      coverController.text = urls!;
    });
  }
  
  void submit(BuildContext ctx) {
    if (!(formKey.currentState?.validate() ?? false)) return;



    final item = MenuCategoryModel(
      restaurantId: restaurantIdController.text,
       name:nameController.text,
       coverImage: coverController.text )
;      
    

    ctx.read<AdminCubit>().addItem(
      cityIdController.text.trim(),
      restaurantIdController.text.trim(),
      item,
    );

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(PlacesRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Item (Admin)'),
          centerTitle: true,
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (ctx, state) {
            if (state is AdminSuccess) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text('Item added successfully')),
              );

              formKey.currentState?.reset();
              nameController.clear();
            
              restaurantIdController.clear();
              cityIdController.clear();

             
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
                      appField(nameController, 'Item Name'),
                      uploadingImageForSingle
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.image),
                              label: const Text('Pick & Upload Cover Images'),
                              onPressed: () => uploadSingleImage(ctx),
                            ),

                        appField(coverController, 'Cover Link'),
   
                     

                      const SizedBox(height: 12),
                     

                      const SizedBox(height: 12),
                      
                      appField(cityIdController, 'City ID'),
                      appField(restaurantIdController, 'Restaurant ID'),

                      const SizedBox(height: 24),
                      state is AdminLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () => submit(ctx),
                              child: const Text('Add Item'),
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