# スキーマ

Polars の `DataFrame` または `LazyFrame` のスキーマは、列の名前とデータ型を定義します。 `DataFrame` または `LazyFrame` の `.schema` メソッドを使ってスキーマを確認できます。

{{code_block('user-guide/lazy/schema','schema',['DataFrame','lazy'])}}

```python exec="on" result="text" session="user-guide/lazy/schemas"
--8<-- "python/user-guide/lazy/schema.py:setup"
--8<-- "python/user-guide/lazy/schema.py:schema"
```

スキーマは、Lazy API で重要な役割を果たします。

## Lazy API でのタイプチェック

Lazy API の利点の 1 つは、Polars がデータを処理する前にスキーマをチェックすることです。このチェックは、Lazy クエリを実行するときに行われます。

整数の `bar` 列に `.round` 式を呼び出す以下の簡単な例で、この仕組みがわかります。

{{code_block('user-guide/lazy/schema','lazyround',['lazy','with_columns'])}}

`.round` 式は、浮動小数点型の列でのみ有効です。整数列に `.round` を呼び出すと、`collect` でクエリを評価したときに `InvalidOperationError` が発生します。このスキーマチェックは、データを処理する前の `collect` の呼び出し時に行われます。

{{code_block('user-guide/lazy/schema','typecheck',[])}}

```python exec="on" result="text" session="user-guide/lazy/schemas"
--8<-- "python/user-guide/lazy/schema.py:lazyround"
--8<-- "python/user-guide/lazy/schema.py:typecheck"
```

このクエリをイーガーモードで実行すると、エラーは最初のステップでデータが処理された後にのみ見つかります。

Lazy クエリを実行すると、Polars は時間のかかるデータ処理の前に、潜在的な `InvalidOperationError` をチェックします。

## Lazy API にはスキーマが必要

Lazy API では、Polars のクエリオプティマイザがクエリプランのあらゆるステップでスキーマを推測できる必要があります。これは、事前にスキーマが分からない操作は Lazy API で使えないことを意味します。

事前にスキーマが分からない操作の典型例は `.pivot` 操作です。`.pivot` では、新しい列名がある列のデータから決まります。これらの列名は事前に分からないため、`.pivot` は Lazy API では使えません。

## Lazy API で使えない操作への対処

パイプラインに Lazy API で使えない操作が含まれる場合は、通常以下のようにするのが最善です:

- その操作までは Lazy モードで実行
- `.collect` でパイプラインを実行し、`DataFrame` を具体化
- `DataFrame` で非 Lazy の操作を実行
- 出力を再び `LazyFrame` に変換 (`lazy`) し、Lazy モードで続行
- `.filter` などの操作を行う
- 最後に `.collect` でクエリを実行し、`DataFrame` を取得

以下の例では、この手順を示しています:

- 簡単な `DataFrame` を作成
- `.lazy` で `LazyFrame` に変換
- `.with_columns` で変換
- `.collect` でクエリを実行し `DataFrame` を取得
- `DataFrame` で `.pivot` を実行
- 再び `LazyFrame` に変換 (`lazy`)
- `.filter` を実行
- 最後に `.collect` でクエリを実行し `DataFrame` を取得

{{code_block('user-guide/lazy/schema','lazyeager',['collect','pivot','filter'])}}

```python exec="on" result="text" session="user-guide/lazy/schemas"
--8<-- "python/user-guide/lazy/schema.py:lazyeager"
```
