# cursor-common-rules Makefile

.PHONY: help install update-rules validate clean

# デフォルトターゲット
help:
	@echo "Cursor共通ルール管理 - 利用可能なコマンド:"
	@echo "  make install        - 初期セットアップ"
	@echo "  make update-rules   - ルールファイルを更新"
	@echo "  make validate       - ルールファイルの妥当性チェック"
	@echo "  make clean          - 一時ファイルを削除"

# 初期セットアップ
install:
	@echo "共通ルールリポジトリの初期セットアップ中..."
	@mkdir -p .cursor/rules
	@if [ ! -f .cursor/rules/base.md ]; then \
		echo "基本ルールファイルを作成中..."; \
		echo "# Cursor基本ルール\n\n## 基本設定\n- ここに共通ルールを記述してください" > .cursor/rules/base.md; \
	fi
	@echo "✅ セットアップ完了"

# ルールファイルの更新
update-rules:
	@echo "ルールファイルを更新中..."
	@git add .cursor/rules/
	@git status --porcelain .cursor/rules/ | grep -q . && \
		(git commit -m "Update cursor rules" && echo "✅ ルールファイルを更新しました") || \
		echo "📝 変更がありません"

# ルールファイルの妥当性チェック
validate:
	@echo "ルールファイルの妥当性をチェック中..."
	@for file in .cursor/rules/*.md; do \
		if [ -f "$$file" ]; then \
			echo "チェック中: $$file"; \
			if [ ! -s "$$file" ]; then \
				echo "❌ エラー: $$file が空です"; \
				exit 1; \
			fi; \
		fi; \
	done
	@echo "✅ 全てのルールファイルは有効です"

# 一時ファイルの削除
clean:
	@echo "一時ファイルを削除中..."
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@echo "✅ クリーンアップ完了"

# バージョン管理用のタグ作成
tag:
	@read -p "バージョンタグを入力してください (例: v1.0.0): " version; \
	git tag -a $$version -m "Release $$version"; \
	git push origin $$version; \
	echo "✅ タグ $$version を作成しました"
