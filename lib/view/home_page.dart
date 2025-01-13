import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/favouriteModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

body: Container(

  child: Column(mainAxisAlignment: MainAxisAlignment.center,
    children: [


      ElevatedButton(onPressed: () async {

       // var box = await Hive.openBox('hive_box');
       // FavouriteModel dataModel = FavouriteModel(
       //      date:"0",
       //      youTubeVideo: []);
       //  box.add(dataModel).then((onValue){
       //    log("message");
       //  }).onError((e,s){
       //
       //    log("ee");
       //  });


      }, child: Text("add")),

         ElevatedButton(onPressed: () async {
         var  box = await Hive.openBox('hive_box2');
           var items = box.values.toList().reversed.toList();

           log(items.toString());

      }, child: Text("get")),



    ],
  ),
),
    );
  }
}
