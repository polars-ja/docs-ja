# ユーザー定義関数（User-defined functions）

Polars のエクスプレッションは非常に強力で柔軟であるため、
他のライブラリよりもカスタム Python 関数の必要性ははるかに少ないとここまでで納得していただけたかと思います。

それでもなお、エクスプレッションの状態をサードパーティのライブラリに渡す、
または Polars でデータに対してブラックボックス関数を適用する機能が必要です。

このために、以下のエクスプレッションを提供しています:

- `map_batches`
- `map_elements`

## `map_batches` か、それとも `map_elements` か。

これらの関数には、どのように動作するか、そしてその結果としてユーザーにどのようなデータを渡すかという重要な違いがあります。

`map_batches` は、そのままの `Series` を `expression` に渡します。

`map_batches` は、`select` と `group_by` の両式で同じルールに従います。
これは、`Series` が `DataFrame` のカラムを表すことを意味します。 `group_by` 式では、
そのカラムはまだ集約されていないことに注意してください！

`map_batches` の使用例としては、例えばエクスプレッションのカラムをサードパーティのライブラリに渡すことが挙げられます。
以下に、ニューラルネットワークモデルにエクスプレッションカラムを渡す方法を示します。

=== ":fontawesome-brands-python: Python"
[:material-api: `map_batches`](https://docs.pola.rs/py-polars/html/reference/expressions/api/polars.Expr.map_batches.html)

```python
df.with_columns([
    pl.col("features").map_batches(lambda s: MyNeuralNetwork.forward(s.to_numpy())).alias("activations")
])
```

=== ":fontawesome-brands-rust: Rust"

```rust
df.with_columns([
    col("features").map(|s| Ok(my_nn.forward(s))).alias("activations")
])
```

`group_by` 式で `map_batches` を使用するケースは限られています。それはパフォーマンス上の理由からのみ使用され、簡単に誤った結果をもたらす可能性があります。その理由を説明しましょう。

{{code_block('user-guide/expressions/user-defined-functions','dataframe',[])}}

```python exec="on" result="text" session="user-guide/udf"
--8<-- "python/user-guide/expressions/user-defined-functions.py:setup"
--8<-- "python/user-guide/expressions/user-defined-functions.py:dataframe"
```

上のスニペットでは、`"keys"` カラムでグループ化します。つまり、次のようなグループがあります：

```c
"a" -> [10, 7]
"b" -> [1]
```

その後、右への `shift` 操作を適用すると、次のようになるでしょう：

```c
"a" -> [null, 10]
"b" -> [null]
```

それを試してみて、何が得られるかを見てみましょう：

{{code_block('user-guide/expressions/user-defined-functions','shift_map_batches',[])}}

```python exec="on" result="text" session="user-guide/udf"
--8<-- "python/user-guide/expressions/user-defined-functions.py:shift_map_batches"
```

あちゃー、明らかに間違った結果が出ましたね。グループ `"b"` はグループ `"a"` から値を得てしまいました 😵。

これは、集約する前に `map_batches` が関数を適用するため、ひどく間違ってしまったのです。それはつまり、全カラム `[10, 7, 1]` がシフトされて `[null, 10, 7]` になり、その後で集約されたということです。

だから私のアドバイスは、`map_batches` を `group_by` 式で使用しないことです。それが必要であり、何をしているかを知っている場合を除きます。

## `map_elements` を使う

幸い、前の例は `map_elements` で修正できます。 `map_elements` は、その操作のための最小論理要素で動作します。

つまり：

- `select context` -> 単一要素
- `group by context` -> 単一グループ

したがって、`map_elements` を使えば、私たちの例を修正できるはずです：

=== ":fontawesome-brands-python: Python"
[:material-api: `map_elements`](https://docs.pola.rs/py-polars/html/reference/expressions/api/polars.Expr.map_elements.html)

{{code_block('user-guide/expressions/user-defined-functions','map_elements',[])}}

```python exec="on" result="text" session="user-guide/udf"
--8<-- "python/user-guide/expressions/user-defined-functions.py:map_elements"
```

そして観察すると、有効な結果が得られます！ 🎉

## `map_elements` の `select` 式での使用

`select` 式では、`map_elements` エクスプレッションはカラムの要素を Python 関数に渡します。

_注意してください。これは Python を実行しているので、遅くなります。_

このセクションの最初に定義した `DataFrame` で続けて、
`map_elements` 関数の例と同じ目標を達成するためにエクスプレッション
API を使用する反例を見てみましょう。

### カウンターの追加

この例では、グローバルな `counter` を作成し、処理される各要素に整数 `1` を加えます。
各反復で、インクリメントの結果が要素値に追加されます。

> 注：この例は Rust では提供されていません。その理由は、グローバルな `counter` 値が並行評価されるときにデータ競合を引き起こす可能性があるためです。それを `Mutex` でラップして変数を保護することは可能ですが、それは例のポイントを曖昧にすることになります。この場合、Python Global Interpreter Lock のパフォーマンスのトレードオフがいくつかの安全保障を提供します。

{{code_block('user-guide/expressions/user-defined-functions','counter',[])}}

```python exec="on" result="text" session="user-guide/udf"
--8<-- "python/user-guide/expressions/user-defined-functions.py:counter"
```

### 複数のカラム値の組み合わせ

単一の `map_elements` 関数コールで異なるカラムの値にアクセスしたい場合、
`struct` データタイプを作成することができます。このデータタイプは、`struct` 内のフィールドとしてそれらのカラムを収集します。
したがって、`"keys"` と `"values"` のカラムから struct を作成すると、次のような struct 要素が得られます：

```python
[
    {"keys": "a", "values": 10},
    {"keys": "a", "values": 7},
    {"keys": "b", "values": 1},
]
```

Python では、これらは呼び出し元の Python 関数に `dict` として渡され、`field: str` によってインデックスされることができます。Rust では、`Struct` タイプの `Series` を取得します。struct のフィールドはインデックス化され、ダウンキャストすることができます。

{{code_block('user-guide/expressions/user-defined-functions','combine',[])}}

```python exec="on" result="text" session="user-guide/udf"
--8<-- "python/user-guide/expressions/user-defined-functions.py:combine"
```

`Structs` については次のセクションで詳しく説明します。

### 戻り値は？

カスタム Python 関数は Polars にとってブラックボックスです。
ですので、あなたが何を意図しているのかを推測し、最善を尽くして理解しようとする必要があります。

ユーザーとしては、カスタム関数をよりよく利用するために私たちが何をするかを理解することが役立ちます。

データタイプは自動的に推測されます。私たちは最初の非 null 値を待ち、
その値を使用して `Series` のタイプを決定します。

Python の型から Polars のデータタイプへのマッピングは次の通りです：

- `int` -> `Int64`
- `float` -> `Float64`
- `bool` -> `Boolean`
- `str` -> `String`
- `list[tp]` -> `List[tp]` (内部タイプは同じルールで推測)
- `dict[str, [tp]]` -> `struct`
- `Any` -> `object` (これは常に避けてください)

Rust の型のマッピングは次の通りです：

- `i32` または `i64` -> `Int64`
- `f32` または `f64` -> `Float64`
- `bool` -> `Boolean`
- `String` または `str` -> `String`
- `Vec<tp>` -> `List[tp]` (内部タイプは同じルールで推測)
