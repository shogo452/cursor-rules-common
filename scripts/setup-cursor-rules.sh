bash#!/bin/bash

# Cursor Rules Setup Script for macOS/Linux
# このスクリプトはプロジェクトルートで実行してください

set -e

SUBMODULE_NAME="cursor-rules-common"
SUBMODULE_URL="https://github.com/shogo452/cursor-rules-common.git"
RULES_SOURCE_PATH="$SUBMODULE_NAME/.cursor/rules"
RULES_TARGET_PATH=".cursor/rules"

echo "🚀 Cursor Rules セットアップを開始します..."

# 1. submoduleの追加/更新
if [ -d "$SUBMODULE_NAME" ]; then
    echo "📦 既存のsubmoduleを更新中..."
    git submodule update --init --recursive
    git submodule update --remote "$SUBMODULE_NAME"
else
    echo "📦 submoduleを追加中..."
    git submodule add "$SUBMODULE_URL" "$SUBMODULE_NAME"
    git submodule update --init --recursive
fi

# 2. .cursorディレクトリの作成
echo "📁 .cursorディレクトリを作成中..."
mkdir -p .cursor
mkdir -p .cursor/local-rules

# 3. 既存のrulesディレクトリ/リンクを削除
if [ -e "$RULES_TARGET_PATH" ]; then
    echo "🧹 既存のrulesを削除中..."
    rm -rf "$RULES_TARGET_PATH"
fi

# 4. シンボリックリンクの作成
echo "🔗 シンボリックリンクを作成中..."
if [ -d "$RULES_SOURCE_PATH" ]; then
    ln -sf "../$RULES_SOURCE_PATH" "$RULES_TARGET_PATH"
    echo "✅ シンボリックリンクを作成しました: $RULES_TARGET_PATH -> ../$RULES_SOURCE_PATH"
else
    echo "❌ エラー: $RULES_SOURCE_PATH が見つかりません"
    exit 1
fi

# 5. プロジェクト固有のルールファイルを作成
PROJECT_RULES_FILE=".cursor/local-rules/project-specific.md"
if [ ! -f "$PROJECT_RULES_FILE" ]; then
    echo "📝 プロジェクト固有のルールファイルを作成中..."
    cat > "$PROJECT_RULES_FILE" << 'EOF'
# プロジェクト固有ルール

## このプロジェクトの特別な要件

### 命名規則
- プロジェクト独自の命名規則があれば記載

### 特別な設定
- プロジェクト固有の設定やツールの使用方法

### 禁止事項
- このプロジェクトで使用を避けるべきパターン

### 参考リンク
- プロジェクトのドキュメント
- 設計ガイドライン
EOF
    echo "✅ プロジェクト固有のルールファイルを作成しました: $PROJECT_RULES_FILE"
fi

# 6. 動作確認
echo "🔍 セットアップの確認中..."
if [ -L "$RULES_TARGET_PATH" ] && [ -d "$RULES_TARGET_PATH" ]; then
    echo "✅ シンボリックリンクが正常に動作しています"
    echo "📋 利用可能なルールファイル:"
    ls -la "$RULES_TARGET_PATH"
else
    echo "❌ シンボリックリンクに問題があります"
    exit 1
fi

# 7. Gitへの追加
echo "📝 Gitに変更を追加中..."
git add .cursor/
git add "$SUBMODULE_NAME"

echo ""
echo "🎉 セットアップ完了！"
echo ""
echo "次のステップ:"
echo "1. 変更をコミット: git commit -m 'Add cursor rules setup'"
echo "2. Cursorエディターで .cursor/rules 内のファイルを確認"
echo "3. 必要に応じて .cursor/local-rules/project-specific.md を編集"
echo ""
