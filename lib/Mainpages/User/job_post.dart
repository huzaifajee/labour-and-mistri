import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:mistriandlabours/common/theme_helper.dart';

import 'package:mistriandlabours/widgets/header_widget.dart';

class JobPost extends StatefulWidget {
  const JobPost({Key? key}) : super(key: key);

  @override
  _JobPostState createState() => _JobPostState();
}

class _JobPostState extends State<JobPost> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  var titles = "";
  var dess = "";
  final titleController = TextEditingController();
  final desController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    desController.dispose();
    super.dispose();
  }

  clearText() {
    titleController.clear();
    desController.clear();
  }

  CollectionReference deletejob = FirebaseFirestore.instance.collection('user');
  Future<void> deleteUser(id) {
    // print("User Deleted $id");
    return deletejob.doc(id).delete().then((value) => print('User Deleted')).catchError((error) => print('Failed to Delete user: $error'));
  }

  CollectionReference jobadding = FirebaseFirestore.instance.collection('user');

  Future<void> addUser() {
    return jobadding.add({'title': titles, 'des': dess}).then((value) => print('User Added')).catchError((error) => print('Failed to Add user: $error'));
  }

  deleteJob(id) async {
    await FirebaseFirestore.instance.collection("user").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      height: _headerHeight,
                      child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
                    ),
                    Positioned(left: 72, child: Container(height: 230, width: 230, child: Image(image: AssetImage("asset/images/mh.png"))))
                  ],
                ),
              ],
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'JOB',
                        style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  decoration: ThemeHelper().textInputDecoration('Title ', 'Enter your job title'),
                                  controller: titleController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter job title';
                                    }
                                    return null;
                                  },
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  decoration: ThemeHelper().textInputDecoration('description', 'Enter your job description'),
                                  controller: desController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter job description';
                                    }
                                    return null;
                                  },
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Post a Job'.toUpperCase(),
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        titles = titleController.text;
                                        dess = desController.text;
                                      });
                                      clearText();
                                      addUser();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.orangeAccent,
                                          content: Text(
                                            "Job Posted",
                                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
