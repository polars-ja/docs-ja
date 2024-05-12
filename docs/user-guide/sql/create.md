# CREATE

Polars では、`SQLContext` を使用して、SQL 構文で `LazyFrames` と `DataFrames` に対して SQL 文を実行することができます。その `SQLContext` を使用して実行できる SQL 文の 1 つに `CREATE TABLE` 文があり、新しいテーブルを作成するために使用します。

Polars での `CREATE TABLE` 文の構文は次のとおりです：

```
CREATE TABLE table_name
AS
SELECT ...
```

この構文では、`table_name` は新たに作成されるテーブルの名前であり、`SELECT ...` はテーブルに挿入されるデータを定義する SELECT 文です。

Polars での `CREATE TABLE` 文の使用例を次に示します：

{{code_block('user-guide/sql/create','create',['SQLregister','SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql"
--8<-- "python/user-guide/sql/create.py:setup"
--8<-- "python/user-guide/sql/create.py:create"
```

この例では、`SQLContext` の `execute()` メソッドを使用して `CREATE TABLE` 文を実行し、`my_table DataFrame` から `age` 列が 30 より大きいすべての行を選択する SELECT 文に基づいて `older_people` という新しいテーブルを作成します。

!!! note Result

    `CREATE TABLE` 文の結果はテーブルそのものではないことに注意してください。テーブルは `SQLContext` に登録されます。テーブルを `DataFrame` に戻したい場合は、`SELECT * FROM ...` 文を使用できます。
