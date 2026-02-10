import 'package:flutter/material.dart';

class FigmaStackGallery extends StatefulWidget {
  final List<String> images;
  final double height;
  final double radius;

  const FigmaStackGallery({
    super.key,
    required this.images,
    this.height = 190,
    this.radius = 38,
  });

  @override
  State<FigmaStackGallery> createState() => _FigmaStackGalleryState();
}

class _FigmaStackGalleryState extends State<FigmaStackGallery> {
  int? expandedIndex; // null = ما في overlay

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    final baseUrl = widget.images[0];
    final thumbs = widget.images.length > 1 ? widget.images.sublist(1) : const <String>[];

    return SizedBox(
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 170,
            bottom: 10,
            top: 10
            ,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius),
              child: InkWell(
                onTap: () => _open(0),
                child: _img(baseUrl),
              ),
            ),
          ),

          ...List.generate(thumbs.length.clamp(0, 3), (i) {
            final url = thumbs[i];
            final topOffset = -18 + (i * 78);

            return Positioned(
              left: 0,
              top: topOffset.toDouble(),
              width: 200,
              height: 200,
              child: InkWell(
                onTap: () => _open(i + 1), // لأن thumbs تبدأ من index 1
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                        color: Colors.black.withOpacity(0.18),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius),
                    child: _img(url),
                  ),
                ),
              ),
            );
          }),

          // ===== Overlay يغطي الكرت كله بالصورة اللي ضغطت عليها =====
          if (expandedIndex != null)
            Positioned.fill(
              child: InkWell(
                onTap: () => setState(() => expandedIndex = null),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius),
                  child: _img(widget.images[expandedIndex!]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _open(int index) {
    setState(() => expandedIndex = index);
  }

  Widget _img(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
    );
  }
}
