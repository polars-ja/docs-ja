# ウィンドウ関数（Window functions）

ウィンドウ関数はスーパーパワーを持つエクスプレッションです。これらを使用して、
`select` 式のグループに対して集計を実行できます。その意味を感じ取ってみましょう。
まずはデータセットを作成します。以下のスニペットで読み込まれるデータセットには、ポケモンに関する情報が含まれています。

{{code_block('user-guide/expressions/window','pokemon',['read_csv'])}}

```python exec="on" result="text" session="user-guide/window"
--8<-- "python/user-guide/expressions/window.py:pokemon"
```

## 選択におけるグループ別集計

以下では、異なるカラムをグループ化し、それらに集計を行うウィンドウ関数の使用方法を示します。
これにより、単一のクエリを使用して複数のグループ別操作を並行して実行できます。
集計の結果は元の行に投影されます。したがって、ウィンドウ関数は通常、元のデータフレームと同じサイズの DataFrame を生成します。

ウィンドウ関数が `DataFrame` の行数を変更する場合については後で議論します。

`.over("Type 1")` と `.over(["Type 1", "Type 2"])` を呼び出す方法に注目してください。ウィンドウ関数を使用すると、単一の `select` 呼び出しで異なるグループを集計できます！Rust では、`over()` への引数のタイプはコレクションでなければならないため、1つのカラムのみを使用する場合でも、それを配列で提供する必要があります。

最良の部分は、これによる追加コストは一切ありません。計算されたグループはキャッシュされ、異なる `window` エクスプレッション間で共有されます。

{{code_block('user-guide/expressions/window','group_by',['over'])}}

```python exec="on" result="text" session="user-guide/window"
--8<-- "python/user-guide/expressions/window.py:group_by"
```

## グループごとの操作

ウィンドウ関数は集計以上のことができます。例えば、`group` 内で値を `sort` したい場合、
`col("value").sort().over("group")` と記述し、voilà！グループ別にソートしました！

これをもう少し明確にするために、いくつかの行をフィルターで除外しましょう。

{{code_block('user-guide/expressions/window','operations',['filter'])}}

```python exec="on" result="text" session="user-guide/window"
--8<-- "python/user-guide/expressions/window.py:operations"
```

`Type 1` のカラムにある `Water` グループが連続していないことに注意してください。
その間に `Grass` の2行があります。また、各ポケモンは `Speed` によって昇順でソートされています。
残念ながら、この例では降順でソートしたいのです。幸いなことに、ウィンドウ関数を使用すればこれは簡単に実現できます。

{{code_block('user-guide/expressions/window','sort',['over'])}}

```python exec="on" result="text" session="user-guide/window"
--8<-- "python/user-guide/expressions/window.py:sort"
```

Polars は各グループの位置を追跡し、エクスプレッションを適切な行位置にマッピングします。これは単一の `select` 内で異なるグループに対しても機能します。

ウィンドウエクスプレッションの力は、`group_by -> explode` の組み合わせが不要で、ロジックを単一のエクスプレッションにまとめることができる点です。また、API をよりクリーンにします。適切に使用すると、以下のようになります：

- `group_by` -> グループが集約され、サイズが `n_groups` の DataFrame を期待することを示します
- `over` -> グループ内で何かを計算したいことを示し、特定のケースを除いて元の DataFrame のサイズを変更しません

## グループごとのエクスプレッション結果を DataFrame の行にマッピングする

エクスプレッションの結果がグループごとに複数の値を生成する場合、ウィンドウ関数には値を DataFrame の行にリンクするための3つの戦略があります：

- `mapping_strategy = 'group_to_rows'` -> 各値は1行に割り当てられます。返される値の数は行数に一致する必要があります。

- `mapping_strategy = 'join'` -> 値はリストにまとめられ、そのリストがすべての行に繰り返し表示されます。これはメモリを多く消費する可能性があります。

- `mapping_strategy = 'explode'` -> 値が新しい行に展開されます。この操作は行数を変更します。

## ウィンドウエクスプレッションのルール

ウィンドウエクスプレッションの評価は以下の通りです（`pl.Int32` 列に適用する場合を想定）：

{{code_block('user-guide/expressions/window','rules',['over'])}}

## さらなる例

さらに練習するために、以下のウィンドウ関数を計算してみましょう：

- すべてのポケモンをタイプ別にソートする
- タイプ `"Type 1"` ごとに最初の `3` ポケモンを選択する
- タイプ内のポケモンをスピードの降順でソートし、最初の `3` を `"fastest/group"` として選択する
- タイプ内のポケモンを攻撃力の降順でソートし、最初の `3` を `"strongest/group"` として選択する
- タイプ内のポケモンを名前順にソートし、最初の `3` を `"sorted_by_alphabet"` として選択する

{{code_block('user-guide/expressions/window','examples',['over','implode'])}}

```python exec="on" result="text" session="user-guide/window"
--8<-- "python/user-guide/expressions/window.py:examples"
```
