import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_example/user_example/model/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Firestoreを使用するためのプロバイダー
final fireStoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// ユーザー情報を取得するためのFutureProvider
final userStateFutureProvider = FutureProvider<List<UserState>>((ref) async {
  final userStateAPI = UserStateAPI(ref);
  return userStateAPI.fetchUsers();
});

final userStateAPIProvider = Provider<UserStateAPI>((ref) => UserStateAPI(ref));

/// [ref]はプロバイダーにアクセスするためのもの
/// この場合は、fireStoreProviderを参照するためのもの
/// メソッドの中で、[collection]を参照するために使用する
class UserStateAPI {
  UserStateAPI(this.ref);
  final Ref ref;// ここに、refつけないと、メソッドでfireStoreProviderを参照できない

  Future<void> createUser(UserState userState) async {
    await ref.read(fireStoreProvider).collection('users').add(userState.toJson());// .toJsonをつけるのは、Map型に変換するため
  }

  /// Firestoreから１度だけデータを取得するには[QuerySnapshot]を使用する
  /// 特定のドキュメントを監視するには[DocumentSnapshot]を使用する。.doc('id')を使用する
  Future<List<UserState>> fetchUsers() async {
    final snapshot = await ref.read(fireStoreProvider).collection('users').get();
    return snapshot.docs.map((doc) => UserState.fromJson(doc.data())).toList();
  }
}
