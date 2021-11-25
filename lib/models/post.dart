import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'post.g.dart';

@HiveType(typeId: 0)
class PostModel extends HiveObject {
  @HiveField(0)
  late String id = "";
  @HiveField(1)
  late String content;
  @HiveField(2)
  late int timestamp = 0;
  @HiveField(3)
  late int commentsNumber;
  @HiveField(4)
  late String author;
  @HiveField(5)
  late String authorID;
  @HiveField(6)
  late int hiveKey;

  PostModel({this.id = "", required this.content, this.timestamp = 0, this.commentsNumber = 0, required this.author, required this.authorID, this.hiveKey = 0});

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp,
      'commentsNumber': commentsNumber,
      'author': author,
      'authorID': authorID,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      content: map['content'],
      timestamp: map['timestamp'],
      commentsNumber: map['commentsNumber'],
      author: map['author'],
      authorID: map['authorID'],
    );
  }

  factory PostModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    return PostModel(
      id: snap.id,
      content: snap['content'],
      timestamp: snap['timestamp'],
      commentsNumber: snap['commentsNumber'],
      author: snap['author'],
      authorID: snap['authorID'],
    );
  }

  static fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}
