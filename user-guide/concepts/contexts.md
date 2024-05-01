# コンテキスト

Polarsは、データを変換するための独自のドメイン固有言語（DSL）を開発しました。この言語は非常に使いやすく、人間が読みやすい複雑なクエリを可能にします。この言語の2つの中核的な要素は、コンテキストとエクスプレッションです。後者については次のセクションで説明します。

名前が示すように、コンテキストは式を評価する必要があるコンテキストを指します。主な3つのコンテキストがあります[^1]:

1. 選択: `df.select(...)`, `df.with_columns(...)`
1. フィルタリング: `df.filter()`
1. グループ化 / 集計: `df.group_by(...).agg(...)`

以下の例は、次の `DataFrame` で実行されます:

{{code_block('user-guide/concepts/contexts','dataframe',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:setup"
--8<-- "python/user-guide/concepts/contexts.py:dataframe"
```

## 選択

選択コンテキストは、カラムに対して式を適用します。 `select` は、集計、式の組み合わせ、またはリテラルの新しいカラムを生成する可能性があります。

選択コンテキストの式は、すべて同じ長さの `Series` を生成するか、長さが 1 の `Series` を生成する必要があります。リテラルは長さ 1 の `Series` として扱われます。

一部の式が長さ 1 の `Series` を生成し、他の式が長さ 1 ではない場合、長さ 1 の `Series` は残りの `Series` の長さに合わせてブロードキャストされます。
ブロードキャストは式内でも発生することに注意してください。例えば、`pl.col.value() / pl.col.value.sum()` では、`value` カラムの各要素がカラムの合計で除されます。

{{code_block('user-guide/concepts/contexts','select',['select'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:select"
```

クエリから分かるように、選択コンテキストは非常に強力で、お互いに独立して（そして並行して）任意の式を評価することができます。

`select` ステートメントと同様に、`with_columns` ステートメントも選択コンテキストに入ります。`with_columns` と `select` の主な違いは、`with_columns` は元のカラムを保持し新しいカラムを追加するのに対し、`select` は元のカラムを削除することです。

{{code_block('user-guide/concepts/contexts','with_columns',['with_columns'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:with_columns"
```

## フィルタリング

フィルタリングコンテキストは、 `Boolean` データ型に評価される1つ以上の式に基づいて `DataFrame` をフィルタリングします。

{{code_block('user-guide/concepts/contexts','filter',['filter'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:filter"
```

## グループ化 / 集計

`group_by` コンテキストでは、式はグループに対して機能するため、任意の長さの結果を生成する可能性があります（グループには多数のメンバーがいる可能性があります）。

{{code_block('user-guide/concepts/contexts','group_by',['group_by'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:group_by"
```

結果から分かるように、`group_by` コンテキストで定義されたグループに対して式が適用されています。`group_by` の他に、`group_by_dynamic` や `group_by_rolling` もグループ化コンテキストへの入り口です。

[^1]: このガイドの後の部分でリストと SQL のコンテキストについても説明されていますが、ここでは簡単のため対象外としています。
