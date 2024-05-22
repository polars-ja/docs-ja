# Pandas からの移行

ここでは、Pandas の経験がある人が Polars を試す際に知っておくべき
重要なポイントを説明します。Polars と Pandas それぞれのライブラリが
基礎としている概念の違いと、Pandas と比較した Polars のコードの書き方の違いを
説明します。

## Polars と Pandas の概念の違い

### Polars にはマルチインデックス/インデックスがない

Pandas は各行にインデックスでラベルが付与されます。Polars にはインデックスがなく、
各行はテーブルの中での整数位置によってインデックスされます。

Polars は予測可能な結果と読みやすいクエリを目指しており、インデックスはそれらの目的に役立たないと考えています。
クエリの意味は、インデックスの状態や `reset_index` の呼び出しによって変わるべきではないと信じています。

Polarsのデータフレームは常に2次元の異種データ型のテーブルです。データ型にはネストが存在する可能性がありますが、
テーブル自体にはネストはありません。
リサンプリングなどの操作は、明示的にどの列に対して行うかを示す専用の関数やメソッド（「動詞」のようなもの）で行います。
したがって、インデックスがないことで、より単純で明示的で読みやすく、
エラーが少なくなると確信しています。

ただし、データベースで知られている「インデックス」のデータ構造は、Polars の最適化技術として使用されます。

### Polars はメモリ上で Apache Arrow の配列を使用する一方、Pandas は NumPy 配列を使用する

Polars はメモリ上で Apache Arrow の配列を使用する一方で、
Pandas は NumPy 配列を使用します。Apache Arrow は、データ読み込み時間の短縮、
メモリ使用量の削減、計算の高速化などを実現する
新興の列指向メモリ分析標準です。

Polarsは `to_numpy` メソッドでデータを NumPy 形式に変換できます。

### Polars は Pandas よりも並列処理をサポートする

Polarsは Rust の並行性の強力なサポートを活用して、多くの操作を並列に実行できます。
Pandas にも一部の操作で並列処理があるものの、
ライブラリの中核部分は単一スレッドであり、並列処理のためには`Dask` などの
ライブラリを追加で使う必要があります。

### Polars は遅延評価クエリとクエリ最適化が可能

即時評価は、コードを実行するとすぐにコードが評価されます。
遅延評価は、行のコードを実行することで、基礎となるロジックがクエリ計画に追加され、
評価されないことを意味します。

Polars は即時評価と遅延評価をサポートしていますが、 pandas は即時評価のみを
サポートしています。遅延評価モードは強力で、Polars はクエリ計画を調べ、
クエリを高速化したり、メモリ使用量を削減する方法を見つけると、
自動クエリ最適化を行います。

`Dask` も、クエリ計画を生成する際に遅延評価をサポートしています。ただし、`Dask` は
クエリ計画に対してクエリ最適化を行いません。

## 主要な構文の違い

Pandas から移行してきたユーザーは一般に1つのことを知る必要があります...

```
polars != pandas
```

もしもあなたの Polars のコードが Pandas のコードのように見える場合、実行はできるかもしれませんが、
おそらく適切な速度で実行されることはないでしょう。

いくつかの典型的な Pandas コードを見て、それを Polars でどのように書き換えるか見ていきましょう。

### データの選択

Polars にはインデックスがないため、`.loc` や `iloc` メソッドが存在せず、
`SettingWithCopyWarning` も Polars には存在しません。

しかし、Polars でデータを選択する最良の方法は、expression API を使用することです。
たとえば、Pandas で列を選択したい場合、次のいずれかを行うことができます：

```python
df['a']
df.loc[:,'a']
```

しかし、Polars では `.select` メソッドを使用します：

```python
df.select('a')
```

値に基づいて行を選択したい場合は、
Polars で `.filter` メソッドを使用します：

```python
df.filter(pl.col('a') < 10)
```

下記の式に関するセクションで述べられているように、Polars は `.select` および
`filter` での操作を並列に実行することができ、データを選択する基準の全てのセットに対して
クエリ最適化を行うことができます。

### 遅延評価を利用する

遅延評価モードでの作業は単純であり、Polars では遅延モードが
クエリ最適化を可能にするため、デフォルトとすべきです。

遅延モードでの実行は、暗黙的に遅延関数（`scan_csv` など）を使用するか、
明示的に `lazy` メソッドを使用することで行えます。

次のシンプルな例を考えます。ディスクから CSV ファイルを読み込んでグループ化します。
CSV ファイルには数多くの列がありますが、私たちは `id1` の列でグループ化して、
値列（`v1`）で合計を出したいだけです。pandas では次のようになります：

```python
df = pd.read_csv(csv_file, usecols=['id1','v1'])
grouped_df = df.loc[:,['id1','v1']].groupby('id1').sum('v1')
```

Polars ではクエリを遅延モードで構築してクエリ最適化を行い、
即時的な Pandas 関数の `read_csv` を
暗黙的に遅延する Polars 関数の `scan_csv` に置き換えて評価できます：

