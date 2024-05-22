# 使用方法

Lazy API を使うと、Polars は各クエリを行ごとに実行するのではなく、クエリ全体をエンドツーエンドで処理します。Polars を最大限に活用するには、以下の理由から Lazy API を使うことが重要です：

- Polars がクエリオプティマイザーを利用し、自動クエリ最適化ができます。
- ストリーミング機能を使ってメモリ以上のサイズのデータセットを扱えます。
- データ処理の前にスキーマエラーを検出できます。

ここでは、ファイルまたは既存の `DataFrame` から Lazy API を使う方法を見ていきます。

## ファイルから Lazy APIを使う

クエリオプティマイザーがファイルから読み込むデータ量を削減できるため、理想的にはファイルから Lazy API を使うのが良いでしょう。

Reddit の CSV データから Lazy クエリを作成し、いくつかの変換を適用します。

`pl.scan_csv` からクエリを始めることで、Lazy API を使います。

{{code_block('user-guide/lazy/using','dataframe',['scan_csv','with_columns','filter','col'])}}

`pl.scan_` 関数は、CSV、IPC、Parquet、JSON などの様々なファイル形式に対応しています。

このクエリでは、Polars に以下を指定しています:

- Reddit の CSV ファイルからデータを読み込みます
- `name` 列を大文字に変換します
- `comment_karma` 列にフィルターを適用します

この Lazy クエリはこの時点では実行されません。Lazy クエリの実行については [Lazy クエリの実行](execution.md) のページを参照してください。

## `DataFrame` から Lazy APIを使う

Lazy API にアクセスする別の方法は、メモリ上に作成済みの `DataFrame` に対して `.lazy` を呼び出すことです。

{{code_block('user-guide/lazy/using','fromdf',['lazy'])}}

`.lazy` を呼び出すことで、`DataFrame` を `LazyFrame` に変換します。