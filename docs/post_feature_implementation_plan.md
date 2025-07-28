# 投稿機能実装計画

## 概要

位置情報を取得し、現在地・写真・文章をバックエンドに送信する投稿機能を実装する。

## 機能要件

### 1. 位置情報取得

- ユーザーの現在地（緯度・経度）を取得
- 位置情報の権限リクエスト処理
- 権限が拒否された場合のエラーハンドリング

### 2. 写真機能

- カメラで撮影
- ギャラリーから選択
- 画像のプレビュー表示
- 画像の圧縮・リサイズ処理
- base64 形式への変換

### 3. 投稿内容

- テキスト入力（文章 1 文字以上 256 文字以下）
- 位置情報（自動取得 or 手動入力）
- 写真（0 枚以上 4 枚以下）
- 投稿日時（自動設定）

### 4. API 連携

- Supabase の JWT アクセストークンを使用した認証
- base64 形式の画像データを含む投稿データの送信
- エラーハンドリング
- ローディング状態の管理

## 技術スタック

### パッケージ

- すでにインストールされているパッケージを使用する

### 状態管理

- Provider
  - グローバル state なら Provider を使う
- Hooks
  - ローカル state なら Hooks を使う

riverpod は使用しない

## 実装手順

### Phase 1: 基本機能の実装

1. **位置情報取得サービスの作成**

   - `LocationService`クラスの実装
   - 権限リクエスト処理
   - 現在地取得メソッド

2. **画像選択・撮影機能**
   - `ImageService`クラスの実装
   - カメラ/ギャラリー選択の UI
   - 画像圧縮処理
   - base64 エンコーディング処理

### Phase 2: UI 実装（MVVM）

1. **投稿画面の作成**

   - `views/post/post_screen.dart` - UI 実装
   - `view_models/post_view_model.dart` - 画面ロジック
   - テキスト入力フィールド
   - 画像プレビュー
   - 位置情報表示
   - 投稿ボタン

2. **投稿確認ダイアログ**
   - 投稿内容のプレビュー
   - 編集・キャンセル機能

### Phase 3: バックエンド連携

1. **API 実装**

   - `api/post_api.dart` - API クライアント
   - `repositories/post_repository.dart` - リポジトリ層
   - Supabase の JWT トークンをヘッダーに設定
   - base64 画像データを含む投稿作成

2. **状態管理**
   - `providers/post_provider.dart` - グローバル state
   - Supabase の認証状態の監視
   - エラーハンドリング
   - ローディング状態

### Phase 4: エラー処理と UX 改善

1. **エラーハンドリング**

   - ネットワークエラー
   - 権限エラー
   - バリデーションエラー

2. **UX 改善**
   - プログレスインジケーター
   - 成功/失敗のフィードバック
   - オフライン時の処理

## ディレクトリ構造（MVVM）

```
lib/
├── models/
│   └── post_model.dart
├── views/
│   └── post/
│       ├── post_page.dart
│       └── components/
│           ├── image_picker_component.dart
│           └── location_display_component.dart
├── view_models/
│   └── post_view_model.dart
├── providers/
│   └── post_provider.dart
├── repositories/
│   └── post_repository.dart
├── api/
│   └── post_api.dart
├── services/
│   ├── location_service.dart
│   └── image_service.dart
└── utils/
    └── image_utils.dart
```

## API エンドポイント仕様

### 投稿作成（画像含む）

```
POST /api/posts
Content-Type: application/json
Authorization: Bearer {supabase_jwt_access_token}

Request Body:
{
  "text": "string",
  "latitude": number,
  "longitude": number,
  "images": ["base64_string"],  // base64エンコードされた画像データの配列
  "createdAt": "ISO8601"
}

Response:
{
  "id": "string",
  "text": "string",
  "latitude": number,
  "longitude": number,
  "imageUrls": ["string"],  // 保存された画像のURL配列
  "createdAt": "ISO8601"
}
```

## セキュリティ考慮事項

1. **位置情報**

   - 精度の調整（必要最小限の精度）
   - ユーザーの同意取得

2. **画像**

   - EXIF データの削除
   - 適切なサイズへの圧縮
   - base64 変換前のファイルサイズ制限
   - アップロード前のバリデーション

3. **API 通信**
   - HTTPS 通信、dio を使用
   - Supabase の JWT アクセストークンの適切な管理
   - トークンの有効期限チェックと自動更新
   - エラー時の適切なメッセージ表示
   - base64 データのサイズ制限

## テスト計画

1. **単体テスト**

   - ViewModel のテスト
   - リポジトリのモックテスト
   - 画像変換処理のテスト

2. **統合テスト**

   - 投稿フロー全体のテスト
   - エラーケースのテスト

3. **E2E テスト**
   - 実際の投稿作成フロー
   - 権限拒否時の動作確認
