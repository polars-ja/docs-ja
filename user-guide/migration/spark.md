# Apache Spark からの移行

## カラムベースの API と行ベースの API

`Spark` の `DataFrame` は行の集合に相当するのに対し、Polars の `DataFrame` はカラムの集合に近いです。これは、`Spark` が各行のデータの関連性を保持するのに対し、Polars では `Spark` では不可能な方法で列を組み合わせることができることを意味します。

以下にサンプルデータセットを示します：

```python
import polars as pl

df = pl.DataFrame({
    "foo": ["a", "b", "c", "d", "d"],
    "bar": [1, 2, 3, 4, 5],
})

dfs = spark.createDataFrame(
    [
        ("a", 1),
        ("b", 2),
        ("c", 3),
        ("d", 4),
        ("d", 5),
    ],
    schema=["foo", "bar"],
)
```

### 例1： `head` と `sum` を組み合わせる

Polars では次のように記述できます：

```python
df.select(
    pl.col("foo").sort().head(2),
    pl.col("bar").filter(pl.col("foo") == "d").sum()
)
```

Output:

```
shape: (2, 2)
┌─────┬─────┐
│ foo ┆ bar │
│ --- ┆ --- │
│ str ┆ i64 │
╞═════╪═════╡
│ a   ┆ 9   │
├╌╌╌╌╌┼╌╌╌╌╌┤
│ b   ┆ 9   │
└─────┴─────┘
```

カラム `foo` と `bar` に対する式は完全に独立しています。`bar` に対するエクスプレッションが単一の値を返すため、その値は `foo` に対するエクスプレッションによって出力される各値に対して繰り返されます。しかし、`a` と `b` は `9` の合計を生成したデータとは関連がありません。

`Spark` で同様のことを行うには、合計を別途計算し、リテラルとして提供する必要があります：

```python
from pyspark.sql.functions import col, sum, lit

bar_sum = (
    dfs
    .where(col("foo") == "d")
    .groupBy()
    .agg(sum(col("bar")))
    .take(1)[0][0]
)

(
    dfs
    .orderBy("foo")
    .limit(2)
    .withColumn("bar", lit(bar_sum))
    .show()
)
```

Output:

```
+---+---+
|foo|bar|
+---+---+
|  a|  9|
|  b|  9|
+---+---+
```

### 例2： 2つの `head` を組み合わせる

Polars では、同じ DataFrame に対して異なる `head` 式を組み合わせることができますが、それらが同じ数の値を返す場合に限ります。

```python
df.select(
    pl.col("foo").sort().head(2),
    pl.col("bar").sort(descending=True).head(2),
)
```

Output:

```
shape: (3, 2)
┌─────┬─────┐
│ foo ┆ bar │
│ --- ┆ --- │
│ str ┆ i64 │
╞═════╪═════╡
│ a   ┆ 5   │
├╌╌╌╌╌┼╌╌╌╌╌┤
│ b   ┆ 4   │
└─────┴─────┘
```

ここでも2つの `head` 式は完全に独立しており、`a` が `5` に、`b` が `4` に対応するのは、式によって出力された二つのカラムを並べることによって純粋に結果が得られます。

`Spark` で同様のことを実現するには、このように値を結合するために人工的なキーを生成する必要があります。

```python
from pyspark.sql import Window
from pyspark.sql.functions import row_number

foo_dfs = (
    dfs
    .withColumn(
        "rownum",
        row_number().over(Window.orderBy("foo"))
    )
)

bar_dfs = (
    dfs
    .withColumn(
        "rownum",
        row_number().over(Window.orderBy(col("bar").desc()))
    )
)

(
    foo_dfs.alias("foo")
    .join(bar_dfs.alias("bar"), on="rownum")
    .select("foo.foo", "bar.bar")
    .limit(2)
    .show()
)
```

Output:

```
+---+---+
|foo|bar|
+---+---+
|  a|  5|
|  b|  4|
+---+---+
```
