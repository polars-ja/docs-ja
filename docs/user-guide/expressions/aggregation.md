# 集計（Aggregation）

Polars は、lazy API だけでなく、eager API でも強力な構文を実装しています。それがどういう意味かを見ていきましょう。

米国議会データセット（[US congress `dataset`](https://github.com/unitedstates/congress-legislators)）から始めましょう。

{{code_block('user-guide/expressions/aggregation','dataframe',['DataFrame','Categorical'])}}

#### 基本的な集計

`list` に複数の式を追加することで、簡単に異なる集計を組み合わせられます。
集計の数に上限はなく、好きな組み合わせを作成できます。
以下のスニペットでは、次のような集計を行っています:

`"first_name"` グループごとに

<!-- dprint-ignore-start -->

- `"party"` 列の行数をカウントします:
    - 短縮形: `pl.count("party")`
    - 完全形: `pl.col("party").count()`
- `"gender"` 値をグループ化して集計します:
    - 完全形: `pl.col("gender")`
- グループ内の `"last_name"` 列の最初の値を取得します:
    - 短縮形: `pl.first("last_name")`（Rustでは使えません）
    - 完全形: `pl.col("last_name").first()`

<!-- dprint-ignore-end -->

集計の後、結果をすぐにソートし、上位 `5` 件に制限して、
わかりやすい概要を得ています。

{{code_block('user-guide/expressions/aggregation','basic',['group_by'])}}

```python exec="on" result="text" session="user-guide/expressions"
--8<-- "python/user-guide/expressions/aggregation.py:setup"
--8<-- "python/user-guide/expressions/aggregation.py:dataframe"
--8<-- "python/user-guide/expressions/aggregation.py:basic"
```

#### 条件式

簡単ですね！さらに進めましょう。
"state" の代表者が "Pro" または "Anti" 政権かどうかを知りたいとします。
`lambda` や `DataFrame` の整理に頼ることなく、集計の中で直接クエリを使えます。

{{code_block('user-guide/expressions/aggregation','conditional',['group_by'])}}

```python exec="on" result="text" session="user-guide/expressions"
--8<-- "python/user-guide/expressions/aggregation.py:conditional"
```

同様のことは、ネストされた GROUP BY でも行えますが、これらの素晴らしい機能を示すのに役立ちません。 😉

{{code_block('user-guide/expressions/aggregation','nested',['group_by'])}}

```python exec="on" result="text" session="user-guide/expressions"
--8<-- "python/user-guide/expressions/aggregation.py:nested"
```

#### フィルタリング

グループをフィルタリングすることもできます。
グループごとの平均を計算したいが、そのグループのすべての値を含めたくない、
また `DataFrame` の行をフィルタリングしたくない（別の集計に必要なため）場合などです。

以下の例では、これがどのように行えるかを示しています。

!!! note

    Python 関数を明確にするためのメモ。これらの関数にはコストがかかりません。なぜなら、Polars エクスプレッションのみを作成し、クエリの実行時にカスタム関数を `Series` 上で適用しないためです。もちろん、Rust でもエクスプレッションを返す関数を作ることができます。

{{code_block('user-guide/expressions/aggregation','filter',['group_by'])}}

```python exec="on" result="text" session="user-guide/expressions"
--8<-- "python/user-guide/expressions/aggregation.py:filter"
```

#### ソート

GROUP BY 操作の順序を管理するために、`DataFrame` をソートすることは一般的です。州ごとの最年長および最年少の政治家の名前を取得したいとします。その際は、SORT と GROUP BY を使うことができます。

{{code_block('user-guide/expressions/aggregation','sort',['group_by'])}}

```python exec="on" result="text" session="user-guide/expressions"
--8<-- "python/user-guide/expressions/aggregation.py:sort"
```

ただし、**もし** 名前をアルファベット順にソートしたい場合、これは機能しません。幸いにも、`group_by` 式で `DataFrame` とは別にソートができます。

{{code_block('user-guide/expressions/aggregation','sort2',['group_by'])}}

```python exec="on" result="text" session="user-guide/expressions"
--8<-- "python/user-guide/expressions/aggregation.py:sort2"
```

`group_by` 式の中で別の列を基準にソートすることもできます。アルファベット順にソートされた名前が男性か女性かを知りたい場合は：`pl.col("gender").sort_by("first_name").first().alias("gender")` と記述できます。

{{code_block('user-guide/expressions/aggregation','sort3',['group_by'])}}

```python exec="on" result="text" session="user-guide/expressions"
--8<-- "python/user-guide/expressions/aggregation.py:sort3"
```

### 並列処理を阻害しない

!!! warning "Python ユーザーのみ"

    以下のセクションは Python に固有のものであり、Rust には適用されません。Rust では、ブロックとクロージャ(ラムダ)を並行して実行できるためです。

Python は遅くて "スケールしない" というのは、誰もが耳にしたことがあるでしょう。
"遅い" バイトコードを実行するオーバーヘッドに加えて、Python は Global Interpreter Lock（GIL）の制約の中にいなければなりません。
つまり、並列化フェーズで `lambda` やカスタム Python 関数を使用する場合、
Polars の速度は Python コードの実行によって制限され、
複数のスレッドが関数を実行することを妨げます。

これはとてもうっとうしい制限に感じられますが、特に `.group_by()` ステップでは `lambda` 関数が必要になることが多いです。
このアプローチは Polars でまだサポートされていますが、バイトコード **と** GIL のコストを支払う必要があることを念頭に置いてください。エクスプレッションの構文を使ってクエリを解決することをお勧めします。
`lambda` の使用については、[ユーザー定義関数セクション](./user-defined-functions.md) を参照してください。

### まとめ

上記の例では、エクスプレッションを組み合わせることで多くのことができることを見てきました。そうすることで、（Python と GIL の遅い性質によって）クエリを遅くする Python のカスタム関数の使用を遅らせられます。

もしエクスプレッションのタイプが見つからない場合は、[feature request](https://github.com/pola-rs/polars/issues/new/choose)を開いてお知らせください！
