import 'package:flutter/material.dart';
import 'package:track/presentaion/screen/details.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';

class FavScreen extends StatefulWidget {
List<Widget> ?favorites = [];
bool? isFav = false;
   FavScreen({super.key,  this.favorites, this.isFav});
  
  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:widget.isFav == true ? ListView.builder(
        itemCount: widget.favorites!.length,
        
        itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(child: widget.favorites![index],onTap: (){
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavScreen(favorites: [widget.favorites![index]],)),
            );
              
              
            },),
            SizedBox(height: 10),
          ],
        );
      }):SizedBox(),
                          bottomNavigationBar:  AppBottomBar(currentIndex: 2),

    );
  }
}