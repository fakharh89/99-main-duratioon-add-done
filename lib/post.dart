import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String title;
  int time;
  final datePublished;
  final endDate;
  StreamController<Post>? updatingStream;

  Post(
      {required this.postId,
      required this.time,
      required this.title,
      required this.datePublished,
      this.updatingStream,
      required this.endDate});

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "datePublished": datePublished,
        "title": title,
        "time": time,
        "endDate": endDate,
      };

  static Post fromSnap(
    DocumentSnapshot snap,
  ) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return fromMap(
      snapshot,
    );
  }

  static Post fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return Post(
      postId: snapshot['postId'] ?? "",
      title: snapshot['title'] ?? "",
      datePublished: snapshot['datePublished'],
      time: snapshot['time'],
      endDate: snapshot['endDate'],
      updatingStream: snapshot['updatingStream'],
    );
  }
}
