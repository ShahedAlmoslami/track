import 'package:flutter/material.dart';

class DishWidget extends StatelessWidget {
  final String imagename;
  final String name;
  final int price;
  String  dishTime;
  bool  isAvil =false;

   DishWidget({
    super.key,
    required this.imagename,
    required this.name,
    required this.price,
 required  this.dishTime,
required  this. isAvil
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 45,
            left: 0,
            right: 0,
            child: Container(
              width: 200,
              height: 220,
              padding: const EdgeInsets.fromLTRB(12, 60, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 4),
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$price',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.pink,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [

                      SizedBox(width: 10),
                      Icon(Icons.access_time, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(dishTime),
                      isAvil ? Icon(Icons.check_rounded, color: Colors.green):SizedBox()
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ClipOval(
                child: Image.network(
                  imagename,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}