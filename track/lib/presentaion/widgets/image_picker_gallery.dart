import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track/data/services/cloudinary_service.dart';

class ImagePickerGallery extends StatefulWidget {
  final List<String> urls;                 // الليست اللي عندك
  final ValueChanged<List<String>> onChanged; // يرجع الليست بعد الإضافة/الحذف
  final bool uploading;
  final ValueChanged<bool> onUploadingChanged;

  final String buttonText;
  final int maxPreview; // كم thumbnail نعرض (اختياري)

  const ImagePickerGallery({
    super.key,
    required this.urls,
    required this.onChanged,
    required this.uploading,
    required this.onUploadingChanged,
    this.buttonText = 'Pick & Upload Images',
    this.maxPreview = 20,
  });

  @override
  State<ImagePickerGallery> createState() => _ImagePickerGalleryState();
}

class _ImagePickerGalleryState extends State<ImagePickerGallery> {
  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    widget.onUploadingChanged(true);

    try {
      final newUrls = <String>[];

      for (final x in picked) {
        final url = await CloudinaryService.uploadImage(File(x.path));
        newUrls.add(url);
      }

      final updated = [...widget.urls, ...newUrls];
      widget.onChanged(updated);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded ${newUrls.length} images')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
    } finally {
      if (mounted) widget.onUploadingChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shown = widget.urls.take(widget.maxPreview).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.uploading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
                onPressed: _pickAndUpload,
                icon: const Icon(Icons.collections),
                label: Text(widget.buttonText),
              ),

        const SizedBox(height: 12),

        if (widget.urls.isEmpty)
          Text(
            'No images yet',
            style: TextStyle(color: Colors.grey.shade600),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (int i = 0; i < shown.length; i++)
                _Thumb(
                  url: shown[i],
                  onDelete: () {
                    final updated = [...widget.urls]..removeAt(i);
                    widget.onChanged(updated);
                  },
                  onSetAsCover: () {
                    // خليه أول عنصر (cover)
                    final updated = [...widget.urls];
                    final u = updated.removeAt(i);
                    updated.insert(0, u);
                    widget.onChanged(updated);
                  },
                  isCover: i == 0,
                ),
            ],
          ),

        if (widget.urls.length > widget.maxPreview) ...[
          const SizedBox(height: 8),
          Text(
            '+ ${widget.urls.length - widget.maxPreview} more...',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  final VoidCallback onDelete;
  final VoidCallback onSetAsCover;
  final bool isCover;

  const _Thumb({
    required this.url,
    required this.onDelete,
    required this.onSetAsCover,
    required this.isCover,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            url,
            width: 110,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(width: 110, height: 90, color: Colors.grey.shade300),
          ),
        ),

        // زر حذف
        Positioned(
          top: 6,
          right: 6,
          child: InkWell(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),

        // زر Cover (يخليها أول صورة)
        Positioned(
          bottom: 6,
          left: 6,
          child: InkWell(
            onTap: onSetAsCover,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCover ? Colors.orange : Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isCover ? 'Cover' : 'Set cover',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
