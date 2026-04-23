import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class ResturantWidget extends StatelessWidget {
  final String resturantname;
  final String resturantimage;

  const ResturantWidget({
    super.key,
    required this.resturantname,
    required this.resturantimage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              resturantimage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 100,
                height: 100,
                child: Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resturantname,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Icon(Icons.star, color: ColorManager.yellowColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}