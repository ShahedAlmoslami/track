import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/data/models/item_model.dart';
import 'package:track/data/services/place_rep.dart';
import 'package:track/logic/item/cubit.dart';
import 'package:track/logic/item/state.dart';
import 'package:track/logic/restaurant/cubit.dart';
import 'package:track/logic/restaurant/state.dart';
import 'package:track/presentaion/screen/mune.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/button_style.dart';
import 'package:track/presentaion/widgets/button_with_row.dart';
import 'package:track/presentaion/widgets/details.dart';
import 'package:track/presentaion/widgets/menu.dart';

class RestaurantDetaliesScreen extends StatefulWidget {
  final String cityIdDoc;
    final String resIdDoc;

  final String resName;
  final String imageNAme;
  final String? rating;
  final String? cuisines;

   RestaurantDetaliesScreen({
    super.key,
    required this.cityIdDoc,
    required this.resName,
    required this.imageNAme,
    this.rating,
    this.cuisines,
    required this.resIdDoc
  });

  @override
  State<RestaurantDetaliesScreen> createState() =>
      _RestaurantDetaliesScreenState();
}

class _RestaurantDetaliesScreenState extends State<RestaurantDetaliesScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(
        create: (context) =>
            RestaurantCubit(PlacesRepo())
              ..getRestaurant(widget.cityIdDoc, ),),
             BlocProvider(create: (context)=> ItemCubit(PlacesRepo())..getItems(widget.cityIdDoc, widget.resIdDoc)) ],
      
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsWidget(
                  imageName: widget.imageNAme,
                  expName: widget.resName,
                  cuisiens:
                      widget.cuisines
                       ,idF: widget.cityIdDoc,
                       type: 'restaurant',
                       idS:widget.resIdDoc ,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ButtonwithRow(
                        buttonHight: 60,
                        buttonWidth: 160,
                        buttonText: 'Contact',
                        buttonIcon: "assets/images/vector.png",
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          MyButtonStyle(
                            buttonHight: 60,
                            buttonWidth: 169,
                            raduis: 30,
                            buttonText: "Opening Hourse",
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '10-24',
                            style: TextStyle(
                              color: ColorManager.prymaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
      
                      MyButtonStyle(
                        buttonHight: 60,
                        buttonWidth: 314,
                        buttonText: "Get the website",
                        raduis: 30,
                      ),
                      SizedBox(height: 50,),

      BlocBuilder<ItemCubit,ItemState>(
        
        builder: (context, state) {
          if(state is ItemLoadingState) {
             return  Padding(
               padding: EdgeInsets.only(top: 16),
               child: Center(child: CircularProgressIndicator()),
             ); 
      
          }
          if (state is ItemErrorState){
            return  Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${state.message}'),
            );
          }
          if (state is ItemSuccessState){
          return SizedBox(
            height: 180,
            child: ListView.separated(
                      shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
            
            
            
            itemCount: state.items.length,
            separatorBuilder: (context, index) => SizedBox(width: 10,),
            itemBuilder: (context, index) { 
              final myItem=state.items[index];
              return SizedBox(
                width: 150,
                child: InkWell(
                                          onTap: () {
                                            
                                           Navigator.push(context, 
                                           MaterialPageRoute(builder: (_)=>
                                           MuneDeatiels(cityId: widget.cityIdDoc,resId: widget.resIdDoc,item: myItem.id!,
                                            )));}

                  ,child: Menu(images:myItem.coverImage ,
                              menu: myItem.name,
                              ),
                ),
              );}
                    ),
          );}
        return SizedBox();}
      )
                     
                    ],
                  ),
                ),
              ],
            ),
            
          ),
                              bottomNavigationBar:  AppBottomBar(currentIndex:1),

        ),
      );
    
  }
}
