import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/data/models/city_modle.dart';
import 'package:track/data/models/menu_item_model.dart';
import 'package:track/data/services/cloudinary_service.dart';
import 'package:track/data/services/place_rep.dart' as repo;
import 'package:track/logic/admin/cuibt.dart';
import 'package:track/logic/admin/state.dart';
import 'package:track/presentaion/screen/admin/function.dart';

class AddDishScreen extends StatefulWidget {
   AddDishScreen({super.key});

  @override
  State<AddDishScreen> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddDishScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
    final itemIdController = TextEditingController();
final cityIdController=TextEditingController();
final resIdController=TextEditingController();
  final coverController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController =TextEditingController();
    final dishController =TextEditingController();

        bool isOn = false;







  bool uploadingCover = false;

  @override
  void dispose() {
    nameController.dispose();
    coverController.dispose();
    descriptionController.dispose();
    priceController.dispose();
        dishController.dispose();


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
  

  void submit(BuildContext ctx) {
    if (!formKey.currentState!.validate()) return;
    final itemId=itemIdController.text.trim();
    final name = nameController.text.trim();
    final cover = coverController.text.trim();
    final desc = descriptionController.text.trim();
    final price =priceController.text.trim();
final dishTime=dishController.text.trim();


final isAvailable=isOn;

    final dish = MenuItemModel(
      categoryId: itemId,
      name: name,
      image: cover.isEmpty ? '' : cover,
      description: desc,
      price:int.parse(price),
      deshTime: dishTime,
      isAvailable:isAvailable,

    );

    ctx.read<AdminCubit>().addMenuItem(cityIdController.text,resIdController.text,itemIdController.text,dish,);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminCubit(repo.PlacesRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Dish (Admin)'),
          centerTitle: true,
        ),
        body: BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {
            if (state is AdminSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dish added successfully')),
              );

              formKey.currentState!.reset();
              nameController.clear();
              coverController.clear();
              descriptionController.clear();
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
                      'Dish Name (ex: Cairo / القاهرة)',
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
                   

                    const SizedBox(height: 8),
appField(
                      cityIdController,
                      'CityId',
                      requiredField: false,
                    ),
appField(
                      resIdController,
                      'resId',
                      requiredField: false,
                    ),
                    appField(
                      itemIdController,
                      'ItemId',
                      requiredField: false,
                    ),
                  appField(
                      priceController,
                      'Price',
                      requiredField: false,
                    ),
                     appField(
                      dishController,
                      'DishTime',
                      requiredField: false,
                    ),
                    
 Switch(
  value: isOn,
  onChanged: (value) {
    setState(() {
      isOn = value;
    });
  },
)
                    , SizedBox(height: 20),

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