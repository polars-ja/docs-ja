# コンテキスト

Polarsは、データ変換のための独自のドメイン固有言語（DSL）を開発しました。このDSLは非常に使いやすく、人間が読みやすい上に、複雑なクエリを可能にします。この言語の2つの主要な構成要素は、コンテキストとエクスプレッションです。後者については次のセクションで説明します。

名前が示すように、コンテキストは、エクスプレッションを評価するために考慮すべき条件や関係を表します。主なコンテキストは以下の3 つです[^1]：

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

選択コンテキストは、カラムにエクスプレッションを適用します。`select`は、集計、式の組み合わせ、または新しいリテラルのカラムの生成を行います。

選択コンテキストのエクスプレッションは、すべて同じ長さの `Series` を生成するか、長さが 1 の `Series` を生成する必要があります。リテラルは長さ 1 の `Series` として扱われます。

一部のエクスプレッションが長さ 1 の `Series` を生成し、他のエクスプレッションが長さ 1 ではない場合、長さ 1 の `Series` は残りの `Series` の長さにブロードキャストされます。
ブロードキャストは、式内部でも発生することに注意してください。例えば、`pl.col.value() / pl.col.value.sum()` では、`value` カラムの各要素がカラムの合計で除されます。

{{code_block('user-guide/concepts/contexts','select',['select'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:select"
```

クエリから分かるように、選択コンテキストは非常に強力で、お互いに独立して（そして並行して）任意のエクスプレッションを評価できます。

`select` ステートメントと同様に、`with_columns` ステートメントも選択コンテキストに入ります。`with_columns` と `select` の主な違いは、`with_columns` は元のカラムを保持し新しいカラムを追加するのに対し、`select` は元のカラムを削除することです。

{{code_block('user-guide/concepts/contexts','with_columns',['with_columns'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:with_columns"
```

## フィルタリング

フィルタリングコンテキストは、`Boolean` データ型に評価される 1 つ以上のエクスプレッションに基づいて `DataFrame` をフィルタリングします。

{{code_block('user-guide/concepts/contexts','filter',['filter'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:filter"
```

## グループ化 / 集計

`group_by`コンテキストでは、エクスプレッションはグループを単位として機能するため、結果のデータ長は様々です（各グループのメンバー数に依存します）。

{{code_block('user-guide/concepts/contexts','group_by',['group_by'])}}

```python exec="on" result="text" session="user-guide/contexts"
--8<-- "python/user-guide/concepts/contexts.py:group_by"
```

結果から分かるように、`group_by` コンテキストで定義されたグループに対してすべての式が適用されます。標準の `group_by` の他に、`group_by_dynamic` および `group_by_rolling` もグループ化コンテキストです。

[^1]: このガイドの後の部分で説明されている List コンテキストと SQL コンテキストもありますが、簡単のため、ここでは対象外とします。
