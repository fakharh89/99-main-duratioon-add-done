import 'package:flutter/material.dart';
import 'package:flutter_application_1/post.dart';
import 'package:ntp/ntp.dart';
import 'package:timeago/timeago.dart' as timeago;

class Posts extends StatefulWidget {
  final Post post;
  const Posts({Key? key, required this.post}) : super(key: key);
  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late Post _post;
  DateTime ntpTime = DateTime.fromMillisecondsSinceEpoch(0000000000);
  @override
  void initState() {
    super.initState();
    _post = widget.post;
    asyncInitState();
  }

  void asyncInitState() async {
    var a = await NTP.now(lookUpAddress: '1.amazon.pool.ntp.org');
    setState(() {
      ntpTime = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    _post = widget.post;
    return SafeArea(
        child: Column(
      children: [
        ListTile(
          title: Text(_post.title),
          subtitle: Text('${_post.time}'),
        ),
      ],
    ));
  }
}
