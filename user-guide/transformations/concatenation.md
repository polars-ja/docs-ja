# 連結

別の DataFrame からデータを連結する方法は以下のようなものがあります:

- **同じ列**を持つ 2 つの DataFrame を **垂直方向** に連結して、**より長い** DataFrame を作成できます
- **重複しない列**を持つ 2 つの DataFrame を **水平方向** に連結して、**より広い** DataFrame を作成できます
- **行数と列数が異なる** 2 つの DataFrame を **斜め方向** に連結して、より長くて/または広い DataFrame を作成できます。列名が重複する場合は値が垂直に連結されます。列名が重複しない場合は新しい行と列が追加されます。欠損値は `null` に設定されます。

## 垂直方向の連結 - より長くなる

垂直方向の連結では、`DataFrames` のリストからすべての行を組み合わせて、単一の長い `DataFrame` を作成します。

{{code_block('user-guide/transformations/concatenation','vertical',['concat'])}}

```python exec="on" result="text" session="user-guide/transformations/concatenation"
--8<-- "python/user-guide/transformations/concatenation.py:setup"
--8<-- "python/user-guide/transformations/concatenation.py:vertical"
```

DataFrame のカラム名が異なる場合、垂直方向の連結は失敗します。

## 水平方向の結合 - 幅を広げる

水平方向の結合では、`DataFrames` のリストから全ての列を1つの幅広い `DataFrame` に結合します。

{{code_block('user-guide/transformations/concatenation','horizontal',['concat'])}}

```python exec="on" result="text" session="user-guide/transformations/concatenation"
--8<-- "python/user-guide/transformations/concatenation.py:horizontal"
```

列が重複している場合は、水平方向の結合は失敗します。

行数が異なる場合は、最大の行数まで `null` 値で埋められます。

{{code_block('user-guide/transformations/concatenation','horizontal_different_lengths',['concat'])}}

```python exec="on" result="text" session="user-guide/transformations/concatenation"
--8<-- "python/user-guide/transformations/concatenation.py:horizontal_different_lengths"
```

## 対角結合 - 長さと幅が増え、 `null` が増える

対角結合では、 `DataFrames` のリストから全ての行と列を1つの長くて/または幅広い `DataFrame` に結合します。

{{code_block('user-guide/transformations/concatenation','cross',['concat'])}}

```python exec="on" result="text" session="user-guide/transformations/concatenation"
--8<-- "python/user-guide/transformations/concatenation.py:cross"
```

対角結合では、列名が重複しない場合に null が生成されます。

データフレームの形状が一致せず、重複するセマンティックキーがある場合は、concatenateする代わりに [データフレームを結合](joins.md) することができます。

## リチャンキング

concatenationの前に `df1` と `df2` という2つのデータフレームがあります。 `df1` と `df2` の各列はメモリ上の1つ以上のチャンクに格納されています。デフォルトでは、concatenation中にそれぞれの列のチャンクが単一の新しいチャンクにコピーされます - これを **リチャンキング** と呼びます。リチャンキングは高コストな操作ですが、将来の操作が高速化されるため、しばしば価値があります。
concatenated `DataFrame` をリチャンキングしたくない場合は、concatenationの際に `rechunk = False` を指定することができます。
