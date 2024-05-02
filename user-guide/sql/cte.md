# 共通テーブルエクスプレッション

共通テーブルエクスプレッション (Common Table Expressions、CTEs) は、SQL の機能の1つで、SQL ステートメント内で参照できる一時的な名前付き結果セットを定義することができます。CTE は複雑な SQL クエリを小さく、より管理しやすく分割することで、クエリの可読性、記述性、メンテナンス性を向上させることができます。

CTE は、 `WITH` キーワードを使って定義され、カンマ区切りのサブクエリのリストで構成されます。各サブクエリは、後続のクエリで使用できる名前付きの結果セットを定義します。CTE の構文は以下の通りです。

```
WITH cte_name AS (
    subquery
)
SELECT ...
```

上記の `cte_name` は CTE の名前、`subquery` は結果セットを定義するサブクエリです。CTE は、テーブルやビューのように後続のクエリで参照できます。

CTE は、複数レベルのサブクエリを含む複雑なクエリを扱う際に特に便利です。クエリを小さく、管理しやすく分割できるため、理解しやすく、デバッグしやすくなります。さらに、CTE を使うことで、サブクエリの結果をデータベースが最適化およびキャッシュできるため、クエリのパフォーマンス改善にも役立ちます。

Polars は SQL 構文の WITH 句を使って共通テーブルエクスプレッション (CTE) をサポートしています。以下に例を示します。

{{code_block('user-guide/sql/cte','cte',['SQLregister','SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql/cte"
--8<-- "python/user-guide/sql/cte.py:setup"
--8<-- "python/user-guide/sql/cte.py:cte"
```

この例では、`SQLContext` の `execute()` メソッドを使って、CTE を含む SQL クエリを実行しています。CTE は `my_table` LazyFrame から `age` が 30 より大きい行を選択し、`older_people` のエイリアスを付けています。その後、`older_people` CTE から `name` が 'C' で始まる行を選択するクエリを実行しています。
