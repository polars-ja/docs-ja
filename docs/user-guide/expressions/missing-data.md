# 欠損データ（Missing data）

このページでは、Polars における欠損データの表現方法と、欠損データの補完方法について説明します。

## `null` と `NaN` 値

`DataFrame`（または同等の `Series`）の各カラムは、Arrow 配列または Arrow 配列の集合です（[Apache Arrow 形式に基づいています](https://arrow.apache.org/docs/format/Columnar.html#null-count)）。欠損データは、Arrow および Polars で `null` 値として表されます。この `null` 値は、数値を含むすべてのデータタイプに適用されます。

Polars は、浮動小数点カラムに対して `NotaNumber` または `NaN` 値を許容しています。これらの `NaN` 値は、欠損データではなく浮動小数点データの一種と見なされます。`NaN` 値については後述します。

Python の `None` 値を使用して、手動で欠損値を定義することができます：

{{code_block('user-guide/expressions/missing-data','dataframe',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:setup"
--8<-- "python/user-guide/expressions/missing-data.py:dataframe"
```

!!! info

    pandas では、カラムの dtype によって欠損データの値が異なります。Polars では、欠損データは常に `null` 値として表されます。

## 欠損データのメタデータ

Polars で使用される各 Arrow 配列は、欠損データに関連する二種類のメタデータを格納しています。このメタデータにより、Polars は欠損値の数とどの値が欠損しているかを迅速に示すことができます。

最初のメタデータは `null_count` で、これはカラム内の `null` 値を持つ行の数です：

{{code_block('user-guide/expressions/missing-data','count',['null_count'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:count"
```

`null_count` メソッドは `DataFrame`、`DataFrame` のカラム、または `Series` に対して呼び出すことができます。`null_count` メソッドは、基本的な Arrow 配列で `null_count` がすでに計算されているため、低コストの操作です。

もう一つのメタデータは、各データ値が有効か欠損かを示す _validity bitmap_ と呼ばれる配列です。
validity bitmap はメモリ効率が良いです。なぜなら、ビットエンコードされているからです（各値は 0 または 1）。このビットエンコードにより、配列ごとのメモリオーバーヘッドは（配列の長さ / 8）バイトのみです。validity bitmap は Polars の `is_null` メソッドで使用されます。

`DataFrame` または `Series` のカラムに対する validity bitmap を基に `Series` を返すことが、`is_null` メソッドで可能です：

{{code_block('user-guide/expressions/missing-data','isnull',['is_null'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:isnull"
```

`is_null` メソッドは、`null` 値を完全にスキャンする必要がないため、低コストの操作です。これは、validity bitmap がすでに存在し、Boolean 配列として返されるためです。

## 欠損データの補完

`Series` の欠損データは、`fill_null` メソッドで補完することができます。欠損データをどのように補完するかを指定する必要があります。これを行う主な方法は次のとおりです：

- リテラル（0 や "0" など）で補完
- 戦略（前方に補完するなど）で補完
- 別のカラムからの値で置換するなどのエクスプレッションで補完
- 補間

欠損値がある `col2` を持つシンプルな `DataFrame` を定義して、null を補完する方法を示します：

{{code_block('user-guide/expressions/missing-data','dataframe2',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:dataframe2"
```

### 指定されたリテラル値で補完

指定されたリテラル値で欠損データを補完することができます。例えば `pl.lit` を使います：

{{code_block('user-guide/expressions/missing-data','fill',['fill_null'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:fill"
```

### 戦略で補完

欠損データを戦略で補完することができます。例えば、前方に補完する戦略です：

{{code_block('user-guide/expressions/missing-data','fillstrategy',['fill_null'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:fillstrategy"
```

API ドキュメントで他の補完戦略を見つけることができます。

### エクスプレッションで補完

より柔軟性を持って欠損データを補完することができます。
例えば、そのカラムの中央値で null を補完します：

{{code_block('user-guide/expressions/missing-data','fillexpr',['fill_null'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:fillexpr"
```

この場合、中央値が浮動小数点統計であるため、カラムは整数から浮動小数点にキャストされます。

### 補間で補完

さらに、補間を使用して（`fill_null` 関数を使用せずに）null を補完することもできます：

{{code_block('user-guide/expressions/missing-data','fillinterpolate',['interpolate'])}}

```python exec="on" result="text" session="user-guide/missing-data"
--8<-- "python/user-guide/expressions/missing-data.py:fillinterpolate"
```

## `NotaNumber` または `NaN` 値

`Series` の欠損データには `null` 値があります。しかし、浮動小数点データ型のカラムでは `NotaNumber` または `NaN` 値を使用することができます。これらの `NaN` 値は、Numpy の `np.nan` またはネイティブ Python の `float('nan')` から作成することができます：

{{code_block('user-guide/expressions/missing-data','nan',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/missing-data
--8<-- "python/user-guide/expressions/missing-data.py:nan"
```

!!! info

    pandas では、整数カラムの `NaN` 値がデフォルトでカラムを浮動小数点にキャストします。これは Polars では起こらず、代わりに例外が発生します。

`NaN` 値は浮動小数点データの一種と見なされ、Polars では**欠損データとは見なされません**。つまり：

- `NaN` 値は `null_count` メソッドでカウントされ**ません**
- `NaN` 値は `fill_nan` メソッドで補完されますが、`fill_null` メソッドでは補完され**ません**

Polars には `is_nan` と `fill_nan` のメソッドがあり、`is_null` と `fill_null` のメソッドと同様に動作します。`NaN` 値には事前計算された validity bitmap がないため、`is_nan` メソッド用にこれを計算する必要があります。

`null` と `NaN` 値のもう一つの違いは、`null` 値を含むカラムの平均を取る場合、`null` 値は計算から除外されますが、`NaN` 値を含む場合、平均を取ると `NaN` になります。この挙動は、`NaN` 値を `null` 値に置き換えることで回避することができます：

{{code_block('user-guide/expressions/missing-data','nanfill',['fill_nan'])}}

```python exec="on" result="text" session="user-guide/missing-data
--8<-- "python/user-guide/expressions/missing-data.py:nanfill"
```
