import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class Hotelwidget extends StatelessWidget {
  const Hotelwidget({
    super.key,
    required this.price,
    this.rating,
    required this.imageName,
    required this.hotelName,
  });

  final double price;
  final String imageName;
  final String hotelName;
  final double? rating;

  bool _isValidNetworkUrl(String url) {
    final u = Uri.tryParse(url.trim());
    return u != null &&
        (u.scheme == 'http' || u.scheme == 'https') &&
        u.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final url = imageName.trim();
    final hasValidUrl = _isValidNetworkUrl(url);

    return Center(
      child: Stack(
        children: [
          // ✅ Image (safe)
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: 
                 Image.network(
                    url,
                    height: 300,
                    width: 400,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    
                  )
               
          ),
      
          // ✅ Overlay
          Container(
            height: 300,
            width: 400,
            decoration: BoxDecoration(
              color: ColorManager.containerColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    hotelName,
                    style: TextStyle(
                      color: ColorManager.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: ColorManager.yellowColor),
                      const SizedBox(width: 6),
                      Text(
                        (rating ?? 0).toString(),
                        style: TextStyle(color: ColorManager.whiteColor),
                      ),
                    ],
                  ),
                  Text(
                    price.toString(),
                    style: TextStyle(
                      color: ColorManager.whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: const Icon(Icons.list),
                      color: ColorManager.iconColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}