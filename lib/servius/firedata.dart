import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future querydata(String queryString) async {
    return FirebaseFirestore.instance.collection("labour").where("location", isGreaterThanOrEqualTo: queryString).get();
  }
}
