import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common.dart';

class AuthModel extends ChangeNotifier {
  final AuthenticationService _auth;

  AuthModel(this._auth);

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setBusy(bool val) {
    _isBusy = val;
    notifyListeners();
  }

  Future<String> register(String email, String fullName, String password) async {
    try {
      setBusy(true);
      String res = await _auth.register(email, fullName, password);
      setBusy(false);
      return res;
    } catch (e) {
      setBusy(false);
      return "An error occurred";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      setBusy(true);
      String res = await _auth.login(email, password);
      setBusy(false);
      return res;
    } catch (e) {
      setBusy(false);
      return "An error occurred";
    }
  }

  Future<void> logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return;
    }
  }
}

final authViewModel = ChangeNotifierProvider<AuthModel>((ref) {
  final _auth = ref.read(authenticationServiceProvider);
  return AuthModel(_auth);
});
