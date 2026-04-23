import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class SearchWidget extends StatefulWidget {
  TextEditingController searchController = TextEditingController();
  String query = "";
    @override

      SearchWidget({super.key,required this.query,required this.searchController});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    widget.searchController.dispose();

    super.dispose() ;
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  height: 55,
                  child: TextField(
                    controller:widget. searchController,
                    onChanged: (value) => setState(() =>widget. query = value),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: ColorManager.prymaryColor,fontSize: 20,fontWeight: FontWeight.bold),
                      prefixIcon: const Icon(Icons.search, color: ColorManager.prymaryColor,size: 32,),
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
                      suffixIcon:widget. query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                              widget.  searchController.clear();
                                setState(() =>widget. query = "");
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ),
              );
  }
}