import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/model_class.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;

  initDB() {
    collectionReference = firestore.collection('employees');
  }

  insertData({required Employee data, required String? i}) async {
    initDB();

    Map<String, dynamic> emp = {
      'name': data.name,
      'age': data.age,
      'city': data.city,
      'role': data.role,
    };

    DocumentSnapshot documentSnapshot =
    await firestore.collection('counter').doc('emp_counter').get();

    Map myId = documentSnapshot.data() as Map;

    int fetchedId = myId['id'];

    // employee collectionReference

    await collectionReference!.doc("$i").set(emp);

    await firestore
        .collection('counter')
        .doc('emp_counter')
        .update({'id': ++fetchedId});
  }

  deleteData({required String id}) async {
    initDB();

    DocumentSnapshot documentSnapshot =
    await firestore.collection('counter').doc('emp_counter').get();

    Map myId = documentSnapshot.data() as Map;

    int fetchedId = myId['id'];

    await collectionReference!.doc(id).delete();

    await firestore
        .collection('counter')
        .doc('emp_counter')
        .update({'id': --fetchedId});
  }

  updateData({required Employee data, required String? id}) async {
    initDB();

    DocumentSnapshot documentSnapshot =
    await firestore.collection('counter').doc('emp_counter').get();

    Map myId = documentSnapshot.data() as Map;

    int fetchedId = myId['id'];

    await collectionReference!.doc(id).delete();
  }
}