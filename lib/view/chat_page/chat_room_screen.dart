import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kio_chat/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatRoomScreen extends StatefulWidget {
  final User currentUser;
  final users;

  const ChatRoomScreen({super.key, required this.currentUser, required this.users,});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  bool _btnColor=false;
  final TextEditingController textController=TextEditingController();
  //  late ChatRoomProvider _chatRoomProvider=ChatRoomProvider();
 // final ScrollController _scrollController = ScrollController();

  DateTime currentDate=DateTime.now();
  String userUid="";
  String myUid="";
  String chatRoomId="";

  bool isChane= false;
  var selectedItem;
  var collection = FirebaseFirestore.instance;
  bool isAlready=true;

  Future<void> _sendMessage( data) async {
    var msg=textController.text;
    log(userUid.toString());
    if (msg.isNotEmpty) {

      await collection.collection("userChat").doc(chatRoomId).collection("message").add({
        "uid":myUid,
        'message': msg,
        "msgIg":FieldValue.increment(1),
        'timestamp': FieldValue.serverTimestamp(),
      }).then((onValue){
        if(isAlready){
          setChat();
        }

        log(onValue.toString());
      }).onError((e,s){
        toast(context, e);
      });
      textController.clear();
    }
  }

  Future<void> clearChat() async {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Delete all data"),
        actions: [
          ElevatedButton(onPressed: () async {
            var snapshots = await collection.collection("userChat").doc(chatRoomId).collection("message").get();
            for (var doc in snapshots.docs) {
                await doc.reference.delete();
                Navigator.pop(context);
              log(doc.toString());
            }
          }, child: const Text("Yes")),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("No")),
        ],
      );
    });

  }  late List<dynamic> allUsers;

  late SharedPreferences sharedPreferences;

  init() async {
    userUid=widget.users["uid"];
    myUid=widget.currentUser.uid;
    List<String> ids=[myUid,userUid];
    ids.sort();
    chatRoomId=ids.join("_");

  }
  TextEditingController userNameController=TextEditingController();

  void editName(){
    showDialog(context: context, builder: (_){
      return Dialog(alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 200,
          child:   Column(mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                    fillColor: CupertinoColors.systemGrey6,
                    hintText: "Name",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    filled: true,
                    prefixIcon: const Icon(Icons.person,)
                ),
              ),const SizedBox(height: 10.0,),
              ElevatedButton(onPressed: () async {

                if(userNameController.text.trim().isNotEmpty){
                  showDialog(context: context, builder: (_){
                    return const Dialog(
                      child: SizedBox(height: 50,width: 50,
                          child: Center(child: CircularProgressIndicator())),
                    );
                  });
                  await FirebaseFirestore.instance.collection('activeUser')
                      .doc("users").collection(myUid).doc(userUid).update({
                    'name': userNameController.text,
                  }).then((onValue){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }).onError((e,s){
                    Navigator.pop(context);
                  });
                }else{
                  toast(context, "enter name");
                }
              }, child: const Text("Update")),
            ],
          ),
        ),
      );
    });
  }

  setChat() async {
    await collection.collection('activeUser')
        .doc("users").collection(myUid).doc(userUid).set({
      'name': widget.users["name"],
      "email":widget.users["email"],
      "uid":widget.users["uid"]
    }).then((onValue) async {
      isAlready=false;
     // Navigator.push(context, MaterialPageRoute(builder: (context) => UserHomeScreen(user: user,)));
    });


  }

  Set<String> selectedIndexes = {};

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    var c=currentDate;
    // _chatRoomProvider=Provider.of<ChatRoomProvider>(context,listen: false);
    return  Scaffold(
      backgroundColor: Colors.yellow.shade200,
      resizeToAvoidBottomInset:true,
      appBar: AppBar(elevation: 0,backgroundColor: Colors.yellow.shade200,
      //  foregroundColor: Colors.white,
        leadingWidth: 30.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 36,height: 36,
                child: CircleAvatar()),
             Text(widget.users["name"]=="null"?widget.users["email"]:widget.users["name"].toString()),
         selectedIndexes.isEmpty? PopupMenuButton<String>(
              initialValue: selectedItem,
              onSelected: ( item) async {
                if(item=="0"){
                  clearChat();
                }else if(item=="1"){
                  editName();
                }
                else{
                 // log("sel "+selectedIndexes.elementAt(0).toString());
                  // QuerySnapshot snapshots = await collection.collection("userChat").doc(chatRoomId).collection("message").get();
                  // //snapshots.docs.first.reference.delete();
                  // for (var doc in snapshots.docs) {
                  //   //await doc.reference.delete();
                  //
                  //   //log(doc.id.toString());
                  //  // var docId= doc["timestamp"];



                   // if(docs.==='your thing you want to look for')

                   // Navigator.pop(context);

                 // }
                  toast(context, "Not Available");
                }
                //  setState(() {
                // selectedItem = item;
                log(item);
                // });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: "0",
                  child: Text('Clear'),
                ),  const PopupMenuItem(
                  value: "1",
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: "2",
                  child: Text('Setting'),
                ),
              ],
            ):

            IconButton(onPressed: () async {
              for(int i=0; i<selectedIndexes.length;i++ ){
                await collection.collection("userChat").doc(chatRoomId).collection("message")
                    .doc(selectedIndexes.elementAt(i)).delete()
                .then((onValue){
                  setState(() {
                    selectedIndexes.clear();
                  });
                }).onError((e,s){
                  toast(context, "failed");
                });
              }
            }, icon: const Icon(Icons.delete)),
          ],
        ),centerTitle: true,
      ),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:collection
                    .collection("userChat").doc(chatRoomId).collection("message")
                    .orderBy('timestamp', descending: true)
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

                  int i=-1;
                  int k=0;

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index]["message"];
                      final senderUid = messages[index]["uid"];
                      final timeStamp = messages[index]["timestamp"]??Timestamp(1733566630,395000000);
                      var date=timeStamp.toDate();
                      log(date.toString());

                      if(date.day==c.day){
                        k=k+1;
                        log("iii "+k.toString());
                        log("ii "+index.toString());
                      }else{
                        log("iiii "+k.toString());
                        log("iik "+index.toString());
                        i=k;
                       // k=0;
                        c=currentDate.subtract(const Duration(days: 1));
                      }
                      return Column(
                        children: [

                          (date.day==currentDate.day-2 && index==i ) ||( date.day==currentDate.day-2 && (index==i || index==messages.length-1))?  Container(
                            color: Colors.grey.shade300,
                            padding: const EdgeInsets.all(10.0),
                            child: const Text("Yesterday"
                            ),
                          ):Container(),


                          (date.day==currentDate.day-1 && index==i ) ||  ( date.day==currentDate.day && (index==i || index==messages.length-1)) ?Container(
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.all(10.0),
                              child: const Text("Today")):Container(),


                          ListTile(
                            onLongPress: () {
                              setState(() {
                                if (selectedIndexes.contains(messages[index].id)) {
                                  selectedIndexes.remove(messages[index].id);
                                } else {
                                  selectedIndexes.add(messages[index].id);
                                }
                              });
                            },


                            contentPadding: EdgeInsets.zero,
                            minTileHeight: 0,
                            minLeadingWidth: 0,
                            minVerticalPadding: 0,
                            title:  MessageBubble(size: size, sender: senderUid, message: message, status: true, timeStamp: date, uid: myUid, currentDate: DateTime.now(),),

                            selected: selectedIndexes.contains(messages[index].id),
                            selectedTileColor: Colors.blue.withOpacity(0.5),

                          ),




                        ],
                      );

                    },
                  );
                },
              ),
            ),
            messageBar(),
          ],
        ),
      ),
      //   bottomNavigationBar: messageBar(_chatRoomProvider),
    );
  }

  Widget  messageBar(){
    return Card(elevation: 2,
      margin: const EdgeInsets.all(10.0),
      //semanticContainer: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: SizedBox(
        //height: 50,
        //color: Colors.red,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                textAlign: TextAlign.start,
                maxLines: 1,
                onChanged: (v){
                  if(v.length==2){
                    setState(() {
                      _btnColor=true;
                    });
                  }else if(v.isEmpty){
                    setState(() {
                      _btnColor=false;
                    });
                  }
                }, decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 10.0),
                  border: InputBorder. none,
                  hintText: "Message"
              ),
              ),
            ),
            // Container(
            //   height: 1,width: size.width,
            //   color: Colors.grey.shade400,
            // ),

            IconButton(onPressed: (){
              _sendMessage("");
            }, icon: Icon(Icons.send,color: _btnColor ? Colors.yellow.shade700 : Colors.grey,))

          ],
        ),
      ),
    );

  }

}

