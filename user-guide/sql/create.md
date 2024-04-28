# CREATE

Polars では、`SQLContext` を使用して、SQL 構文で `LazyFrames` と `DataFrames` に対して SQL 文を実行することができます。その `SQLContext` を使用して実行できる SQL 文の 1 つに `CREATE TABLE` 文があり、これは新しいテーブルを作成するために使用します。

Polars での `CREATE TABLE` 文の構文は次のとおりです:

```
CREATE TABLE table_name
AS
SELECT ...
```

この構文では、`table_name` は新たに作成されるテーブルの名前であり、`SELECT ...` はテーブルに挿入されるデータを定義する SELECT 文です。

Polars での `CREATE TABLE` 文の使用例を次に示します:

[register](https://docs.pola.rs/py-polars/html/reference/api/polars.SQLContext.register.html#polars.SQLContext.register), [execute](https://docs.pola.rs/py-polars/html/reference/api/polars.SQLContext.execute.html)

```python
data = {"name": ["Alice", "Bob", "Charlie", "David"], "age": [25, 30, 35, 40]}
df = pl.LazyFrame(data)

ctx = pl.SQLContext(my_table=df, eager_execution=True)

result = ctx.execute(
    """
    CREATE TABLE older_people
    AS
    SELECT * FROM my_table WHERE age > 30
"""
)

print(ctx.execute("SELECT * FROM older_people"))
```

```
shape: (2, 2)
┌─────────┬─────┐
│ name    ┆ age │
│ ---     ┆ --- │
│ str     ┆ i64 │
╞═════════╪═════╡
│ Charlie ┆ 35  │
│ David   ┆ 40  │
└─────────┴─────┘
```

この例では、`SQLContext` の `execute()` メソッドを使用して `CREATE TABLE` 文を実行し、`my_table DataFrame` から `age` 列が 30 より大きいすべての行を選択する SELECT 文に基づいて `older_people` という新しいテーブルを作成します。

> [!NOTE]
> 
> `CREATE TABLE` 文の結果はテーブルそのものではないことに注意してください。テーブルは `SQLContext` に登録されます。テーブルを `DataFrame` に戻したい場合は、`SELECT * FROM ...` 文を使用できます。
