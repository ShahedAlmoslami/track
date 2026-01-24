import 'package:flutter/material.dart';
import 'package:track/presentaion/widgets/button_over_view.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60,),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back)),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [OverView(buttonText:"overview", imageName:"assets/images/bank.png"),
                
                              OverView(buttonText:"restaurant", imageName:"assets/images/forkknife.png"),
                              OverView(buttonText:"hotel", imageName:"assets/images/forkknife.png"),],),
              Row(children: [OverView(buttonText:"love", imageName:"assets/images/heart.png"),
                            OverView(buttonText:"book", imageName:"assets/images/book.png"),
                            OverView(buttonText:"Not populaar", imageName:"assets/images/notpopulaar.png")],),
          
              ],
            )
          ),
        ],
      ),
    );
  }
}