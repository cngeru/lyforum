import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common.dart';

class AuthenticationService {
  final FirebaseAuth _auth;

  AuthenticationService(this._auth);

  AuthUser? _authUser(User? user) {
    if (user == null) {
      return null;
    }
    return AuthUser(
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      userID: user.uid,
    );
  }

  Stream<AuthUser?> get onAuthStateChanged {
    return _auth.authStateChanges().map(_authUser);
  }

  Future<String> register(String email, String fullName, String password) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (res.user != null) {
        await res.user!.updateDisplayName(fullName);
        return "success";
      }
      return "An error occurred";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    } catch (e) {
      return "An error occurred";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (res.user != null) {
        return "success";
      }
      return "An error occurred";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred";
    } catch (e) {
      return "An error occurred";
    }
  }

  Future<void> signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      // print(e);
      return;
    }
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authenticationServiceProvider = Provider.autoDispose<AuthenticationService>((ref) {
  final _auth = ref.read(firebaseAuthProvider);
  return AuthenticationService(_auth);
});

final authUserProvider = StreamProvider.autoDispose<AuthUser?>((ref) {
  return ref.watch(authenticationServiceProvider).onAuthStateChanged;
});

final currentUser = Provider.autoDispose<AuthUser?>(((ref) => ref.watch(authUserProvider).data?.value));
