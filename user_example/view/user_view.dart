import 'package:flutter/material.dart';
import 'package:hooks_example/user_example/api/firebase_provider.dart';
import 'package:hooks_example/user_example/view/create_user_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Firestoreから取得したユーザー情報を１度だけ全て表示するUI
class UserView extends ConsumerWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userStateFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const CreateUserView();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: users.when(
        data: (userList) {
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text('年齢は: ${user.age}歳'),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }
}
