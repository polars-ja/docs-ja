# SELECT

Polars SQL では、`SELECT` 句を使用して、テーブルからデータを `DataFrame` に取り出します。Polars SQL の `SELECT` 句の基本的な構文は次のとおりです：

```sql
SELECT column1, column2, ...
FROM table_name;
```

ここで `column1`、`column2` などは、テーブルから選択したい列を指します。ワイルドカード `*` を使って、すべての列を選択することもできます。`table_name` は、データを取り出したいテーブルの名前です。以下のセクションでは、より一般的な SELECT のバリエーションについて説明します。

{{code_block('user-guide/sql/select','df',['SQLregister','SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql/select"
--8<-- "python/user-guide/sql/select.py:setup"
--8<-- "python/user-guide/sql/select.py:df"
```

### GROUP BY（グループ化）

`GROUP BY` 句は、テーブル内の行を 1 つ以上の列でグループ化し、各グループに対して集計関数を計算するために使用されます。

{{code_block('user-guide/sql/select','group_by',['SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql/select"
--8<-- "python/user-guide/sql/select.py:group_by"
```

### ORDER BY（並べ替え）

`ORDER BY` 句は、クエリの結果セットを 1 つ以上の列で昇順または降順に並べ替えるために使用されます。

{{code_block('user-guide/sql/select','orderby',['SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql/select"
--8<-- "python/user-guide/sql/select.py:orderby"
```

### JOIN（結合）

{{code_block('user-guide/sql/select','join',['SQLregister_many','SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql/select"
--8<-- "python/user-guide/sql/select.py:join"
```

### 関数

Polars には、次のような幅広い SQL 関数が用意されています：

- 数学関数： `ABS`、`EXP`、`LOG`、`ASIN`、`ACOS`、`ATAN` など
- 文字列関数： `LOWER`、`UPPER`、`LTRIM`、`RTRIM`、`STARTS_WITH`、`ENDS_WITH`
- 集計関数： `SUM`、`AVG`、`MIN`、`MAX`、`COUNT`、`STDDEV`、`FIRST` など
- 配列関数： `EXPLODE`、`UNNEST`、`ARRAY_SUM`、`ARRAY_REVERSE` など

サポートされている関数の完全なリストは、[API ドキュメンテーション](https://docs.rs/polars-sql/latest/src/polars_sql/keywords.rs.html) を参照してください。以下の例では、クエリ内で関数を使用する方法を示しています。

{{code_block('user-guide/sql/select','functions',['SQLquery'])}}

```python exec="on" result="text" session="user-guide/sql/select"
--8<-- "python/user-guide/sql/select.py:functions"
```

### テーブル関数

先ほどの例では、最初に DataFrame を生成し、`SQLContext` に登録しました。Polars では、SQL クエリ内で `read_xxx` テーブル関数を使って、CSV、Parquet、JSON、IPC から直接読み取ることもできます。

{{code_block('user-guide/sql/select','tablefunctions',['SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql/select"
--8<-- "python/user-guide/sql/select.py:tablefunctions"
```
