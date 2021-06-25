import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase_db {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> ubicacion({required String id}) {
    return firebaseFirestore
        .collection('user')
        .doc(id)
        .collection('ubicacion')
        .orderBy('id', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> camino(
      {required String id, required DateTime dateTime}) {
    return firebaseFirestore
        .collection('user')
        .doc(id)
        .collection('ubicacion')
        .where('dia', isEqualTo: dateTime.day.toString())
        .snapshots();
  }

  Stream<QuerySnapshot> camino2(
      {required String id, required DateTime dateTime}) {
    return firebaseFirestore
        .collection('user')
        .doc(id)
        .collection('ubicacion')
        //.where('dia', isEqualTo: dateTime.day.toString())
        .snapshots();
  }
}
