import 'package:flutter/material.dart';

class  extends StatefulWidget { 
 createState () => State(); 
 } 
 class State extends State<>{ 
 double _screenWidth; 
 double _screenHeight;  
 @override 
 Widget build(BuildContext context) { 
 _screenWidth = MediaQuery.of(context).size.width; 
 _screenHeight = MediaQuery.of(context).size.height; 
 return null; 
 } }