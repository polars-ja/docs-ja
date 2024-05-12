# クエリプラン

Polarsでは、遅延クエリには以下の2つがあります:

- 提供したコードの手順セットのままの非最適化プラン
- クエリオプティマイザーによる変更を加えた最適化プラン

非最適化プランと最適化プランの両方を、視覚化や文字列出力で理解することができます。

<div style="display:none">
```python exec="on" result="text" session="user-guide/lazy/query-plan"
--8<-- "python/user-guide/lazy/query-plan.py:setup"
```
</div>

以下のクエリを考えてみましょう:

{{code_block('user-guide/lazy/query-plan','plan',[])}}

```python exec="on" session="user-guide/lazy/query-plan"
--8<-- "python/user-guide/lazy/query-plan.py:plan"
```

## 非最適化クエリプラン

### Graphvizによる視覚化

クエリプランの視覚化には、[Graphvizをインストールし](https://graphviz.org/download/)、PATHに追加する必要があります。

まず、`optimized=False`を設定して非最適化プランを視覚化します。

{{code_block('user-guide/lazy/query-plan','showplan',['show_graph'])}}

```python exec="on" session="user-guide/lazy/query-plan"
--8<-- "python/user-guide/lazy/query-plan.py:createplan"
```

クエリプランの視覚化は、下から上に向けて読みます。視覚化では:

- 各ボックスがクエリプランの段階を表しています
- `sigma`は`SELECTION`を表し、フィルター条件を示しています
- `pi`は`PROJECTION`を表し、列のサブセットを選択していることを示しています

### クエリプランの出力

`explain(optimized=False)`で非最適化プランを出力することもできます。

{{code_block('user-guide/lazy/query-plan','describe',['explain'])}}

```python exec="on" session="user-guide/lazy/query-plan"
--8<-- "python/user-guide/lazy/query-plan.py:describe"
```

```text
FILTER [(col("comment_karma")) > (0)] FROM WITH_COLUMNS:
 [col("name").str.uppercase()]

    CSV SCAN data/reddit.csv
    PROJECT */6 COLUMNS
```

出力されたプランも、下から上に向けて読みます。この非最適化プランは概ね以下のようなものです:

- `data/reddit.csv`ファイルから読み込む
- 6つの列すべて(PROJECT \*/6 COLUMNS のワイルドカード*は全列を意味する)を読み込む
- `name`列を大文字に変換する
- `comment_karma`列にフィルターを適用する

## 最適化クエリプラン

次に、`show_graph`で最適化プランを視覚化します。

{{code_block('user-guide/lazy/query-plan','show',['show_graph'])}}

```python exec="on" session="user-guide/lazy/query-plan"
--8<-- "python/user-guide/lazy/query-plan.py:createplan2"
```

`explain`で最適化プランを出力することもできます。

{{code_block('user-guide/lazy/query-plan','optimized',['explain'])}}

```text
 WITH_COLUMNS:
 [col("name").str.uppercase()]

    CSV SCAN data/reddit.csv
    PROJECT */6 COLUMNS
    SELECTION: [(col("comment_karma")) > (0)]
```

最適化プランは以下のようになっています:

- RedditのCSVデータを読み込む
- 行単位でCSVを読み込みながら、`comment_karma`列にフィルターを適用する
- `name`列を大文字に変換する

この場合、クエリオプティマイザーは、メモリ上に全データを読み込んでからフィルターを適用するのではなく、CSVの読み込み時にフィルターを適用できることを見つけました。これは_Predicate Pushdown_と呼ばれる最適化です。