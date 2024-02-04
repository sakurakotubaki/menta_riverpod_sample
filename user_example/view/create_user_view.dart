import 'package:flutter/material.dart';
import 'package:hooks_example/user_example/api/firebase_provider.dart';
import 'package:hooks_example/user_example/model/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// GlobalKeyを使用するためのProvider
final createUserViewKeyProvider = Provider((ref) => GlobalKey<FormState>());

class CreateUserView extends ConsumerWidget {
  const CreateUserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.readを使用して、createUserViewKeyProviderを参照する
    final key = ref.read(createUserViewKeyProvider);
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: key, // GlobalKeyを使用するためのkey。これで、Formの状態を管理できる
            child: Center(
              child: Column(
                children: [
                  // 人間のiconを表示
                  const Icon(
                    Icons.person,
                    size: 100,
                  ),
                  const SizedBox(height: 20),

                  /// [TextFormField]の値がnullの場合、validationが実行される
                  SizedBox(
                    width: 259,
                    height: 50,
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '名前',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '名前を入力してください';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 259,
                    height: 50,
                    child: TextFormField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        labelText: '年齢',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '年齢を入力してください';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // ifで、Formの状態が正しいかを確認する。trueの場合、データを登録する。falseの場合、エラーメッセージを表示する!
                      if (key.currentState!.validate()) {
                        // freezedのクラスをインスタンス化して、Formの値を渡す
                        final userState = UserState(
                          name: nameController.text,
                          age: int.parse(ageController.text),
                        );
                        await ref
                            .read(userStateAPIProvider)
                            .createUser(userState);
                        // ここで、userStateFutureProviderをinvalidateすることで、再度データを取得する。
                        // 強制的に状態を更新することができる。Streamを使いたくない場合に使用してます。
                        ref.invalidate(userStateFutureProvider);
                      }
                    },
                    child: const Text('登録'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
