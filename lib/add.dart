import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_methods.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key, this.durationInDay}) : super(key: key);
  final durationInDay;

  @override
  State<AddPost> createState() => _AddPostState();
}

String nationalPost = '0';
Timer? timer;
var durationForMinutes = 0;
var durationForHours = 0;
DateTime ntpTime = DateTime.now();

class _AddPostState extends State<AddPost> {
  final TextEditingController _titleController = TextEditingController();
  bool isLoading = false;

  void sendPost() async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods()
          .uploadPost(_titleController.text, widget.durationInDay);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  getNationalPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('nationalPost') != null) {
      setState(() {
        nationalPost = prefs.getString('nationalPost')!;
      });
    }
  }

  setNationalPost(String nationalPostValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nationalPost = nationalPostValue.toString();
      prefs.setString('nationalPost', nationalPost);
    });
  }

  _startTimer() async {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) async {
      var ntpTime = await NTP.now(lookUpAddress: '1.amazon.pool.ntp.org');
      // var dateNow = DateTime.now();
      setState(() {
        durationForMinutes = 59 - ntpTime.minute;
        durationForHours = 23 - ntpTime.hour;
      });
      //durationForMinutes <= 0 &&
      durationForHours <= 0 ? setNationalPost('0') : null;
    });
  }

  _initTimer() async {
    var ntpTime = await NTP.now(lookUpAddress: '1.amazon.pool.ntp.org');
    // if (!initialized)
    setState(() {
      durationForMinutes = 59 - ntpTime.minute;
      durationForHours = 23 - ntpTime.hour;
    });
    //durationForMinutes <= 0 &&
    durationForHours <= 0 ? setNationalPost('0') : null;
  }

  @override
  void initState() {
    super.initState();
    _initTimer();
    _startTimer();
    getNationalPost();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print('built add');
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Add Post')),
            SizedBox(height: 6),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : InkWell(
                      onTap: () {
                        sendPost();
                        setNationalPost('1');
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        color: Colors.blue,
                        alignment: Alignment.center,
                        child: Text(
                          'Send Post',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
            Text('minutes: ${durationForMinutes}'),
            Text('hours: ${durationForHours}'),
            Text('nationalPost: ${nationalPost}')
          ],
        ),
      ),
    );
  }
}
