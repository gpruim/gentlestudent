import 'dart:async';

import 'package:Gentle_Student/models/category.dart';
import 'package:Gentle_Student/models/difficulty.dart';
import 'package:Gentle_Student/models/opportunity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OpportunityApi {

  Future<List<Opportunity>> getAllOpportunities() async {
    return (await Firestore.instance.collection('Opportunities').getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  StreamSubscription watch(Opportunity opportunity, void onChange(Opportunity opportunity)) {
    return Firestore.instance
        .collection('Opportunities')
        .document(opportunity.opportunityId)
        .snapshots
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Opportunity _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;

    return new Opportunity(
      opportunityId: snapshot.documentID,
      name: data['name'],
      difficulty: _dataToDifficulty(data['difficulty']),
      category: _dataToCategory(data['category']),
      badgeImageUrl: data['badgeImageUrl'],
      opportunityImageUrl: data['oppImageUrl'],
      shortDescription: data['shortDescription'],
      longDescription: data['longDescription'],
      beginDate: DateTime.parse(data['beginDate']),
      endDate: DateTime.parse(data['endDate']),
      street: data['street'],
      postalCode: data['postalCode'],
      city: data['city'],
      issuerName: data['issuerName'],
    );
  }

  Difficulty _dataToDifficulty(int difficulty) {
    switch (difficulty) {
      case 0:
        return Difficulty.BEGINNER;
      case 1:
        return Difficulty.INTERMEDIATE;
      case 2:
        return Difficulty.EXPERT;
    }
    return Difficulty.BEGINNER;
  }

  Category _dataToCategory(int category) {
    switch (category) {
      case 0:
        return Category.DUURZAAMHEID;
      case 1:
        return Category.DIGITALEGELETTERDHEID;
      case 2:
        return Category.ONDERNEMINGSZIN;
      case 3:
        return Category.ONDERZOEK;
      case 4:
        return Category.WERELDBURGERSCHAP;
    }
    return Category.DUURZAAMHEID;
  }
}
