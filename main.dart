import 'dart:io';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main()  async{
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 runApp(MyAIApp());
}

class MyAIApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: "ProcedureTable",
     theme: ThemeData(
       primarySwatch: Colors.blue,
       visualDensity: VisualDensity.adaptivePlatformDensity,
     ),
     home: ProcedureTable(),
   );
 }
}

class ProcedureTable extends StatefulWidget {
 @override
 _ProcedureTableState createState() => _ProcedureTableState();
}

class _ProcedureTableState extends State<ProcedureTable> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(
         title: Text("手順一覧"),
       ),
       body: Container(
         child: _buildBody(context),
       ),
       floatingActionButton: Container(
         margin:EdgeInsets.only(bottom: 50.0),
         child: FloatingActionButton(
           // onPressed:(){_getImageAndFindFace(context, ImageSource.gallery);} ,
           // tooltip: "Select Image",
           // heroTag: "gallery",
             child: Icon(Icons.add_photo_alternate),
           ),
       )

   );
 }

 Widget _buildBody(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
     stream: FirebaseFirestore.instance.collection("procedures").orderBy("date", descending: true).limit(10).snapshots(),
     builder: (context, snapshot) {
       if (!snapshot.hasData) return LinearProgressIndicator();
       return _buildList(context, snapshot.data.docs);
     },
   );
 }

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapList) {
   return ListView.builder(
       padding: const EdgeInsets.all(18.0),
       itemCount: snapList.length,
       itemBuilder: (context, i) {
         return _buildListItem(context, snapList[i]);
       }
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot snap) {
   Map<String, dynamic> _data = snap.data();
   DateTime _datetime = _data["date"].toDate();
   var _formatter = DateFormat("MM/dd HH:mm");
   String postDate = _formatter.format(_datetime);

   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical:9.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(8.0),
       ),
       child: ListTile(
         leading: Text(postDate),
         title: Text(_data["name"]),
         onTap: (){
           Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => null,)
           );
         },
       ),
     ),
   );
 }

}
