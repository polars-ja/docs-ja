# ピボット

`DataFrame` の列をピボットし、以下のいずれかの集計を実行します:

- first
- sum
- min
- max
- mean
- median

ピボット操作は、1つまたは複数の列によるグループ化（これらが新しい y 軸になります）、ピボットされる列（これが新しい x 軸になります）、および集計から成ります。

## データセット

{{code_block('user-guide/transformations/pivot','df',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/pivot"
--8<-- "python/user-guide/transformations/pivot.py:setup"
--8<-- "python/user-guide/transformations/pivot.py:df"
```

## Eager

{{code_block('user-guide/transformations/pivot','eager',['pivot'])}}

```python exec="on" result="text" session="user-guide/transformations/pivot"
--8<-- "python/user-guide/transformations/pivot.py:eager"
```

## Lazy

Polars の `LazyFrame` は、常に計算のスキーマを静的に（クエリを収集する前に）知る必要があります。
ピボットの出力スキーマはデータに依存するため、クエリを実行せずにスキーマを決定することはできません。

Polars は Spark のようにこの事実を抽象化することができましたが、ユーザーが自分の足を撃つことのないようにしたいと思っています。コストは明確に示されるべきです。

{{code_block('user-guide/transformations/pivot','lazy',['pivot'])}}

```python exec="on" result="text" session="user-guide/transformations/pivot"
--8<-- "python/user-guide/transformations/pivot.py:lazy"
```
