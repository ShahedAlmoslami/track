import 'package:flutter/material.dart';

class Histroy extends StatefulWidget {
  String discr;
  String imageName;
   Histroy({super.key, required this.discr,  required this.imageName});

  @override
  State<Histroy> createState() => _HistroyState();
}

class _HistroyState extends State<Histroy> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Text(widget.discr),
        ListView.builder(itemBuilder: (context, index) {
    return Image.network(widget.imageName);
  },)
      ],),
      
    );
  }
}