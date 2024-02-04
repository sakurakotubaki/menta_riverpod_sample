import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_state.freezed.dart';

part 'user_state.g.dart';

/// [freezed]のファイルを生成するコマンド
/// [watch]をつけるとファイルを監視して変更があるたびに自動で生成してくれる
/// 停止するときは、[Ctrl + C]で停止する
// flutter pub run build_runner watch --delete-conflicting-outputs

@freezed
class UserState with _$UserState {
  const factory UserState({
    required String name,
    required int age,
  }) = _UserState;

  factory UserState.fromJson(Map<String, Object?> json)
      => _$UserStateFromJson(json);
}
