import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'restart_widget.dart';
import 'tab_options.dart';
import 'package:ntp/ntp.dart';

import 'add.dart';
import 'feed.dart';
import 'feed2.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  int nn = 2;
  late PageController pageController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  var durationInDay = 0;
  var oldDurationInDay = 0;
  var durationForMinutes = 0;
  var durationForHours = 0;
  // Timer? timer;
  DateTime ntpTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    pageController = PageController();
    _getStartTime();
    _startTimer();
    _loadNTPTime();
  }

  void _loadNTPTime() async {
    ntpTime = await NTP.now(lookUpAddress: '1.amazon.pool.ntp.org');
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    // timer?.cancel();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  _startTimer() {
    // timer =
    // Timer.periodic(const Duration(minutes: 1), (Timer t) {
    //
    _getStartTime();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Scaffold(
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Fetching Data"),
                  SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
              // color: Colors.white,
            ),
          )
        : Scaffold(
            appBar: AppBar(actions: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('$ntpTime'),
                      Text('$durationInDay')
                    ],
                  )))
            ]),
            // body: ,
            body: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      onPageChanged: onPageChanged,
                      children: [
                        Feed(durationInDay: durationInDay),
                        Feed2(),
                        AddPost(durationInDay: durationInDay)
                      ],
                    ),
            ),
            bottomNavigationBar: CupertinoTabBar(
                inactiveColor: Colors.grey,
                activeColor: Colors.black,
                backgroundColor: Color.fromARGB(255, 245, 245, 245),
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                        padding: const EdgeInsets.only(top: 3.0, right: 0),
                        // child: Icon(MyFlutterApp.home, size: 23.5),
                        child: Icon(
                          Icons.message,
                        )),
                    label: 'Posts',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                        padding: const EdgeInsets.only(top: 3.0, right: 0),
                        // child: Icon(MyFlutterApp.home, size: 23.5),
                        child: Icon(
                          Icons.message,
                        )),
                    label: 'Posts 2',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Icon(
                        Icons.add_circle,
                      ),
                    ),
                    label: 'Add',
                  ),
                ],
                currentIndex: _page,
                onTap: navigationTapped),
          );
  }

  _getStartTime() async {
    ntpTime = await NTP.now(lookUpAddress: '1.amazon.pool.ntp.org');
    print('current time is: $ntpTime');
    await firestore
        .collection('startTime')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        var timeStr = doc["time"];
        var dateTime = DateFormat('dd/MM/yy').parse(timeStr);
        // var dateTime = DateFormat('dd/MM/yy').parse('06/09/2018');
        var dateNow = ntpTime.toUtc();
        var duration = dateNow.difference(dateTime);
        var _dd = duration.inDays;
        //set old duration

        durationInDay = _dd;
        if (_dd < 60) {
          setState(() {
            durationForMinutes = _dd;
            isLoading = false;
          });
        } else {
          var _fd = _dd % 60; // for getting time
          var _hd = _dd / 60; // getting how much minute cycle done
          var _hhd = _hd.toInt();
          // print('startTime $_dd');
          // print('startTime $_fd');

          // check hours cycle getter 24
          if (_hhd < 24) {
            setState(() {
              durationForMinutes = _fd;
              durationForHours = _hhd;
              isLoading = false;
            });
          } else {
            var _hhhd = _hhd % 24; // getting how much hours cycle done

            setState(() {
              durationForMinutes = _fd;
              durationForHours = _hhhd;
              isLoading = false;
            });
          }
        }

        //checking duration changes
        if (oldDurationInDay != 0) {
          if (oldDurationInDay != durationInDay) {
            if (oldDurationInDay < durationInDay) {
              RestartWidget.restartApp(context);
            }
          }
        }

        oldDurationInDay = durationInDay;
        // print('duration.inDays ${duration.inDays}');
      });
    });
    setState(() {
      isLoading = false;
    });
  }
}
