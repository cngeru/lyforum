import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyforum/common.dart';

class ProfileModel extends ChangeNotifier {
  final FirestoreService _db;
  ProfileModel(this._db);

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  Future<bool> uploadDraft(PostModel draft) async {
    try {
      setBusy(true);
      var _draft = draft..timestamp = DateTime.now().millisecondsSinceEpoch;
      bool res = await _db.createPost(_draft);
      setBusy(false);
      return res;
    } catch (e) {
      setBusy(false);
      return false;
    }
  }

  @override
  void dispose() {
    Hive.box('drafts').close();
    super.dispose();
  }
}

final profileViewModel = ChangeNotifierProvider<ProfileModel>((ref) {
  final _db = ref.read(databaseProvider);
  return ProfileModel(_db!);
});
