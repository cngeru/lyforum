import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late String id;
  late String content;
  late int timestamp;
  late String author;
  late String authorID;

  CommentModel({
    this.id = "",
    required this.content,
    required this.timestamp,
    required this.author,
    required this.authorID,
  });
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp,
      'author': author,
      'authorID': authorID,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      content: map['content'],
      timestamp: map['timestamp'],
      author: map['author'],
      authorID: map['authorID'],
    );
  }

  factory CommentModel.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    return CommentModel(
      id: snap.id,
      content: snap['content'],
      timestamp: snap['timestamp'],
      author: snap['author'],
      authorID: snap['authorID'],
    );
  }
}