```python
df = pl.scan_csv(csv_file)
grouped_df = df.group_by('id1').agg(pl.col('v1').sum()).collect()
```

Polars はこのクエリを `id1` および `v1` 列のみが関連していると特定し、
これらの列のみを CSV から読み込むよう最適化します。2行目の最後で `.collect`
メソッドを呼び出すことで、クエリをその時点で評価するよう Polars に指示します。

このクエリを即時モードで実行したい場合は、
Polars コードで `scan_csv` を `read_csv` に置き換えるだけです。

遅延評価の使用については、
[lazy API](../lazy/using.md) の章で詳しく読むことができます。

### エクスプレッションを使う

典型的な pandas スクリプトは、逐次的に実行される複数のデータ変換で構成されています。
しかし、Polars ではこれらの変換をエクスプレッションを使って
並列に実行することができます。

#### カラムの割り当て

`df` という DataFrame に `value` というカラムがあり、
`value` を10倍した `tenXValue` という新しいカラム、
および `value` 列を100倍した `hundredXValue` という新しいカラムを追加したいとします。

pandas では次のようになります：

```python
df.assign(
    tenXValue=lambda df_: df_.value * 10,
    hundredXValue=lambda df_: df_.value * 100
)
```

これらのカラムの割り当ては逐次的に実行されます。

Polars では `with_columns` メソッドを使ってカラムを追加します：

```python
df.with_columns(
    tenXValue=pl.col("value") * 10,
    hundredXValue=pl.col("value") * 100,
)
```

これらのカラムの割り当ては屁入れで実行されます。

#### 条件に基づくカラムの割り当て

次のケースでは、カラム `a`、`b`、`c` を持つ dataframe `df` があったとします。
条件に基づいてカラム `a` の値を割り当てしなおしたいと考えます。カラム `c` の値が 2 に等しい場合、
カラム `a` の値をカラム `b` の値に置き換えます。

pandas では次のようになります：

```python
df.assign(a=lambda df_: df_.a.where(df_.c != 2, df_.b))
```

一方で Polars では次のようになります：

```python
df.with_columns(
    pl.when(pl.col("c") == 2)
    .then(pl.col("b"))
    .otherwise(pl.col("a")).alias("a")
)
```

Polars は `if -> then -> otherwise` の各ブランチを並列に計算することができます。
これは、ブランチの計算が高コストになる場合に価値があります。

#### フィルタリング

いくつかの条件に基づいて住宅データを持つ Dataframe `df` をフィルタリングしたいとします。

pandas では `query` メソッドにブール式を渡して Dataframe をフィルタリングします：

```python
df.query("m2_living > 2500 and price < 300000")
```

またはマスクを直接評価します：

```python
df[(df["m2_living"] > 2500) & (df["price"] < 300000)]
```

一方で Polars は `filter` メソッドを呼びます：

```python
df.filter(
    (pl.col("m2_living") > 2500) & (pl.col("price") < 300000)
)
```

Polars のクエリ最適化エンジンは、複数のフィルターを別々に記述したことを検出し、
最適化された計画でそれらを1つのフィルターに組み合わせることができます。

## pandas の変換

pandas のドキュメントでは、`transform` と呼ばれるグループ化に対する操作が示されています。
この場合、DataFrame `df` があり、各グループの行数を示す
新しい列が必要です。

pandas では次のようになります：

```python
df = pd.DataFrame({
    "c": [1, 1, 1, 2, 2, 2, 2],
    "type": ["m", "n", "o", "m", "m", "n", "n"],
})

df["size"] = df.groupby("c")["type"].transform(len)
```

ここで pandas は `"c"` でグループ化を行い、`"type"` カラムを取り、グループの長さを計算し、
その結果を元の `DataFrame` に戻して以下を生成します：

```
   c type size
0  1    m    3
1  1    n    3
2  1    o    3
3  2    m    4
4  2    m    4
5  2    n    4
6  2    n    4
```

Polars では同じことを `window` 関数で実現できます。

```python
df.with_columns(
    pl.col("type").count().over("c").alias("size")
)
```

```
shape: (7, 3)
┌─────┬──────┬──────┐
│ c   ┆ type ┆ size │
│ --- ┆ ---  ┆ ---  │
│ i64 ┆ str  ┆ u32  │
╞═════╪══════╪══════╡
│ 1   ┆ m    ┆ 3    │
│ 1   ┆ n    ┆ 3    │
│ 1   ┆ o    ┆ 3    │
│ 2   ┆ m    ┆ 4    │
│ 2   ┆ m    ┆ 4    │
│ 2   ┆ n    ┆ 4    │
│ 2   ┆ n    ┆ 4    │
└─────┴──────┴──────┘
```

単一の式に全ての操作を格納できるため、複数の `window` 関数を組み合わせたり、
異なるグループを組み合わせたりすることができます！

