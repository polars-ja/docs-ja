# リストと配列

Polars は `List` 列にファーストクラスのサポートを提供します。つまり、各行が同一の要素で構成され、長さが異なるリストです。Polars には `Array` データタイプもあります。これは NumPy の `ndarray` オブジェクトに類似しており、行間で長さが同一です。

注意: これは Python の `list` オブジェクトとは異なります。要素は任意のタイプになります。Polars はこれらを列内で格納できますが、これから説明する特別なリスト操作機能がない一般的な `Object` データタイプです。

## 強力な `List` 操作

以下のデータが異なる天気ステーションから得られたとしましょう。天気ステーションが結果を得ることができない場合、実際の温度ではなくエラーコードが記録されます。

{{code_block('user-guide/expressions/lists','weather_df',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:setup"
--8<-- "python/user-guide/expressions/lists.py:weather_df"
```

### `List` 列の作成

上記で作成された `weather` `DataFrame` では、各ステーションによって捕捉された温度の分析がおそらく必要です。これを行うためには、まず個々の温度測定値を取得する必要があります。これは次のように行います：

{{code_block('user-guide/expressions/lists','string_to_list',['str.split'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:string_to_list"
```

この後にできることの一つは、各温度測定をその自身の行に変換することです：

{{code_block('user-guide/expressions/lists','explode_to_atomic',['DataFrame.explode'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:explode_to_atomic"
```

しかし、Polars では `List` 要素を操作するためにこれを行う必要はしばしばありません。

### `List` 列の操作

Polars は `List` 列に対していくつかの標準操作を提供します。最初の 3 つの測定値が必要な場合、`head(3)` を行います。最後の 3 つは `tail(3)` で取得できます。または、`slice` を使用しても良いです（負のインデックスがサポートされています）。また、観測数を `lengths` を通じて特定することもできます。それらを実行してみましょう：

{{code_block('user-guide/expressions/lists','list_ops',['Expr.list'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:list_ops"
```

!!! warning "`arr` でしたが、今は `list` です"

    Stackoverflow や他の情報源で `arr` API に関する参照がある場合は、単に `arr` を `list` に置き換えてください。これは `List` データタイプの古いアクセサーでした。`arr` は最近導入された `Array` データタイプを指します（以下を参照）。

### `List` 内の要素ごとの計算

初期 `DataFrame` からエラーの数が最も多いステーションを特定する必要がある場合、次の手順を行います：

1. 文字列入力を `List` の文字列値として解析します（既に実行済み）。
2. 数字に変換可能な文字列を特定します。
3. リスト内の非数値（つまり `null` 値）の数を行ごとに特定します。
4. この出力を `errors` と名付け、ステーションを簡単に特定できるようにします。

第三ステップには、リストの各要素にキャスティング（または代替として正規表現検索）操作を適用する必要があります。これは `pl.element()` コンテキストでそれらを最初に参照してから、適切な Polars 式を呼び出すことによって行うことができます。それを見てみましょう：

{{code_block('user-guide/expressions/lists','count_errors',['Expr.list', 'element'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:count_errors"
```

正規表現ルートを選択した場合はどうでしょうか（つまり、_any_ 英字の存在を認識すること）？

{{code_block('user-guide/expressions/lists','count_errors_regex',['str.contains'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:count_errors_regex"
```

`(?i)` に慣れていない場合は、Polars の `str.contains` 関数のドキュメントを見る良いタイミングです！Rust regex クレートは多くの追加の正規表現フラグを提供しており、役立つかもしれません。

## 行ごとの計算

このコンテキストは行方向での計算に理想的です。

`list.eval` 式（Rust では `list().eval`）を使用して、リストの要素に対して **任意の** Polars 操作を適用することができます！これらの式は完全に Polars のクエリエンジンで実行され、並列に実行されるので、最適化されます。異なるステーションの 3 日間にわたる別の天気データがあるとしましょう：

{{code_block('user-guide/expressions/lists','weather_by_day',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:weather_by_day"
```

面白いことをしてみましょう。各ステーションで測定された温度の日ごとのパーセンテージランクを計算します。Pandas では `rank` 値のパーセンテージを計算することができます。Polars はこれを直接行う特別な関数を提供していませんが、式がとても多用途であるため、自分のパーセンテージランク式を作成することができます。試してみましょう！

{{code_block('user-guide/expressions/lists','weather_by_day_rank',['list.eval'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:weather_by_day_rank"
```

## Polars `Array`

`Array` は最近導入された新しいデータタイプで、現在も機能が進化しています。`List` と `Array` の主な違いは、後者は行ごとに同じ数の要素を持つことが制限されている点ですが、`List` は可変の要素数を持つことができます。それでも、各要素のデータタイプは同じである必要があります。

このように `Array` 列を定義することができます：

{{code_block('user-guide/expressions/lists','array_df',['Array'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:array_df"
```

基本操作が利用可能です：

{{code_block('user-guide/expressions/lists','array_ops',['Series.arr'])}}

```python exec="on" result="text" session="user-guide/lists"
--8<-- "python/user-guide/expressions/lists.py:array_ops"
```

Polars `Array` は現在も積極的に開発されており、このセクションは将来変更される可能性が高いです。
