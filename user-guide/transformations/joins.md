# 結合

## 結合戦略

Polarsは以下の結合戦略をサポートしており、 `how` 引数で指定できます:

| 戦略             | 説明                                                                                                                                                                                                     |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `inner`          | 両方のデータフレームで一致するキーを持つ行を返します。左右どちらかのデータフレームで一致しない行は破棄されます。                                                                                       |
| `left`           | 左側のデータフレームのすべての行を返します。右側のデータフレームで一致するものがない場合は、右側の列が null で埋められます。                                                                           |
| `outer`          | 左右両方のデータフレームのすべての行を返します。一方のデータフレームで一致するものがない場合は、他方の列が null で埋められます。                                                                       |
| `outer_coalesce` | 左右両方のデータフレームのすべての行を返します。これは `outer` に似ていますが、キー列が結合されます。                                                                                                   |
| `cross`          | 左側のデータフレームのすべての行と右側のデータフレームのすべての行のカルテシアン積を返します。重複する行は保持されます。`A` と `B` を cross join した場合の行数は常に `len(A) × len(B)` になります。 |
| `semi`           | 左側のデータフレームのキーが右側のデータフレームにも存在する行を返します。                                                                                                                             |
| `anti`           | 左側のデータフレームのキーが右側のデータフレームに存在しない行を返します。                                                                                                                             |

### 内部結合

`inner` 結合は、結合キーが両方の `DataFrame` に存在する行のみを含む `DataFrame` を生成します。例えば、次の 2 つの `DataFrame` を考えてみましょう:

{{code_block('user-guide/transformations/joins','innerdf',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:setup"
--8<-- "python/user-guide/transformations/joins.py:innerdf"
```

<p></p>

{{code_block('user-guide/transformations/joins','innerdf2',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:innerdf2"
```

注文と関連する顧客を持つ `DataFrame` を取得するには、`customer_id` 列で `inner` 結合を行います:

{{code_block('user-guide/transformations/joins','inner',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:inner"
```

### 左結合

`left` 結合は、左側の `DataFrame` のすべての行と、右側の `DataFrame` の結合キーが左側の `DataFrame` に存在する行のみを含む `DataFrame` を生成します。上記の例を使って、すべての顧客とそれらの注文（注文の有無に関わらず）を含む `DataFrame` を作成する場合は、`left` 結合を使うことができます:

{{code_block('user-guide/transformations/joins','left',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:left"
```

`customer_id` が `3` の顧客のフィールドが null になっていることに注目してください。この顧客には注文がないためです。

### 外部結合

`outer` 結合は、両方の `DataFrame` のすべての行を含む `DataFrame` を生成します。結合キーが存在しない場合、列は null になります。上記の 2 つの `DataFrame` に対して `outer` 結合を行うと、`left` 結合と似た `DataFrame` が生成されます:

{{code_block('user-guide/transformations/joins','outer',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:outer"
```

### 外部結合とコアレス

`outer_coalesce` 結合は、`outer` 結合のように両方の `DataFrames` からすべての行を結合しますが、結合キーの値をコアレスして単一の列にマージします。これにより、キー列のNULLを可能な限り避けて、結合キーの統一された表示を確保します。前述の2つの `DataFrames` を使って、outer 結合と比較してみましょう:

{{code_block('user-guide/transformations/joins','outer_coalesce',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:outer_coalesce"
```

`outer` 結合では `customer_id` と `customer_id_right` の列が別々のままですが、`outer_coalesce` 結合では これらの列が単一の `customer_id` 列にマージされます。

### クロス結合

`クロス`結合は、2つの`DataFrame`のカルテシアン積です。これは、左側の`DataFrame`の各行が右側の`DataFrame`の各行と結合されることを意味します。`クロス`結合は、2つの`DataFrame`の列のすべての組み合わせを持つ`DataFrame`を作成するのに便利です。以下の2つの`DataFrame`を例に取ってみましょう。

{{code_block('user-guide/transformations/joins','df3',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:df3"
```

<p></p>

{{code_block('user-guide/transformations/joins','df4',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:df4"
```

これで、`クロス`結合を使って、色とサイズのすべての組み合わせを含む`DataFrame`を作成できます:

{{code_block('user-guide/transformations/joins','cross',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:cross"
```

<br>

`inner`、`left`、`outer`、`cross`結合の戦略は、データフレームライブラリの標準的なものです。以下では、あまり馴染みのない`semi`、`anti`、`asof`結合の戦略についてより詳しく説明します。

### 半結合

`semi` 結合は、結合キーが右側のフレームにも存在する左側のフレームの行をすべて返します。次のようなシナリオを考えてみましょう。カーレンタル会社には、それぞれに一意の `id` を持つ車が登録された `DataFrame` があります。

{{code_block('user-guide/transformations/joins','df5',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:df5"
```

この会社には、車両に実施された修理ジョブを示す別の `DataFrame` があります。

{{code_block('user-guide/transformations/joins','df6',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:df6"
```

この質問に答えたいです: どの車が修理を受けたのでしょうか?

内部結合 (inner join) では、この質問に直接答えることはできません。なぜなら、複数回の修理ジョブを受けた車両について、複数の行が生成されるためです:

{{code_block('user-guide/transformations/joins','inner2',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:inner2"
```

しかし、セミ結合 (semi join) を使えば、修理ジョブを受けた車両について、1行ずつ取得できます。

{{code_block('user-guide/transformations/joins','semi',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:semi"
```

### 逆結合

この例を続けると、別の質問として次のようなものが考えられます: どの車にも修理が行われていないのはどれですか? 逆結合を使うと、`df_repairs` DataFrame に存在しない `id` を持つ `df_cars` の車を示す DataFrame が得られます。

{{code_block('user-guide/transformations/joins','anti',['join'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:anti"
```

## 直前の引用

`asof` 結合は左結合のようなものですが、等しいキーではなく最も近いキーでマッチさせます。
Polars では `join_asof` メソッドを使って asof 結合を行うことができます。

次のようなシナリオを考えましょう: 株式仲介業者には `df_trades` という取引記録の DataFrame があります。

{{code_block('user-guide/transformations/joins','df7',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:df7"
```

この仲介業者には、これらの株式の価格情報を示す `df_quotes` という別の DataFrame もあります。

{{code_block('user-guide/transformations/joins','df8',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:df8"
```

各取引について、取引の直前に提示された最新の価格情報を表示する DataFrame を作成したいと思います。これを実現するには `join_asof` を使います（デフォルトの `strategy = "backward"` を使用）。
株式ごとに取引と価格情報が正しくマッチするよう、`by="stock"` を指定して事前の正確な結合を行う必要があります。

{{code_block('user-guide/transformations/joins','asof',['join_asof'])}}

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:asofpre"
--8<-- "python/user-guide/transformations/joins.py:asof"
```

取引と価格情報の間に一定の時間範囲を設けたい場合は、`tolerance` 引数を指定できます。ここでは取引の 1 分前までの価格情報を結合したいので、`tolerance = "1m"` と設定しています。

=== ":fontawesome-brands-python: Python"

```python
--8<-- "python/user-guide/transformations/joins.py:asof2"
```

```python exec="on" result="text" session="user-guide/transformations/joins"
--8<-- "python/user-guide/transformations/joins.py:asof2"
```
