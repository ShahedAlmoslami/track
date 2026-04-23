import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef UploadFn = Future<String> Function(File file);

Widget appField(
  TextEditingController controller,
  String label, {
  bool isNumber = false,
  bool requiredField = true,
  String ? hint,
  String? Function(String?)? validator,
  ValueChanged<String>? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: validator ??
          (value) {
            if (!requiredField) return null;
            return (value == null || value.trim().isEmpty) ? 'Required' : null;
          },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    ),
  );
}

Future<List<String>> pickAndUploadMultiImages({
  required BuildContext context,
  required UploadFnSignal upload,
  void Function(bool loading)? onLoading,
}) async {
  final picker = ImagePicker();
  final pickedImages = await picker.pickMultiImage();

  if (pickedImages.isEmpty) return [];

  onLoading?.call(true);

  try {
    final urls = <String>[];

    for (final image in pickedImages) {
      final url = await upload(File(image.path));
      urls.add(url);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All images uploaded successfully')),
    );

    return urls;
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image upload failed')),
    );
    return [];
  } finally {
    onLoading?.call(false);
  }
}

typedef UploadFnSignal = Future<String> Function(File file);

// ... appField + pickAndUploadMultiImages موجودين عندك

Future<String?> pickAndUploadSingleImage({
  required BuildContext context,
  required UploadFnSignal upload,
  void Function(bool loading)? onLoading,
}) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked == null) return null;

  onLoading?.call(true);

  try {
    final url = await upload(File(picked.path));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image uploaded successfully')),
    );
    return url;
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image upload failed')),
    );
    return null;
  } finally {
    onLoading?.call(false);
  }
}