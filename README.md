# omohide_map_flutter

**おもひでまっぷ (Omohide Map)** は、写真と短文日記を位置情報とともに投稿し、**自分だけの思い出マップ** を作成できるアプリです。
投稿内容は翌朝、**AI によるポジティブ要約**が届き、日常や旅行の記録を前向きな形で振り返ることができます。

---

## 技術スタック

### フロントエンド

- **Flutter** (Dart)
  - `google_maps_flutter` - 地図表示
  - `geolocator` - 現在地取得
  - `image_picker` - 写真撮影・選択
  - `firebase_auth` - ユーザー認証
  - `firebase_core` - Firebase 統合
  - `dio` - HTTP 通信
  - `provider` + `flutter_hooks` - 状態管理
  - `go_router` - ルーティング
  - `freezed` + `json_annotation` - データモデル生成

### バックエンド

- **Go + Echo + Gorm**
  - RESTful API
  - 投稿 CRUD 操作
  - AI 要約生成エンドポイント
    - OpenAI API 4o-mini を使用して要約を生成

### インフラ・サービス

- **Firebase**

  - Authentication
  - Firestore

- 画像ストレージは Amazon S3 を使用

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

- Flutter 3.6.0 以上
- Dart 3.6.0 以上
- Firebase プロジェクトの設定

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
