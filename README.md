# Polars Docs ja
Polars 公式ドキュメントの日本語翻訳リポジトリです。本リポジトリで、現状以下のドキュメントの翻訳作業を管理しています。
- [Polars User guide](https://docs.pola.rs/)

## ドキュメントのデプロイ先
[こちら](https://polars-ja.github.io/docs-ja/) にデプロイされます（CI/CD 準備中）

## 翻訳の標準スタイル
- [JTF日本語標準スタイルガイド（翻訳用）](https://www.jtf.jp/tips/styleguide) - 基本的な翻訳スタイルはこれに従う。

## 表記
翻訳に伴い、迷いそうな表記があればその都度確認・追加すること。
変更の提案は Discord で常に受付けます。

### 単語

| 原文 | 日本語 | 例 |
| ---  | --- | --- |
| lazy API | lazy API | |
| eager API | eager API | |
| Context | 式 | |
| Expression | エクスプレッション | |
| DataFrame | DataFrame | |
| column |カラム  | |
| Lazy reading | 遅延読み込み | |
| True | True（「真」にしない）| Set True → True を設定する |
| () | （）（全角） | |
| : | ：（全角） | 

### 文体
* 表記は「です」「ます」で統一する。
  * 箇条書きで「です」「ます」調ではない方が自然な場合も、JTF日本語標準スタイルガイド（翻訳用）に従い「です」「ます」に統一する。
* 原文に使われる `:` `!` `?` などの記号は残す。
  > 原文：Examples are shown below:  
  > OK：以下に例を示します：  
  > NG：以下に例を示します。  
* SQLの表記は PostgreSQL の日本語ドキュメントに従う。（https://www.postgresql.jp/document/15/html/sql-commands.html)
  > 例：truncate a table → 「テーブルを空にする」

## コントリビュートの方法
準備中

### ローカルでの動作確認方法

#### 前提
以下がローカルにインストール済みであること
- python
- rust
- cmake
- graphviz

#### ビルド
```
make build
```

#### 仮想環境の activate
```
source .venv/bin/activate
```

#### mkdocs サーバーの起動
```
mkdocs serve
```

#### ブラウザからのアクセス
ブラウザから `http://127.0.0.1:8000/` にアクセス


### Dockerでの動作確認方法

```bash
docker build -t mkdocs-image . # 300s程かかります
docker run -p 8000:8000 -v "$(pwd)/docs":/app/docs -it mkdocs-image
# access http://127.0.0.1:8000
```
