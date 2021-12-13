# flutter-docker-template

flutter開発用のDockerテンプレート
fvmを利用して環境構築. バージョン等の情報は`.env`で管理.

## メモ
crhomeでのWEBアプリ開発環境だけ取り急ぎ整備。

## .env
各ツールのバージョンの設定箇所として`.env`は本レポジトリでは追跡しているが、
秘匿すべき環境変数を扱う場合は`.gitigonre`に追加推奨。

## ソース

`lib/main.dart`

## 端末確認

```bash
flutter devices
```

## プロジェクトセットアップ

プロジェクト作成後実行することで、有効なプラットフォームの足りていないテンプレートだけ生成。

```bash
flutter create .
```

## ビルド

ターゲット環境(`env`)を指定してビルド実行。ビルドファイルは `./build/env` 以下に生成される。

```bash
# webアプリ向け
flutter build web
```

## アプリ実行

ビルド・インストール・実行

```bash
# ターゲットデバイスをChromeに指定
# flutter run -d chrome
# 上記コマンドでは実行されないので、以下コマンドを利用.
# webはホットリスタートはできるがホットリロードはできない(webページを更新しないといけない)
# ホットリロードの効く他の端末での開発が推奨
# https://chrome.google.com/webstore/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm/related
flutter run -d web-server
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
