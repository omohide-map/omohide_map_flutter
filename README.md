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

- **フロントエンド**: Flutter (Dart)

  - `google_maps_flutter` で地図表示
  - `geolocator` で現在地取得
  - `image_picker` で写真撮影・選択
  - `supabase_flutter` で認証・データ保存

- **バックエンド**: Go + Echo + Gorm

  - Supabase Postgres を操作する API
  - 投稿 CRUD・要約生成 API

- **データベース & ストレージ**: Supabase

  - Auth / Storage / Postgres を使用

- **AI ポジティブ要約**: ChatGPT API（または将来的に Go 内実装）

## 技術スタック

- **Flutter**: ^3.6.0
- **Dart**: ^3.6.0
- **状態管理**: Provider + flutter_hooks
- **ルーティング**: go_router
- **HTTP 通信**: dio
- **JSON 処理**: freezed + json_annotation

## アーキテクチャ

```
lib/
├── main.dart                 # アプリエントリーポイント
├── views/                    # UI層（画面・Widget）
├── view_models/             # 状態管理・ビジネスロジック
├── repositories/            # データアクセス層
├── services/               # 外部API・共通サービス
├── models/                 # データモデル
├── utils/                  # ユーティリティ関数
└── constants/              # 定数定義
```

## セットアップ

### 1. 依存関係のインストール

```bash
flutter pub get
```

### 2. コード生成（モデルクラス）

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. アプリの起動

```bash
flutter run
```

## 開発コマンド

```bash
# 依存関係の取得
flutter pub get

# コード生成
flutter packages pub run build_runner build --delete-conflicting-outputs

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
