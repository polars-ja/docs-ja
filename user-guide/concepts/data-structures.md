# データ構造

Polars が提供するコアとなる基本データ構造は `Series` と `DataFrame` です。

## Series

Series は 1 次元のデータ構造です。Series 内のすべての要素は同じ [データ型](data-types/overview.md) を持ちます。
以下のスニペットは、単純な名前付き `Series` オブジェクトの作成方法を示しています。

{{code_block('user-guide/concepts/data-structures','series',['Series'])}}

```python exec="on" result="text" session="user-guide/data-structures"
--8<-- "python/user-guide/concepts/data-structures.py:series"
```

## DataFrame

`DataFrame` は 2 次元のデータ構造で、`Series` によってバックアップされています。`DataFrame` は `Series` のコレクション（リストなど）の抽象化と見なすことができます。`DataFrame` で実行できる操作は `SQL` クエリと非常によく似ています。`GROUP BY`、`JOIN`、`PIVOT` を行うことができ、カスタム関数を定義することもできます。

{{code_block('user-guide/concepts/data-structures','dataframe',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/data-structures"
--8<-- "python/user-guide/concepts/data-structures.py:dataframe"
```

### データの表示

このセクションでは、`DataFrame` 内のデータの表示方法について説明します。前の例で使用した `DataFrame` を起点として使用します。

#### Head

`head` 関数は、デフォルトで `DataFrame` の最初の 5 行を表示します。表示する行数を指定することもできます（例: `df.head(10)`）。

{{code_block('user-guide/concepts/data-structures','head',['head'])}}

```python exec="on" result="text" session="user-guide/data-structures"
--8<-- "python/user-guide/concepts/data-structures.py:head"
```

#### Tail

`tail` 関数は、`DataFrame` の最後の 5 行を表示します。`head` と同様に、表示する行数を指定することができます。

{{code_block('user-guide/concepts/data-structures','tail',['tail'])}}

```python exec="on" result="text" session="user-guide/data-structures"
--8<-- "python/user-guide/concepts/data-structures.py:tail"
```

#### Sample

`DataFrame` のデータの概要を把握したい場合は、`sample` を使用することができます。`sample` を使うと、`DataFrame` からランダムに _n_ 行を取得できます。

{{code_block('user-guide/concepts/data-structures','sample',['sample'])}}

```python exec="on" result="text" session="user-guide/data-structures"
--8<-- "python/user-guide/concepts/data-structures.py:sample"
```

#### Describe

`Describe` は、`DataFrame` の要約統計量を返します。可能な場合は、いくつかの基本的な統計量を提供します。

{{code_block('user-guide/concepts/data-structures','describe',['describe'])}}

```python exec="on" result="text" session="user-guide/data-structures"
--8<-- "python/user-guide/concepts/data-structures.py:describe"
```
