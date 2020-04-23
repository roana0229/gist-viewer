# ios-app-structure

## 全体設計

- Clean Architecture
- Multi Module
- MVVM(SwiftUI + Combine)
- ディレクトリ構成
  - Makefile
    - 開発する人が利用するコマンドを列挙
  - Configs
    - Xcode内で利用する環境変数を定義
  - StructurePlayground
    - アプリケーション本体
  - StructurePlaygroundCore
    - モジュール間で共有するコードを管理
  - StructurePlaygroundUI
    - View-ViewModelの管理
    - 画面はアプリケーションのRootなるViewのみpublic
  - StructurePlaygroundRepository
    - アプリケーションの内部データの扱いを管理
    - リモートを叩く、ローカルから取得するなど
  - GitHubAPI
    - GitHubのAPI呼び出しを管理

## 環境変数

- `Config/debug.xcconfig`
- `Config/release.xcconfig`

`xcconfig`で秘匿情報を管理し、Plist経由で利用する

```
GITHUB_TOKEN = GitHub Personal AccessToken
```

# Setup

- 初回のみ
  1. `make setup`
  2. `Config/debug.xcconfig`, `Config/release.xcconfig` を更新
- Xcodeのプロジェクトファイルに変更がある毎
  1. `make build`

# Library Management

- https://github.com/yonaskolb/mint
- https://github.com/Carthage/Carthage