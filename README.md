# KINTO FACTORY 開発環境 - Nix Configuration

このリポジトリは、KINTO FACTORY の開発環境を Nix Flakes + nix-darwin + home-manager で宣言的に管理するための設定です。

## 目次

- [Nixとは？](#nixとは)
- [なぜNixを使うのか？](#なぜnixを使うのか)
- [重要な概念](#重要な概念)
- [セットアップ手順](#セットアップ手順)
- [日常的な使い方](#日常的な使い方)
- [設定のカスタマイズ](#設定のカスタマイズ)
- [トラブルシューティング](#トラブルシューティング)
- [FAQ](#faq)

## Nixとは？

Nix は **純粋関数型パッケージマネージャー** です。従来のパッケージマネージャー（Homebrew, apt など）との最大の違いは、**再現可能性**と**宣言的な設定**にあります。

### 従来のパッケージマネージャーとの違い

| 特徴 | Homebrew | Nix |
|------|----------|-----|
| パッケージの管理 | グローバルに1バージョン | 複数バージョン共存可能 |
| 設定方法 | コマンドで逐次実行 | 設定ファイルで宣言 |
| 再現性 | 低い（時期により結果が変わる） | 高い（ロックファイルで固定） |
| ロールバック | 手動で対応 | 自動でサポート |
| 依存関係 | 共有（競合の可能性） | 隔離（競合なし） |

## なぜNixを使うのか？

### 1. 完全な再現可能性

```bash
# 新しいMacでも同じ環境を即座に構築
git clone <this-repo>
./scripts/install.sh
```

`flake.lock` により、全てのパッケージのバージョンが固定されます。1年後に別のマシンでセットアップしても、全く同じ環境が再現されます。

### 2. 宣言的な設定

「このツールをインストールして、この設定にして...」という手順書は不要です。全ての設定が `.nix` ファイルに記述されています。

```nix
# packages.nix
home.packages = with pkgs; [
  go
  nodejs_20
  terraform
];
```

### 3. 安全なロールバック

```bash
# 何か壊れた！前の状態に戻す
make rollback

# 過去のgeneration一覧を確認
make history
```

### 4. プロジェクトごとの環境分離

`direnv` + `flake.nix` で、プロジェクトごとに異なるツールバージョンを使えます。

## 重要な概念

### Nix Flakes

Flakes は Nix の新しいプロジェクト管理機能です。

- `flake.nix`: 設定の入り口。依存関係と出力を定義
- `flake.lock`: 依存関係のバージョンを固定（自動生成）

```nix
# flake.nix の構造
{
  inputs = { ... };   # 依存関係の定義
  outputs = { ... };  # 設定の出力
}
```

### nix-darwin

macOS のシステム設定を Nix で管理するツールです。

管理できるもの:
- Homebrew のパッケージ（casks, brews）
- macOS のシステム設定（Dock, Finder, Trackpad など）
- Nix daemon の設定
- システムサービス

### home-manager

ユーザー環境を Nix で管理するツールです。

管理できるもの:
- ユーザーパッケージ
- シェル設定（Zsh, Bash）
- プログラム設定（Git, Neovim, Starship など）
- 環境変数
- dotfiles

### ディレクトリ構造

```
nix-config/
├── flake.nix              # 設定の入り口
├── flake.lock             # バージョン固定（自動生成）
├── darwin/                # nix-darwin 設定
│   ├── default.nix        # Nix daemon, 基本設定
│   ├── homebrew.nix       # Homebrew パッケージ
│   └── system.nix         # macOS システム設定
├── home/                  # home-manager 設定
│   ├── default.nix        # 環境変数, PATH
│   ├── packages.nix       # ユーザーパッケージ
│   ├── shell.nix          # Zsh 設定
│   ├── git.nix            # Git 設定
│   └── programs/          # 個別プログラム設定
│       ├── neovim.nix
│       ├── starship.nix
│       └── fzf.nix
├── scripts/
│   └── install.sh         # 初期セットアップ
└── Makefile               # 便利コマンド集
```

## セットアップ手順

### 前提条件

- macOS (Apple Silicon)
- Nix がインストール済み（[Determinate Nix Installer](https://determinate.systems/nix-installer/) を推奨）

### 初回セットアップ

```bash
# 1. リポジトリをクローン（ghq を使用）
ghq get ktc-kkihara/nix-config
cd $(ghq root)/github.com/ktc-kkihara/nix-config

# 2. インストールスクリプトを実行
chmod +x scripts/install.sh
./scripts/install.sh

# 3. ターミナルを再起動
```

### 手動セットアップ（詳細を理解したい場合）

```bash
# 1. 設定をチェック
nix flake check

# 2. ビルド（適用せず確認のみ）
nix build .#darwinConfigurations.P-LMD0551.system

# 3. 適用
darwin-rebuild switch --flake .#P-LMD0551

# 4. Rust のセットアップ（初回のみ）
rustup default stable
```

## 日常的な使い方

### 基本コマンド

```bash
# 設定変更後に適用
make rebuild
# または
rebuild  # エイリアス

# 全てのパッケージを更新
make update && make rebuild

# 特定のパッケージだけ更新
make update-input INPUT=nixpkgs && make rebuild

# 不要なパッケージを削除（ガベージコレクション）
make gc

# 前の状態に戻す
make rollback
```

### よく使うエイリアス

```bash
# プロジェクトに移動（ghq + fzf）
cdp            # または Ctrl+G

# Git 操作
lg             # lazygit
gs             # git status
gl             # git log --oneline --graph

# Docker 操作
ld             # lazydocker
dc             # docker compose

# Gradle (KINTO FACTORY)
gw             # ./gradlew
gwb            # ./gradlew bootRun
```

### パッケージの検索

```bash
# nixpkgs でパッケージを検索
make search PKG=nodejs
nix search nixpkgs nodejs

# Homebrew でパッケージを検索
brew search dbeaver
```

## 設定のカスタマイズ

### パッケージを追加する

1. **Nix パッケージ（CLI ツール）を追加**

`home/packages.nix` を編集:

```nix
home.packages = with pkgs; [
  # 既存のパッケージ...

  # 新しいパッケージを追加
  htop
  tmux
];
```

2. **Homebrew パッケージ（GUI アプリ）を追加**

`darwin/homebrew.nix` を編集:

```nix
homebrew = {
  casks = [
    # 既存のcasks...

    # 新しいアプリを追加
    "slack"
    "zoom"
  ];
};
```

3. **適用**

```bash
make rebuild
```

### シェルエイリアスを追加する

`home/shell.nix` を編集:

```nix
shellAliases = {
  # 既存のエイリアス...

  # 新しいエイリアスを追加
  myalias = "some-command --with-flags";
};
```

### Git の設定を変更する

`home/git.nix` を編集:

```nix
programs.git = {
  userName = "Your Name";
  userEmail = "your.email@example.com";

  aliases = {
    # カスタムエイリアス
    mycommand = "...";
  };
};
```

### macOS の設定を変更する

`darwin/system.nix` を編集:

```nix
system.defaults = {
  dock = {
    autohide = true;
    orientation = "left";  # Dock を左に配置
  };
};
```

## トラブルシューティング

### "command not found: darwin-rebuild"

Nix のパスが通っていません。

```bash
# シェルを再起動
exec $SHELL

# または手動でパスを追加
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Homebrew のインストールに失敗する

```bash
# Homebrew を手動でインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 再度 rebuild
make rebuild
```

### ビルドエラーが発生する

```bash
# デバッグ情報付きでビルド
make rebuild-debug

# flake.lock をリセット
rm flake.lock
nix flake update
make rebuild
```

### "hash mismatch" エラー

キャッシュが古い可能性があります。

```bash
# キャッシュをクリア
nix store gc
make rebuild
```

### 以前の状態に戻したい

```bash
# 利用可能な世代を確認
make history

# 前の世代にロールバック
make rollback
```

## FAQ

### Q: mise や Homebrew をアンインストールしてもいい？

**A:** Nix での環境が安定したことを確認してからアンインストールすることを推奨します。

```bash
# mise のアンインストール
mise implode

# Homebrew のアンインストール（注意: GUI アプリは残す）
# Homebrew は nix-darwin で管理されるので、
# 手動でアンインストールする必要はありません
```

### Q: プロジェクトごとに異なるNode.jsバージョンを使いたい

**A:** プロジェクトに `flake.nix` を作成し、`direnv` で自動切り替えできます。

```bash
# プロジェクトディレクトリで
cd your-project

# flake.nix を作成
cat > flake.nix << 'EOF'
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { nixpkgs, ... }: {
    devShells.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
      packages = [ nixpkgs.legacyPackages.aarch64-darwin.nodejs_18 ];
    };
  };
}
EOF

# .envrc を作成
echo "use flake" > .envrc
direnv allow
```

### Q: Nix のディスク使用量が大きい

**A:** 定期的にガベージコレクションを実行してください。

```bash
# 古い世代を削除
make gc-old

# より積極的なクリーンアップ
nix-collect-garbage -d
```

### Q: 設定を別のMacに移行したい

**A:** このリポジトリをクローンしてセットアップスクリプトを実行するだけです。

```bash
# 新しい Mac で
ghq get ktc-kkihara/nix-config
cd $(ghq root)/github.com/ktc-kkihara/nix-config

# ホスト名が異なる場合は flake.nix を編集
# hostname = "NEW-HOSTNAME";

./scripts/install.sh
```

### Q: 特定のパッケージだけ更新したい

**A:** `nix flake lock` で特定の input を更新できます。

```bash
# nixpkgs だけ更新
make update-input INPUT=nixpkgs
make rebuild
```

## インストールされるツール

### Nix から（CLI ツール）

| パッケージ | 説明 |
|-----------|------|
| awscli2, aws-sam-cli | AWS CLI |
| go | Go 言語 |
| nodejs_20 | Node.js LTS |
| rustup | Rust ツールチェーン |
| terraform | インフラ管理 |
| grpcurl | gRPC クライアント |
| jq, yq-go | JSON/YAML プロセッサ |
| lazydocker, lazygit | TUI ツール |
| ripgrep, fd, fzf | 検索ツール |
| gh, ghq | GitHub CLI |
| neovim | エディタ |
| bat, eza, zoxide | モダンなコマンド |

### Homebrew から（GUI アプリ & 互換性のため）

| パッケージ | 理由 |
|-----------|------|
| dbeaver-community | GUI データベースクライアント |
| wezterm | ターミナルエミュレータ |
| docker | Docker Desktop |
| corretto@17 | Java (nixpkgs でビルド問題) |
| mysql-client | factory-tools 互換性 |

## ライセンス

MIT
