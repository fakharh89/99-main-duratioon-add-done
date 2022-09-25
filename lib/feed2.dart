import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'posts.dart';

class Feed2 extends StatefulWidget {
  const Feed2({Key? key}) : super(key: key);
  //const Feed2({Key? key,this.durationForMinutes,this.durationForHours}) : super(key: key);
  // final durationForMinutes;
  // final durationForHours;

  @override
  State<Feed2> createState() => _Feed2State();
}

class _Feed2State extends State<Feed2> {
  // Timer? timer;
  var durationForMinutes = 0;
  var durationForHours = 0;

  @override
  void initState() {
    super.initState();
    // _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    // timer?.cancel();
  }

  // _startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 0), (Timer t) {
  //     var dateNow = DateTime.now();
  //     setState(() {
  //       durationForMinutes = 59 - dateNow.minute;
  //       durationForHours = 23 - dateNow.hour;
  //     });
  //     //  print('object ${dateNow.minute}: ${dateNow.hour}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          //minutes
          //countdown from 59 to 0
          Row(
            children: [
              Text('${durationForMinutes} hello'),
            ],
          ),

          //hours
          //countdown from 23 to 0
          Row(
            children: [
              Text('${durationForHours}'),
            ],
          ),
        ],
      )),
    );
  }
}
