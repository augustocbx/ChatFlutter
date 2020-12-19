import 'dart:async';
import 'dart:io';

import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> _sendMessage({String text, File imgFile}) async {
    Map<String, dynamic> data = {};
    if (imgFile != null){
      UploadTask task = FirebaseStorage.instance.ref().child(
        DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);
      TaskSnapshot taskSnapshot = await task.whenComplete((){});
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imageUrl'] = url;

    }
    if (text != null) data['text'] = text;
    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá'),
        elevation: 0.0,
      ),
      body: TextComposer(_sendMessage),
    );
  }
}
