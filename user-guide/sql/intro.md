# はじめに

Polars は SQL との連携をサポートしていますが、より読みやすく表現力のあるコードを書くためには、
[エクスプレッション構文](../concepts/expressions.md) に慣れることをお勧めします。
DataFrame インターフェースが Polars の主要機能であるため、新機能は通常まずエクスプレッション API に追加されます。
しかし、既存の SQL コードベースを持っているユーザーや SQL の使用を好むユーザー向けに、Polars は SQL をサポートしています。

!!! note Execution

    Polars には固有の SQL エンジンはありません。なぜなら Polars は SQL クエリを [エクスプレッション](../concepts/expressions.md) に変換し、独自のエンジンを使って実行するためです。このアプローチにより、純粋な DataFrame ライブラリとしての Polars のパフォーマンスとスケーラビリティの利点を維持しつつ、SQL を使用する機能を提供しています。

## コンテキスト

Polars は SQL クエリを管理するために `SQLContext` オブジェクトを使用します。このコンテキストには、`DataFrame` と `LazyFrame` 
の識別子名とそれに対応するデータセット [^1] のマッピングが含まれます。以下の例では `SQLContext` を開始しています：

{{code_block('user-guide/sql/intro','context',['SQLContext'])}}

```python exec="on" session="user-guide/sql"
--8<-- "python/user-guide/sql/intro.py:setup"
--8<-- "python/user-guide/sql/intro.py:context"
```

## DataFrameの登録

`SQLContext` の初期化時に DataFrame を登録する方法はいくつかあります。

- グローバル名前空間内のすべての `LazyFrame` および `DataFrame` オブジェクトを登録する方法
- 辞書マッピングまたは kwargs を使って明示的に登録する方法

{{code_block('user-guide/sql/intro','register_context',['SQLContext'])}}

```python exec="on" session="user-guide/sql"
--8<-- "python/user-guide/sql/intro.py:register_context"
```

Pandas DataFrame も、Polars に変換することで登録できます。

{{code_block('user-guide/sql/intro','register_pandas',['SQLContext'])}}

```python exec="on" session="user-guide/sql"
--8<-- "python/user-guide/sql/intro.py:register_pandas"
```

!!! note Pandas

    Numpy をバックエンドとして使用している Pandas DataFrame を変換すると、変換のコストが高くなる可能性があります。しかし、Arrow をバックエンドとして使用している場合、変換のコストを大幅に抑えることができます (場合によってはほぼゼロに近くなります)。

`SQLContext` が初期化されたら、以下の方法で追加の DataFrame を登録したり、既存の DataFrame を登録解除できます：

- `register`
- `register_globals`
- `register_many`
- `unregister`

## クエリの実行と結果の収集

SQL クエリは、クエリ計画の最適化を最大限に活用するために、常に遅延モードで実行されます。
そのため、結果を収集するには2つの方法があります：

- `SQLContext` の `eager_execution` パラメーターを True に設定してください。これにより Polars は `execute` 呼び出しから LazyFrame の結果を自動的に収集するようになります。
- `execute` でクエリを実行する際に `eager` パラメーターを True に設定するか、`collect` を使用して明示的に結果を収集してください。

SQL クエリは `SQLContext` の `execute` を呼び出して実行します。

{{code_block('user-guide/sql/intro','execute',['SQLregister','SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql"
--8<-- "python/user-guide/sql/intro.py:execute"
```

## 複数のソースからのクエリ実行

同様に、複数のソースから SQL クエリを実行することも簡単にできます。
以下の例では、次のものを登録しています：

- CSV ファイル (遅延読み込み)
- NDJSON ファイル (遅延読み込み)
- Pandas DataFrame

そして SQL を使って、これらを結合します。
遅延読み込みを使用すると、ファイルから必要な行と列のみを読み込むことができます。

同様に、クラウドのデータレイク（S3, Azure Data Lake）を登録することもできます。
PyArrow データセットがデータレイクを指すようにし、`scan_pyarrow_dataset` を使って Polars で読み込むことができます。

{{code_block('user-guide/sql/intro','execute_multiple_sources',['SQLregister','SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql"
--8<-- "python/user-guide/sql/intro.py:prepare_multiple_sources"
--8<-- "python/user-guide/sql/intro.py:execute_multiple_sources"
--8<-- "python/user-guide/sql/intro.py:clean_multiple_sources"
```

[^1]: 加えて、[共通テーブルエクスプレッション](./cte.md) も管理します。

## 互換性

Polars は SQL 仕様全体をサポートしているわけではありませんが、最も一般的なステートメントタイプのサブセットをサポートしています。

!!! note Dialect

    可能な限り、Polars は PostgreSQL の構文定義と関数の動作に従うことを目指しています。

例えば、サポートされている機能の一部は以下の通りです：

- `CREATE` ステートメント： `CREATE TABLE xxx AS ...`
- `SELECT` ステートメント： `WHERE`、`ORDER`、`LIMIT`、`GROUP BY`、`UNION`、 `JOIN` 句など
- 共通テーブル式 (CTE) ： `WITH tablename AS` など
- クエリを説明する： `EXPLAIN SELECT ...`
- 登録済みのテーブルを一覧表示する： `SHOW TABLES`
- テーブルを削除する： `DROP TABLE tablename`
- テーブルを空にする： `TRUNCATE TABLE tablename`

以下は、まだサポートされていない機能の一部です：

- `INSERT`、`UPDATE`、`DELETE` ステートメント
- `ANALYZE` などのメタクエリ

今後のセクションでは、各ステートメントについてより詳しく説明します。
