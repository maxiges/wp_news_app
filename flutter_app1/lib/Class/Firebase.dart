import 'package:cloud_firestore/cloud_firestore.dart';

final fbDataFromBaseRef = FirebaseFirestore.instance
    .collection('dataFromBase')
    .withConverter<DataFromDb>(
      fromFirestore: (snapshots, _) => DataFromDb.fromJson(snapshots.data()!),
      toFirestore: (data, _) => data.toJson(),
    );

class DataFromDb {
  final String description;
  final String id;

  DataFromDb(this.id, this.description);

  DataFromDb.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
      };
}

final fbDataFromBaseWebsRef = FirebaseFirestore.instance
    .collection('dataFromBaseWebs')
    .withConverter<DataFromWebsDb>(
      fromFirestore: (snapshots, _) =>
          DataFromWebsDb.fromJson(snapshots.data()!),
      toFirestore: (data, _) => data.toJson(),
    );

class DataFromWebsDb {
  final String description;
  final String id;

  DataFromWebsDb(this.id, this.description);

  DataFromWebsDb.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
      };
}