class MessageBubble extends StatelessWidget {
  final Size size;
  final String sender;
  final String message;
  final bool status;
  final DateTime timeStamp;
  final DateTime currentDate;
  final String uid;

  const MessageBubble({super.key,required this.size ,required this.sender, required this.message, required this.status, required this.timeStamp, required this.uid, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    // Different styling for sender and receiver messages
    bool isSender = sender == uid;

    String time="${timeStamp.hour}:${timeStamp.minute}";
   //  int date=timeStamp.day;

    return  Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(elevation: 2,
        margin: isSender ? EdgeInsets.only(left: size.width*0.2,top: 10.0,right: 10.0):EdgeInsets.only(right: size.width*0.2,top: 10.0,left: 10.0),
        color: isSender ? Colors.blueAccent : Colors.grey[300]!,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0,bottom: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: isSender? CrossAxisAlignment.end:CrossAxisAlignment.start,
            children: [

              Row(mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Flexible(child: Text(message, style: TextStyle(color: isSender ? Colors.white : Colors.black),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,maxLines: 50,)),
                  const SizedBox(width: 5.0,),
                  isSender ?  status==true ? const Icon(Icons.check,size: 15,color: Colors.white,):const Icon(Icons.access_time_outlined,size: 15,color: Colors.white,):Container(),
                ],
              ),
              Text(time, style: const TextStyle(color: Colors.black87,fontSize: 12),)
            ],
          ),
        ),
      ),
    );
  }
}