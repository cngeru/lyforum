import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyforum/common.dart';

class HomeModel extends ChangeNotifier {
  final FirestoreService _db;

  HomeModel(this._db);

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  Future<bool> createPost(String content, String name, String id) async {
    try {
      setBusy(true);
      bool res = await _db.createPost(
        PostModel(
          content: content,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          author: name,
          authorID: id,
        ),
      );
      setBusy(false);
      return res;
    } catch (e) {
      setBusy(false);
      return false;
    }
  }

  Future<bool> createDraft(String content, String name, String id) async {
    try {
      setBusy(true);
      var rnd = Random.secure();
      var next = rnd.nextDouble() * 1000000;
      while (next < 100000) {
        next *= 10;
      }
      var _postModel = PostModel(
        id: "",
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        author: name,
        authorID: id,
        commentsNumber: 0,
        hiveKey: next.toInt(),
      );
      final _boxes = HiveService.getDrafts();
      _boxes.put(next.toInt(), _postModel);
      setBusy(false);
      return true;
    } catch (e) {
      // print(e);
      setBusy(false);
      return false;
    }
  }

  Future<bool> createComment(String postID, String text, String name, String userID) async {
    try {
      setBusy(true);
      bool res = await _db.addComment(
        postID,
        CommentModel(
          content: text,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          author: name,
          authorID: userID,
        ),
      );
      setBusy(false);
      return res;
    } catch (e) {
      setBusy(false);
      return false;
    }
  }

  Future<bool> editPost(String id, String text) async {
    setBusy(true);
    try {
      bool res = await _db.editPost(
        id,
        text,
      );
      setBusy(false);
      return res;
    } catch (e) {
      setBusy(false);
      return false;
    }
  }

  Future<bool> deletePost(String id) async {
    try {
      bool res = await _db.deletePost(id);
      setBusy(false);
      return res;
    } catch (e) {
      setBusy(false);
      return false;
    }
  }
}

final homeViewModel = ChangeNotifierProvider<HomeModel>((ref) {
  final db = ref.read(databaseProvider);
  return HomeModel(db!);
});
