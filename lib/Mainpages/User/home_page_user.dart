import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:mistriandlabours/Authpages/Labour/profile_page.dart';
import 'package:mistriandlabours/Authpages/login_user_labour.dart';

import 'package:mistriandlabours/Mainpages/User/job_post.dart';

import 'package:mistriandlabours/common/theme_helper.dart';
import 'package:mistriandlabours/servius/firedata.dart';

class MyHomePageUsers extends StatefulWidget {
  @override
  _MyHomePageUsersState createState() => _MyHomePageUsersState();
}

class _MyHomePageUsersState extends State<MyHomePageUsers> {
  double rating = 0;
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;
  final Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance.collection('labour').snapshots();
  final TextEditingController searchcsontroller = TextEditingController();
  QuerySnapshot? snapshotdata;
  bool isExicuted = false;

  @override
  Widget build(BuildContext context) {
    Widget searchData() {
      return ListView.builder(
          itemCount: snapshotdata!.docs.length,
          itemBuilder: (
            context,
            index,
          ) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePageLabour(
                          location: snapshotdata!.docs[index]['location'],
                          phone: snapshotdata!.docs[index]['phone'].toString(),
                          member: snapshotdata!.docs[index]['member'].toString(),
                          name: snapshotdata!.docs[index]["name"],
                          about: snapshotdata!.docs[index]['about']),
                    ));
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("asset/images/mh.png"),
                ),
                title: Text(snapshotdata!.docs[index]["name"]),
                subtitle: Text(snapshotdata!.docs[index]["location"]),
              ),
            );
          });
    }

    return StreamBuilder<QuerySnapshot>(
        stream: studentsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();

          return Scaffold(
            appBar: AppBar(
              actions: [
                GetBuilder<DataController>(
                    init: DataController(),
                    builder: (val) {
                      return IconButton(
                          onPressed: () {
                            val.querydata(searchcsontroller.text).then((value) {
                              snapshotdata = value;
                              setState(() {
                                isExicuted = true;
                              });
                            });
                          },
                          icon: Icon(Icons.search));
                    })
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "search by location",
                  hintStyle: TextStyle(color: Colors.black),
                ),
                controller: searchcsontroller,
              ),
            ),
            body: isExicuted
                ? searchData()
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Container(
                                  height: double.maxFinite,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: storedocs.length,
                                      itemBuilder: (BuildContext context, index) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/images/mh.png"), fit: BoxFit.cover)),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        storedocs[index]["name"],
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                      ),
                                                      Row(
                                                        children: [
                                                          RatingBar.builder(
                                                            initialRating: 5,
                                                            minRating: 1,
                                                            itemPadding: EdgeInsets.zero,
                                                            direction: Axis.horizontal,
                                                            itemSize: 20,
                                                            updateOnDrag: true,
                                                            itemCount: 5,
                                                            itemBuilder: (context, _) => Icon(
                                                              Icons.star,
                                                              color: Colors.amber,
                                                            ),
                                                            onRatingUpdate: (rating) {
                                                              setState(() {
                                                                this.rating = rating;
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                            "$rating",
                                                            style: TextStyle(fontSize: 12),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        "location: ${storedocs[index]["location"].toString()}",
                                                        style: TextStyle(fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => ProfilePageLabour(
                                                                location: storedocs[index]['location'],
                                                                phone: storedocs[index]['phone'].toString(),
                                                                member: storedocs[index]['member'].toString(),
                                                                name: storedocs[index]["name"],
                                                                about: storedocs[index]['about'])));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                    decoration: ThemeHelper().buttonBoxDecoration(context),
                                                    child: Text(
                                                      "View Profile",
                                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            drawer: Drawer(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [
                  0.0,
                  1.0
                ], colors: [
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Theme.of(context).accentColor.withOpacity(0.5),
                ])),
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 1.0],
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).accentColor,
                          ],
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Labour and misteri",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.login_rounded, size: _drawerIconSize, color: Theme.of(context).accentColor),
                      title: Text(
                        'News feed',
                        style: TextStyle(fontSize: _drawerFontSize, color: Theme.of(context).accentColor),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                    ListTile(
                      leading: Icon(Icons.add_box, size: _drawerIconSize, color: Theme.of(context).accentColor),
                      title: Text(
                        'Post a job',
                        style: TextStyle(fontSize: _drawerFontSize, color: Theme.of(context).accentColor),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => JobPost()));
                      },
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                      height: 1,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout_rounded,
                        size: _drawerIconSize,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(fontSize: _drawerFontSize, color: Theme.of(context).accentColor),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(title: Text("Logout"), content: Text("Are you sure you want to logout "), actions: [
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUserLabour()));
                                  },
                                ),
                              ]);
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void openHotelPage() {}
}
