# カラム選択（Column selections）

このセクションで使用するデータセットを作成しましょう：

{{code_block('user-guide/expressions/column-selections','selectors_df',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:setup"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_df"
```

## エクスプレッションの拡張

前のセクションで見たように、`pl.col` メソッドを使用して特定のカラムを選択できます。これは複数のカラムを選択する便利な手段としても、エクスプレッションを _拡張_ する方法としても使用できます。

このような便利な機能は単なる装飾やシンタックスシュガーではありません。コード内で [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) 原則を非常に強力に適用することを可能にします：一つのエクスプレッションが複数のカラムを指定し、DataFrame スキーマに応じてエクスプレッションのリストに拡張され、複数のカラムを選択して計算を実行できます！

### 全部を選択、あるいは一部を除外

`DataFrame` オブジェクトのすべてのカラムを `*` 引数を提供することで選択できます：

{{code_block('user-guide/expressions/column-selections', 'all',['all'])}}

```python exec="on" result="text" session="user-guide/column-selections
--8<-- "python/user-guide/expressions/column-selections.py:all"
```

しばしば、すべてのカラムを含めたいだけでなく、いくつかを除外して含めたいと考えます。これも簡単に行えます：

{{code_block('user-guide/expressions/column-selections','exclude',['exclude'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:exclude"
```

### 複数の文字列による

複数の文字列を指定することで、エクスプレッションが一致するすべてのカラムに _拡張_ されます：

{{code_block('user-guide/expressions/column-selections','expansion_by_names',['dt.to_string'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:expansion_by_names"
```

### 正規表現による

正規表現も使用して複数のカラム選択が可能です。`pl.col` が正規表現選択を期待していることを知らせるために、正規表現を `^` と `$` で囲むことが重要です：

{{code_block('user-guide/expressions/column-selections','expansion_by_regex',[])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:expansion_by_regex"
```

### データタイプによる

`pl.col` は Polars のデータタイプを使用して複数のカラムを選択できます：

{{code_block('user-guide/expressions/column-selections','expansion_by_dtype',['n_unique'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:exp

ansion_by_dtype"
```

## `selectors` の使用

Polars は、カラムの名前、`dtype`、またはその他のプロパティに基づいた直感的なカラム選択も可能で、これは上述の `col` を使用した機能に基づいています。`polars.selectors` を `cs` としてインポートしてエイリアスを設定することを推奨します。

### `dtype` による

ただの整数と文字列のカラムを選択するには：

{{code_block('user-guide/expressions/column-selections','selectors_intro',['selectors'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_intro"
```

### 集合操作を適用する

これらの _selectors_ は集合に基づいた選択操作も許可します。例えば、行番号を示す **最初の** カラムを除く **数値** カラムを選択するには：

{{code_block('user-guide/expressions/column-selections','selectors_diff',['cs.first', 'cs.numeric'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_diff"
```

行番号を名前で、そして任意の **非**数値カラムも選択できます：

{{code_block('user-guide/expressions/column-selections','selectors_union',['cs.by_name', 'cs.numeric'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_union"
```

### パターンと部分文字列による

_Selectors_ は部分文字列と正規表現パターンにもマッチ可能です：

{{code_block('user-guide/expressions/column-selections','selectors_by_name',['cs.contains', 'cs.matches'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_by_name"
```

### エクスプレッションへの変換

選択されたカラムに特定の操作を適用したい場合（つまり、通常のようにそれらを **エクスプレッション** として表現して操作を進めたい場合）、単に `as_expr` を使用して変換し、通常どおり進めることができます：

{{code_block('user-guide/expressions/column-selections','selectors_to_expr',['cs.temporal'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_to_expr"
```

### `selectors` のデバッグ

Polars は、selectors の使用を支援するために役立つ2つのユーティリティ関数を提供します：`is_selector` と `expand_selector`：

{{code_block('user-guide/expressions/column-selections','selectors_is_selector_utility',['is_selector'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_is_selector_utility"
```

特に LazyFrame オブジェクトの場合、どのカラム名が選択されるかを事前に知ることが特に有用です：

{{code_block('user-guide/expressions/column-selections','selectors_colnames_utility',['expand_selector'])}}

```python exec="on" result="text" session="user-guide/column-selections"
--8<-- "python/user-guide/expressions/column-selections.py:selectors_colnames_utility"
```
