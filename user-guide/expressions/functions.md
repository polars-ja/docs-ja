# 関数

Polars 式には多くの組み込み関数があります。これらを使用することで、[ユーザー定義関数](user-defined-functions.md)を必要とせずに複雑なクエリを作成できます。ここで全てを説明するには多すぎますが、より一般的な使用例のいくつかをカバーします。すべての関数を見たい場合は、プログラミング言語のAPIリファレンスを参照してください。

以下の例では、次の`DataFrame`を使用します：

{{code_block('user-guide/expressions/functions','dataframe',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/functions"
--8<-- "python/user-guide/expressions/functions.py:setup"
--8<-- "python/user-guide/expressions/functions.py:dataframe"
```

## カラム名付け

デフォルトでは、式を実行すると元のカラムと同じ名前が保持されます。以下の例では、`nrs`カラムに対して式を実行しています。出力`DataFrame`には依然として同じ名前があります。

{{code_block('user-guide/expressions/functions','samename',[])}}

```python exec="on" result="text" session="user-guide/functions"
--8<-- "python/user-guide/expressions/functions.py:samename"
```

同じカラムを式の中で複数回使用する場合、出力カラムが重複してしまい問題が発生することがあります。例えば、以下のクエリは失敗します。

{{code_block('user-guide/expressions/functions','samenametwice',[])}}

```python exec="on" result="text" session="user-guide/functions"
--8<-- "python/user-guide/expressions/functions.py:samenametwice"
```

式の出力名を変更するには、`alias`関数を使用します。

{{code_block('user-guide/expressions/functions','samenamealias',['alias'])}}

```python exec="on" result="text" session="user-guide/functions"
--8<-- "python/user-guide/expressions/functions.py:samenamealias"
```

例えば、`all()`や`col(*)`を使用する場合の複数のカラムに対して、`name.map`などのマッピング関数を適用して元のカラム名を変更することができます。サフィックス(`name.suffix()`)やプレフィックス(`name.prefix()`)を追加する場合も、これらは組み込まれています。

=== ":fontawesome-brands-python: Python"
[:material-api: `name.prefix`](https://docs.pola.rs/py-polars/html/reference/expressions/api/polars.Expr.name.prefix.html)
[:material-api: `name.suffix`](https://docs.pola.rs/py-polars/html/reference/expressions/api/polars.Expr.name.suffix.html)
[:material-api: `name.map`](https://docs.pola.rs/py-polars/html/reference/expressions/api/polars.Expr.name.map.html)

## 一意の値のカウント

Polarsでは、一意の値を数えるために2つの方法があります：正確な方法と近似法です。近似法は、[HyperLogLog++](https://en.wikipedia.org/wiki/HyperLogLog)アルゴリズムを使用して基数を近似し、近似で十分な非常に大きなデータセットで特に役立ちます。

{{code_block('user-guide/expressions/functions','countunique',['n_unique','approx_n_unique'])}}

```python exec="on" result="text" session="user-guide/functions"
--8<-- "python/user-guide/expressions/functions.py:countunique"
```

## 条件式

Polarsは、`when`、`then`、`otherwise`構文で if-else のような条件を式にサポートしています。述語は`when`句に置かれ、これが`true`と評価されると`then`式が適用され、そうでない場合は`otherwise`式が適用されます（行ごとに）。

{{code_block('user-guide/expressions/functions','conditional',['when'])}}

```python exec="on" result="text" session="user-guide/functions"
--8<-- "python/user-guide/expressions/functions.py:conditional"
```
