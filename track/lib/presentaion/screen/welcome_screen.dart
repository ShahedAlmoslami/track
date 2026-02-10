import 'package:flutter/material.dart';
import 'package:track/core/const/txt.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/sign_up_screen.dart';
import 'package:track/presentaion/widgets/button_style.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/welcome.png')),
          Container(
            color: ColorManager.containerColor,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 400,

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.center,
                    
                    children: [
                      Text(Tex.welcome,style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color:ColorManager.whiteColor,


                      ),),
                      Text(Tex.you,style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color:ColorManager.whiteColor,


                      )),
                      Text(Tex.welcome2
                      ,style: TextStyle(
                        fontSize: 20,
                        color:ColorManager.whiteColor,
                      ),
                      ),
                       Text(Tex.getStartedcolect,style: TextStyle(
                        fontSize: 20,
                        color:ColorManager.whiteColor,
                      )),
                      Text(Tex.memories,style: TextStyle(
                        fontSize: 20,
                        color:ColorManager.whiteColor,
                      )),
                      InkWell(onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));  },
                      child: MyButtonStyle(buttonHight:60,buttonWidth:400,buttonText:Tex.getStarted),),
                        

    



                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
