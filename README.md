# omohide_map_flutter

**おもひでマップ (Omohide Map)** は、写真と短文日記を位置情報とともに投稿し、
**自分だけの思い出マップ** を作成できるアプリです。
投稿内容は翌朝、**AI によるポジティブ要約**が届き、
日常や旅行の記録を前向きな形で振り返ることができます。

---

## 特徴

- **地図 × 写真日記 × AI ポジティブ要約**

  - 写真＋短文＋位置情報で日記を投稿
  - 地図上にピンとして表示され、旅や日常の思い出を可視化
  - 翌朝、AI がポジティブ要約したメッセージを通知

- **プライベート設計**

  - デフォルトでは自分専用のマップ
  - 投稿ごとに共有リンクを発行して友人とシェア可能（予定）

- **シンプルな UI**

  - 地図画面・投稿画面・履歴画面の 3 画面構成
  - 写真と一言で簡単に思い出を残せる

---

## 技術スタック

### フロントエンド
- **Flutter** (Dart)
  - `google_maps_flutter` - 地図表示
  - `geolocator` - 現在地取得
  - `image_picker` - 写真撮影・選択
  - `firebase_auth` - ユーザー認証
  - `firebase_core` - Firebase統合
  - `dio` - HTTP通信
  - `provider` + `flutter_hooks` - 状態管理
  - `go_router` - ルーティング
  - `freezed` + `json_annotation` - データモデル生成

### バックエンド
- **Go + Echo + Gorm**
  - RESTful API
  - 投稿CRUD操作
  - AI要約生成エンドポイント

### インフラ・サービス
- **Firebase**
  - Authentication - ユーザー認証管理
  - Firestore - データベース（予定）
  - Cloud Storage - 画像ストレージ（予定）

- **AI ポジティブ要約**
  - ChatGPT API（または将来的にGo内実装）

---

## プロジェクト構成

```
lib/
├── main.dart                 # アプリエントリーポイント
├── views/                    # UI層（画面・Widget）
├── view_models/             # 状態管理・ビジネスロジック
├── repositories/            # データアクセス層
├── services/               # 外部API・共通サービス
├── models/                 # データモデル
├── providers/              # 認証・グローバル状態管理
├── router.dart             # ルーティング設定
├── utils/                  # ユーティリティ関数
└── constants/              # 定数定義
```

---

## セットアップ

### 前提条件
- Flutter 3.6.0以上
- Dart 3.6.0以上
- Firebase プロジェクトの設定

### 1. Firebase設定

Firebase CLIを使用してプロジェクトを設定:

```bash
# Firebase CLIをインストール（未インストールの場合）
npm install -g firebase-tools

# FlutterFireをインストール
dart pub global activate flutterfire_cli

# Firebaseプロジェクトと連携
flutterfire configure
```

### 2. 依存関係のインストール

```bash
flutter pub get
```

### 3. コード生成（モデルクラス）

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. アプリの起動

```bash
flutter run
```

---

## 開発コマンド

```bash
# 依存関係の取得
flutter pub get

# コード生成
flutter pub run build_runner build --delete-conflicting-outputs

# 静的解析
flutter analyze

# コードフォーマット
dart format lib/

# テスト実行
flutter test                # 全テスト実行
flutter test test/unit/     # 単体テストのみ
flutter test test/widget/   # Widgetテストのみ

# ビルド
flutter build apk           # Android
flutter build ios          # iOS
```

---

## 環境変数

アプリケーションで使用する環境変数は `.env` ファイルで管理します（gitignoreに追加済み）。

```env
# API設定
API_BASE_URL=your_api_url

# その他の設定
GOOGLE_MAPS_API_KEY=your_google_maps_key
```

---

## ライセンス

このプロジェクトはプライベートリポジトリです。