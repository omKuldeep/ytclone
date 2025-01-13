import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kio_chat/view/chat_page/chat_room_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../toast.dart';
import '../auth_screen/login_screen.dart';

class UserHomeScreen extends StatefulWidget {
  final User user;
  const UserHomeScreen({super.key, required this.user});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  TextEditingController userNameController=TextEditingController();
  var selectedItem;
  var collection = FirebaseFirestore.instance;

  String myUid="";

  Future<void> signOut() async {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Sign Out"),
        actions: [
          ElevatedButton(onPressed: () async {
            await FirebaseAuth.instance.signOut().then((onValue) {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (Route<dynamic> route) => false);
            });
          }, child: const Text("Yes")),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("No")),
        ],
      );
    });

  }



  late SharedPreferences sharedPreferences;
  var userList;


  late StateSetter _setState;
  searchUser(Size size,){
    showDialog(context: context, builder: (_){
      return StatefulBuilder(builder: (context, StateSetter setState) {
        _setState = setState;
        return Dialog(elevation: 0,
          child: SizedBox(height: 200,
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: showUser,
                ),const SizedBox(height: 10.0,),
               userList==null ? const Text("Search by user id") : GestureDetector(
                    onTap: (){
                     // final name = userList["name"]=="null"?userList["email"]:userList["name"];
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoomScreen(currentUser: widget.user, users: userList,)));
                    },
                    child: Card(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(userList["name"]=="null"?userList["email"]:userList["name"].toString()),
                    ))),
              ],
            ),
          ),
        );
      });
    });
  }
  showUser(value) async {

    if(value!.isEmpty || value.length<1 || !value.contains('@') || !value.contains('.')){
      // _setState(() {
      // });
    }else{
      final docRef = FirebaseFirestore.instance.collection("users").doc(value);
      DocumentSnapshot doc = await docRef.get();
      if(doc.data()!=null){
        final data = doc.data() as Map<String, dynamic>;
        userList=data;
        _setState(() {
        });
      }else{
     _setState(() {
     });
      }
    }

    // StreamBuilder<DocumentSnapshot>(stream: FirebaseFirestore.instance
    //     .collection("users").doc(v).snapshots(),
    //   builder: (context, snapshot) {
    //
    //     log("kk "+snapshot.toString());
    //     if (snapshot.hasError) {
    //       return Center(
    //         child: Text('Error: ${snapshot.error}'),
    //       );
    //     }
    //
    //     if (!snapshot.hasData) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //
    //     final data = snapshot.data!;
    //
    //     log(data.toString());
    //
    //     return ListView.builder(
    //       reverse: false,
    //       itemCount: 1,
    //       itemBuilder: (context, index) {
    //         final name = data[index]["name"]=="null"?data[index]["email"]:data[index]["name"];
    //         // final sender = messages[index]["sender"];
    //         // final timeStamp = messages[index]["timestamp"]??Timestamp(1733566630,395000000);
    //         // var date=timeStamp.toDate().toString();
    //         // log(date.toString());
    //         return  Card(elevation: 2,
    //           margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: GestureDetector(
    //               onTap: (){
    //                 final uid = data[index]["uid"];
    //                 Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoomScreen(uid: uid, myUid: myUid,name:name)));
    //               }, child: Row(
    //               children: [
    //                 const CircleAvatar(
    //                   child: Icon(Icons.person),
    //                 ),const SizedBox(width: 10.0,),
    //                 Text(name.toString())
    //               ],
    //             ),
    //             ),
    //           ),
    //         );
    //
    //       },
    //     );
    //   },
    // );
  }

    var allUsers;

  init() async {
    myUid=widget.user.uid;
    sharedPreferences=await SharedPreferences.getInstance();

   // allUsers=sharedPreferences.getString("users")??[];
   //
   // log(allUsers.toString());

  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Chat"),centerTitle: true,
      backgroundColor: Colors.yellow.shade300,
        actions: [
          IconButton(onPressed: (){
            
            searchUser(size,);
            
          }, icon: const Icon(Icons.search)),

          PopupMenuButton<String>(
            initialValue: selectedItem,
            onSelected: ( item) async {
             if(item=="0"){
                signOut();
              }else{
             //  uploadPic();

               toast(context, "${widget.user.email}");
              }
              //  setState(() {
              // selectedItem = item;

              // });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: "0",
                child: Text('Sign Out'),
              ),
              const PopupMenuItem(
                value: "1",
                child: Text('Setting'),
              ),
            ],
          ),
        ],
      ),
       body:  StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance
         .collection("activeUser").doc("users").collection(myUid)
         .snapshots(),
           builder: (context, snapshot) {
         if (snapshot.hasError) {
         return Center(
           child: Text('Error: ${snapshot.error}'),
         );
       }
         if (!snapshot.hasData) {
         return const Center(
           child: CircularProgressIndicator(),
         );
        }
         final data = snapshot.data!.docs;
         return ListView.builder(
         reverse: false,
         itemCount: data.length,
         itemBuilder: (context, index) {
           final name = data[index]["name"]=="null"?data[index]["email"]:data[index]["name"];
           // final sender = messages[index]["sender"];
           // final timeStamp = messages[index]["timestamp"]??Timestamp(1733566630,395000000);
           // var date=timeStamp.toDate().toString();
           // log(date.toString());
           return  Card(elevation: 2,
             margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: GestureDetector(
                 onTap: (){
                  // final uid = data[index]["uid"];
                   Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatRoomScreen(currentUser: widget.user, users: data[index],)));
                 }, child: Row(
                   children: [
                     const CircleAvatar(
                       child: Icon(Icons.person),
                     ),const SizedBox(width: 10.0,),
                     Text(name.toString())
                   ],
                 ),
               ),
             ),
           );
         },
       );
     },
   ),
    );
  }
}
