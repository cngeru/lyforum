import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../common.dart';

class FirestoreService {
  final FirebaseFirestore _db;
  final String _uid;
  FirestoreService(this._uid, this._db);

  Stream<List<PostModel>> allPosts() async* {
    try {
      yield* _db
          .collection("posts")
          .limit(30)
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => PostModel.fromSnap(doc)).toList());
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Stream<List<PostModel>> userPosts() async* {
    try {
      yield* _db
          .collection("posts")
          .where("authorID", isEqualTo: _uid)
          .limit(30)
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => PostModel.fromSnap(doc)).toList());
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<bool> addComment(String postID, CommentModel comment) async {
    try {
      WriteBatch _batch = _db.batch();
      _batch.set(_db.collection("posts").doc(postID).collection("comments").doc(), comment.toMap());
      _batch.update(_db.collection("posts").doc(postID), {
        "commentsNumber": FieldValue.increment(1),
      });
      await _batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<CommentModel>> postComments(String postID) async* {
    try {
      yield* _db
          .collection("posts")
          .doc(postID)
          .collection("comments")
          .limit(10)
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => CommentModel.fromSnap(doc)).toList());
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<bool> createPost(PostModel post) async {
    try {
      await _db.collection("posts").add(post.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editPost(String postID, String newText) async {
    try {
      await _db.collection("posts").doc(postID).update({"content": newText});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePost(String postID) async {
    try {
      await _db.collection("posts").doc(postID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final _firestoreDBProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final databaseProvider = Provider.autoDispose<FirestoreService?>((ref) {
  final _auth = ref.watch(authUserProvider);
  final _db = ref.read(_firestoreDBProvider);
  final _uid = _auth.data?.value?.userID;

  if (_uid != null) {
    return FirestoreService(_uid, _db);
  }
  return null;
});

final myPostsProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  return ref.read(databaseProvider)!.userPosts();
});

final postsProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  return ref.read(databaseProvider)!.allPosts();
});

final commentsProvider = StreamProvider.autoDispose.family<List<CommentModel>, String>((ref, postID) {
  return ref.read(databaseProvider)!.postComments(postID);
});