同じグループに適用されるwindowエクスプレッションは Polars によってキャッシュされるため、
単一の `with_columns` にそれらを格納することは便利であり、**かつ** 最適です。次の例では、
`"c"` に対してグループ統計を2回計算するケースを見ていきます：

```python
df.with_columns(
    pl.col("c").count().over("c").alias("size"),
    pl.col("c").sum().over("type").alias("sum"),
    pl.col("type").reverse().over("c").alias("reverse_type")
)
```

```
shape: (7, 5)
┌─────┬──────┬──────┬─────┬──────────────┐
│ c   ┆ type ┆ size ┆ sum ┆ reverse_type │
│ --- ┆ ---  ┆ ---  ┆ --- ┆ ---          │
│ i64 ┆ str  ┆ u32  ┆ i64 ┆ str          │
╞═════╪══════╪══════╪═════╪══════════════╡
│ 1   ┆ m    ┆ 3    ┆ 5   ┆ o            │
│ 1   ┆ n    ┆ 3    ┆ 5   ┆ n            │
│ 1   ┆ o    ┆ 3    ┆ 1   ┆ m            │
│ 2   ┆ m    ┆ 4    ┆ 5   ┆ n            │
│ 2   ┆ m    ┆ 4    ┆ 5   ┆ n            │
│ 2   ┆ n    ┆ 4    ┆ 5   ┆ m            │
│ 2   ┆ n    ┆ 4    ┆ 5   ┆ m            │
└─────┴──────┴──────┴─────┴──────────────┘
```

## 欠損データ

pandas では、列の dtype に応じて `NaN` や `None` の値を使用して欠損値を示します。さらに、pandas ではデフォルトの dtype またはオプションの nullable 配列を使用するかによって挙動が異なります。Polars では、すべてのデータ型に対して欠損データは `null` 値に対応します。

浮動小数点のカラムにおいて、Polars は `NaN` 値の使用を許可しています。これらの `NaN` 値は欠損データとは見なされず、特別な浮動小数点値として扱われます。

pandas では、欠損値を持つ整数列は、欠損値のために `NaN` 値を持つ浮動小数点列にキャストされます（オプションの null を許容する整数型の dtype を使用しない限り）。Polars では、整数列の欠損値は単に `null` 値であり、列は引き続き整数列のままです。

詳細については、[欠損データ](../expressions/missing-data.md) セクションを参照してください。

## パイプの使用

pandas で一般的な使用方法は、`pipe` を利用して `DataFrame` に何らかの関数を適用することです。
このコーディングスタイルを Polars にそのまま適用するのは自然ではなく、最適ではないなクエリ計画につながります。

以下のスニペットは、pandas でよく見られるパターンを示しています。

```python
def add_foo(df: pd.DataFrame) -> pd.DataFrame:
    df["foo"] = ...
    return df

def add_bar(df: pd.DataFrame) -> pd.DataFrame:
    df["bar"] = ...
    return df


def add_ham(df: pd.DataFrame) -> pd.DataFrame:
    df["ham"] = ...
    return df

(df
 .pipe(add_foo)
 .pipe(add_bar)
 .pipe(add_ham)
)
```

Polars でこれを行うと、3つの `with_columns` 式を作成してしまい、
Polars に3つのパイプを順番に実行させることになり、並列処理は一切利用されません。

Polars で同様の抽象化を得る方法は、エクスプレッションを生成する関数を作成することです。
以下のスニペットでは、単一の式で実行される3つのエクスプレッションを作成し、これにより並列実行が可能になります。

```python
def get_foo(input_column: str) -> pl.Expr:
    return pl.col(input_column).some_computation().alias("foo")

def get_bar(input_column: str) -> pl.Expr:
    return pl.col(input_column).some_computation().alias("bar")

def get_ham(input_column: str) -> pl.Expr:
    return pl.col(input_column).some_computation().alias("ham")

# This single context will run all 3 expressions in parallel
df.with_columns(
    get_ham("col_a"),
    get_bar("col_b"),
    get_foo("col_c"),
)
```

式を生成する関数内でスキーマが必要な場合、単一の `pipe` を利用することができます：

```python
from collections import OrderedDict

def get_foo(input_column: str, schema: OrderedDict) -> pl.Expr:
    if "some_col" in schema:
        # branch_a
        ...
    else:
        # branch b
        ...

def get_bar(input_column: str, schema: OrderedDict) -> pl.Expr:
    if "some_col" in schema:
        # branch_a
        ...
    else:
        # branch b
        ...

def get_ham(input_column: str) -> pl.Expr:
    return pl.col(input_column).some_computation().alias("ham")

# Use pipe (just once) to get hold of the schema of the LazyFrame.
lf.pipe(lambda lf: lf.with_columns(
    get_ham("col_a"),
    get_bar("col_b", lf.schema),
    get_foo("col_c", lf.schema),
)
```

エクスプレッションを返す関数を書くことのもう一つの利点は、これらの関数が組み合わせ可能であることです。
式は連鎖させたり部分適用することができ、設計の柔軟性が大幅に向上します。
