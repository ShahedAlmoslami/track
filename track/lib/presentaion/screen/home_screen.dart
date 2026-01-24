import 'package:flutter/material.dart';
import 'package:track/core/const/txt.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/widgets/city_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  final List<Map<String, String>> allCities = [
    {'img': 'assets/images/cairo.png', 'name': Tex.cairo},
    {'img': 'assets/images/dahab.png', 'name': Tex.dahab},
    {'img': 'assets/images/sharmalshekh.png', 'name': Tex.sharmalshekh},
    {'img': 'assets/images/aleskandaria.png', 'name': Tex.aleskandaria},
  ];
 
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCities = allCities.where((city) {
      final name = (city['name'] ?? '').toLowerCase();
      final q = query.toLowerCase().trim();
      return name.contains(q);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                height: 55,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() => query = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.white),

                    prefixIcon: const Icon(Icons.search,color: Colors.white,),
                    filled: true,
                    fillColor: ColorManager.secondaryColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() => query = "");
                            },
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            // List
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: filteredCities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  final item = filteredCities[index];
                  return CityWidget(
                    imageName: item['img']!,
                    cityName: item['name']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
