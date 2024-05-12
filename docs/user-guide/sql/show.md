# テーブルの表示（SHOW TABLES）

Polars では、 `SHOW TABLES` 句を使用して、現在の `SQLContext` に登録されているすべてのテーブルを一覧表示することができます。 DataFrame を `SQLContext` に登録する時に、その DataFrame を参照するための名前を指定します。 `SHOW TABLES` 句を使うと、登録されているすべてのテーブルの名前を確認することができます。

Polars における `SHOW TABLES` 句の構文は以下の通りです：

```
SHOW TABLES
```

Polars での `SHOW TABLES` 句の使用例は以下の通りです：

{{code_block('user-guide/sql/show','show',['SQLregister','SQLexecute'])}}

```python exec="on" result="text" session="user-guide/sql/show"
--8<-- "python/user-guide/sql/show.py:setup"
--8<-- "python/user-guide/sql/show.py:show"
```

この例では、2 つの DataFrame を作成し、異なる名前で `SQLContext` に登録しています。その後、`SQLContext` オブジェクトの `execute()` メソッドを使って `SHOW TABLES` 句を実行し、登録されているすべてのテーブルの一覧を取得しています。取得した DataFrame は `print()` 関数で出力されます。

`SHOW TABLES` 句は、現在の `SQLContext` に登録されているテーブルのみを一覧表示します。別の `SQLContext` や別の Python セッションで DataFrame を登録した場合、`SHOW TABLES` の結果には表示されません。
