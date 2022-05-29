import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mistriandlabours/Authpages/login_user_labour.dart';
import 'package:mistriandlabours/Mainpages/Labour/profile.dart';
import 'package:mistriandlabours/common/theme_helper.dart';
import 'package:readmore/readmore.dart';

class MyHomePageLabours extends StatefulWidget {
  MyHomePageLabours({Key? key}) : super(key: key);

  @override
  _MyHomePageLaboursState createState() => _MyHomePageLaboursState();
}

class _MyHomePageLaboursState extends State<MyHomePageLabours> {
  final Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance.collection('user').snapshots();

  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  @override
  Widget build(BuildContext context) {
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
              title: Text("jobs"),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: ListView.builder(
                itemCount: storedocs.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Container(
                      width: 300,
                      //    color: Colors.white,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      // height: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storedocs[index]["title"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                ReadMoreText(
                                  storedocs[index]["des"],
                                  style: TextStyle(color: Color.fromARGB(255, 68, 66, 66), fontSize: 15),
                                  trimLines: 2,
                                  colorClickableText: Colors.pink,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                  lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                    child: Text(
                                      "APPLY",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })),
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
                      leading: Icon(
                        Icons.person,
                        size: _drawerIconSize,
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        'edit your Profile',
                        style: TextStyle(fontSize: 17, color: Theme.of(context).accentColor),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                      },
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
}
