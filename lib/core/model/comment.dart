//Flutter and Dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Self import
import 'package:Tekel/core/model/user.dart';

class Comment {
  String id;
  String text;
  User user;
  Timestamp createdAt;
  Comment(
      {this.id,
      @required this.text,
      @required this.user,
      @required this.createdAt});

  factory Comment.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Comment(
        id: doc.documentID,
        text: data['text'],
        user: User.fromFireStore(data['user']),
        createdAt: data['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.text;
    data['user'] = this.user.toJson();
    data['createdAt'] = this.createdAt;
    return data;
  }
}
