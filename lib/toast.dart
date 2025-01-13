import 'package:flutter/material.dart';

toast(context,msg){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.toString())));
}