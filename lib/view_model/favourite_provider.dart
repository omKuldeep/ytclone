
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:kio_chat/model/favouriteModel.dart';

import '../toast.dart';

class FavouriteProvider extends ChangeNotifier{

  List<FavouriteModel> videoList=[];

 late Box<FavouriteModel> box;
 double _bottomSheetHeight = 140.0;
 double get bottomSheetHeight => _bottomSheetHeight;

 Set<String> _selectedIndexes = {};
 Set<String> get selectedIndexes => _selectedIndexes;

 Future<void> initBox() async {
  box = await Hive.openBox<FavouriteModel>('favourite_songs');
 }

 Future<void> addFav(context,model,index) async {
   try {
     await box.add(model).then((onValue){
       toast(context, "Added to favourite");

       if (_selectedIndexes.contains(index)) {
         _selectedIndexes.remove(index);
       } else {
         _selectedIndexes.add(index);
       }
       log("messages");
     });
   } on Exception catch (e) {
     toast(context, "Error");
   }

 }

 Future<void> getVideos() async {
   try {
     videoList = box.values.toList();

     final Map<String, FavouriteModel> profileMap = {};
     for (var item in videoList) {
       profileMap[item.id!] = item;
     }
     videoList = profileMap.values.toList();

     log(videoList.length.toString());

     // var toRemove = {};
     // videoList.forEach((e) {
     //   log("$e");
     //   toRemove.putIfAbsent("$e", () => e);
     // });
     // print(toRemove.keys.toList());
   } on Exception catch (e) {

   }


 }

 Future<List<String>> playAll(context,size,provider,controller){
   List<String> list=[];
   if (videoList.isNotEmpty) {
     for(var item in videoList){
       if(item.url!.startsWith("https://www.youtube.com/watch?v=")){
         list.add(item.id.toString());
       }


     //  provider.playAllList(true,false);

     //  showPlayerDialog(context,size,item.title,item.id,item.channel,provider,controller,videoList:list);
     }
   }

   return Future.value(list);

 }

 Future<void> removeFavourite(context,String id) async {
  log(id.toString());
 try {

   final Map<dynamic, FavouriteModel> deliveriesMap = box.toMap();


   dynamic desiredKey;
   deliveriesMap.forEach((key, value){
     if (value.id == id) {
       desiredKey = key;
     }
   });
   log(desiredKey.toString());
  await box.delete(desiredKey).then((onValue){
    toast(context, "Remove from favourite");
  }).onError((e,s){
    toast(context, "error");

  });


   // await box.deleteAt(index).then((val) async {
   //   toast(context, "Remove from favourite");
   //
   //   await getVideos();
   //   notifyListeners();
   // });
 } on Exception catch (e) {
 }


 }

 void changeSheetHeight(Size size){
   if (_bottomSheetHeight == 140.0) {
     _bottomSheetHeight = size.height;
   } else {
     _bottomSheetHeight = 140.0;
   }
   notifyListeners();

 }

}