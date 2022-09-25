import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/post.dart';
import 'package:ntp/ntp.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String title,
    var time,
  ) async {
    String res = "some error occurred";
    print(Timestamp.now().toDate());
    var timeNow = await NTP.now(lookUpAddress: '1.amazon.pool.ntp.org');
    try {
      String postId = const Uuid().v1();

      Post post = Post(
        postId: postId,
        datePublished: FieldValue.serverTimestamp(),
        title: title,
        time: time,
        endDate: timeNow.add(const Duration(
          days: 0,
          hours: 1,
          minutes: 0,
        )),
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
