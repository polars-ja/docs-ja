# はじめ方

この章では Polars のはじめ方を解説します。ライブラリの基本的な特徴や機能を紹介し、新しいユーザーが最初のインストールからコアな機能を使えるようになるまでの基礎を習得しやすくします。もしあなたが熟練したユーザーであったり、DataFrame に馴染みがあるならば、[次のインストールオプションの章](installation.md)にスキップしても問題ありません。

## Polars のインストール

=== ":fontawesome-brands-python: Python"

    ``` bash
    pip install polars
    ```

=== ":fontawesome-brands-rust: Rust"

    ``` shell
    cargo add polars -F lazy

    # Or Cargo.toml
    [dependencies]
    polars = { version = "x", features = ["lazy", ...]}
    ```

## 読み込みと書き込み

Polars は一般的なファイル形式（例：csv, json, parquet）、クラウドストレージ（例：S3、Azure Blob、BigQuery）およびデータベース（例：postgres, mysql）の読み書きをサポートしています。以下はディスクへの読み書きの考え方を示します。

{{code_block('user-guide/getting-started/reading-writing','dataframe',['DataFrame'])}}

```python exec="on" result="text" session="getting-started/reading"
--8<-- "python/user-guide/getting-started/reading-writing.py:dataframe"
```

次の例では DataFrame を `output.csv` という名前の csv ファイルに出力しています。その後に `read_csv` を用いて再度それを読み込み、確認のために `print` で表示しています、

{{code_block('user-guide/getting-started/reading-writing','csv',['read_csv','write_csv'])}}

```python exec="on" result="text" session="getting-started/reading"
--8<-- "python/user-guide/getting-started/reading-writing.py:csv"
```

CSV ファイル形式や他のデータ形式の例をもっと確認したい場合は、ユーザーガイドの [IO の章](io/index.md)を参照ください。

## エクスプレッション

エクスプレッションは Polars のコアな強みです。エクスプレッション
は単純なコンセプトを組合せて複雑なクエリを構築することを可能にするモジュール構造を提供します。以下は全てのクエリの構成要素を提供する基本的なコンポーネント（Polars の用語で式と呼ぶ）です：
- `select`
- `filter`
- `with_columns`
- `group_by`

エクスプレッションや式がどのように機能するかをより詳しく学ぶには、ユーザーガイドの [式](concepts/contexts.md) および [Expressions](concepts/expressions.md) セクションを参照してください。

### 選択

カラムを選択するためには２つのことをする必要があります：

1. データを取得する対象の `DataFrame` を定義する
2. 必要なデータを選択する

以下の例では select 時に `col('*')` と指定しています。アスタリスクは全てのカラムを意味します。

{{code_block('user-guide/getting-started/expressions','select',['select'])}}

```python exec="on" result="text" session="getting-started/expressions"
--8<-- "python/user-guide/getting-started/expressions.py:setup"
print(
    --8<-- "python/user-guide/getting-started/expressions.py:select"
)
```

特定のカラムを指定して取得することもできます。これをするには２つの方法があります。１つは以下のようにカラムの名前を渡す方法です。

{{code_block('user-guide/getting-started/expressions','select2',['select'])}}

```python exec="on" result="text" session="getting-started/expressions"
print(
    --8<-- "python/user-guide/getting-started/expressions.py:select2"
)
```

より詳しく学ぶには、ユーザーガイドの[基本的な操作](expressions/operators.md)や[カラムの選択](expressions/column-selections.md)を参照してください。

### 抽出

`filter` により `DataFrame` のサブセットを作成することができます。先ほどと同じ `DataFrame` を使って二つの特定の日付の期間で抽出します。

{{code_block('user-guide/getting-started/expressions','filter',['filter'])}}

```python exec="on" result="text" session="getting-started/expressions"
print(
    --8<-- "python/user-guide/getting-started/expressions.py:filter"
)
```

`filter` を使うことで、複数のカラムを含むより複雑な抽出をすることもできます。

{{code_block('user-guide/getting-started/expressions','filter2',['filter'])}}

```python exec="on" result="text" session="getting-started/expressions"
print(
    --8<-- "python/user-guide/getting-started/expressions.py:filter2"
)
```

### カラムの追加

`with_columns` で分析のための新しいカラムを作成することができます。二つの新しいカラム `e` と `b+42` を作ります。まずはカラム `b` の全ての値の合計を計算し、それをカラム `e` に保存します。次に `b` に `42` を足します。それらの結果を保存する新しいカラム `b+42` を作成します。 

{{code_block('user-guide/getting-started/expressions','with_columns',['with_columns'])}}

```python exec="on" result="text" session="getting-started/expressions"
print(
    --8<-- "python/user-guide/getting-started/expressions.py:with_columns"
)
```

### グループ化

グループ化の機能で新しい `DataFrame` を作成します。この新しい `DataFrame` はグループ分けしたい複数の「グループ」を持ちます。

{{code_block('user-guide/getting-started/expressions','dataframe2',['DataFrame'])}}

```python exec="on" result="text" session="getting-started/expressions"
--8<-- "python/user-guide/getting-started/expressions.py:dataframe2"
print(df2)
```

{{code_block('user-guide/getting-started/expressions','group_by',['group_by'])}}

```python exec="on" result="text" session="getting-started/expressions"
print(
    --8<-- "python/user-guide/getting-started/expressions.py:group_by"
)
```

{{code_block('user-guide/getting-started/expressions','group_by2',['group_by'])}}

```python exec="on" result="text" session="getting-started/expressions"
print(
    --8<-- "python/user-guide/getting-started/expressions.py:group_by2"
)
```

### 組み合わせ

以下は必要な `DataFrame` を作成するために操作を組み合わせる例です。

{{code_block('user-guide/getting-started/expressions','combine',['select','with_columns'])}}

```python exec="on" result="text" session="getting-started/expressions"
--8<-- "python/user-guide/getting-started/expressions.py:combine"
```

{{code_block('user-guide/getting-started/expressions','combine2',['select','with_columns'])}}

```python exec="on" result="text" session="getting-started/expressions"
--8<-- "python/user-guide/getting-started/expressions.py:combine2"
```

## DataFrame を組み合わせる

ユースケースに基づいて `DataFrame` を組み合わせる方法が2つあります：join と concat です。

### Join

Polars はすべての種類の join（例： left, right, inner, outer）をサポートします。2つの `DataFrame` を `join` で1つの `DataFrame` にする方法を詳しく見てみましょう。2つの `DataFrame` はどちらも「id」のようなカラムを持ちます：`a` と `x` です。この例ではこれらのカラムを使って `DataFrame` を `join` します。

{{code_block('user-guide/getting-started/joins','join',['join'])}}

```python exec="on" result="text" session="getting-started/joins"
--8<-- "python/user-guide/getting-started/joins.py:setup"
--8<-- "python/user-guide/getting-started/joins.py:join"
```

他の種類の結合の例を見たい場合は、ユーザーガイドの [Transformations section](transformations/joins.md) を参照してください。

### Concat

2つの `DataFrame` を「連結」することもできます。垂直方向の連結は `DataFrame` を長くします。水平方向の連結は `DataFrame` の幅を広げます。以下は2つの `DataFrame` を水平方向に連結した結果です。

{{code_block('user-guide/getting-started/joins','hstack',['hstack'])}}

```python exec="on" result="text" session="getting-started/joins"
--8<-- "python/user-guide/getting-started/joins.py:hstack"
```
