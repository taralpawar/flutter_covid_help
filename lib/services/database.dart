import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_help/models/needs.dart';

class DatabaseService {
  final CollectionReference helpCollection =
      FirebaseFirestore.instance.collection('help');

  final CollectionReference needCollection =
      FirebaseFirestore.instance.collection('need');

  Future updateHelpDatabase(Map helpData) async {
    return await helpCollection.doc().set({
      'user': helpData['user'],
      'name': helpData['name'],
      'phone': helpData['phone'],
      'city': helpData['city'],
      'help': helpData['help'],
      'quantity': helpData['quantity'],
      'extra': helpData['extra'],
      'organization': helpData['organization'],
    });
  }

  Future updateNeedDatabase(Map needData) async {
    return await needCollection.doc().set({
      'name': needData['name'],
      'age': needData['age'],
      'gender': needData['gender'],
      'address': needData['address'],
      'city': needData['city'],
      'phone': needData['phone'],
      'helpInfo': needData['helpInfo'],
      'prescription': needData['prescription'],
    });
  }

  getNeedsByCity(String cityName) {
    return needCollection
        .where('city', isEqualTo: cityName)
        .get()
        .then(needsListFromSnapshot);
    //.map(needsListFromSnapshot);
  }

  List<Needs> needsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Needs(
          name: doc.data()['name'],
          age: doc.data()['age'],
          gender: doc.data()['gender'],
          city: doc.data()['city'],
          phone: doc.data()['phone'],
          prescription: doc.data()['prescription'],
          helpInfo: doc.data()['helpInfo']);
    }).toList();
  }

  
}
