# `Struct` データ型（The Struct datatype）

Polars の `Struct` は、複数のカラムを扱う際の慣用的な方法です。また、"無料"の操作です。つまり、カラムを `Struct` に移動してもデータのコピーは行われません！

このセクションでは、米国のいくつかの州での映画の平均評価をキャプチャする `DataFrame` から始めましょう。

{{code_block('user-guide/expressions/structs','ratings_df',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:setup"
--8<-- "python/user-guide/expressions/structs.py:ratings_df"
```

## `Struct` 型との遭遇

`Struct` カラムになる一般的な操作は、探索的データ分析でよく使用される `value_counts` 関数です。州がデータにどれだけ登場するかを調べる方法は次のとおりです。

{{code_block('user-guide/expressions/structs','state_value_counts',['value_counts'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:state_value_counts"
```

特にこれまでのツールでは見られなかったデータ型から来る予期せぬ出力です。しかし、困っていません。より馴染みのある出力に戻るためには、`Struct` カラムを構成するカラムに `unnest` するだけです。

{{code_block('user-guide/expressions/structs','struct_unnest',['unnest'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:struct_unnest"
```

!!! note "`value_counts` が `Struct` を返す理由"

    Polars のエクスプレッションは常に `Fn(Series) -> Series` のシグネチャを持ち、エクスプレッションの入出力として複数のカラムを提供するために `Struct` がデータ型として使われます。言い換えると、すべてのエクスプレッションは `Series` オブジェクトを返さなければならず、`Struct` はその要求を満たすのに役立ちます。

## `dict` としての `Structs`

Polars は `Series` コンストラクタに送られた `dict` を `Struct` として解釈します：

{{code_block('user-guide/expressions/structs','series_struct',['Series'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:series_struct"
```

!!! note "`Series` オブジェクトの構築"

    ここでは `Series` が最初に `name`、その後に `values` で構築されていることに注意してください。
    後者を最初に提供することは Polars ではアンチパターンとされ、避けるべきです。

### `Struct` の個々の値を抽出する

上記で作成した `Series` の `movie` 値だけを取得する必要があるとしましょう。その場合、`field` メソッドを使用できます：

{{code_block('user-guide/expressions/structs','series_struct_extract',['struct.field'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:series_struct_extract"
```

### `Struct` の個々のキーをリネームする

`Struct` カラムの個々の `field` をリネームする必要がある場合、まず `rating_series` オブジェクトを `DataFrame` に変換して変更を簡単に確認できるようにし、その後 `rename_fields` メソッドを使用します：

{{code_block('user-guide/expressions/structs','series_struct_rename',['struct.rename_fields'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:series_struct_rename"
```

## `Struct` カラムの実用的な使用例

### 重複行の特定

`ratings` データに戻ります。`Movie` と `Theatre` レベルで重複がある場合を特定したいとします。ここで `Struct` データ型が光ります：

{{code_block('user-guide/expressions/structs','struct_duplicates',['is_duplicated', 'struct'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:struct_duplicates"
```

このレベルでも `is_unique` を使用してユニークなケースを特定できます！

### 複数カラムのランキング

重複があることが分かっている場合、どのランクを優先させるかを決めたいとします。評価の `Count` を `Avg_Rating` 自体よりも重要とし、タイブレークにのみ使用します。次のように行えます：

{{code_block('user-guide/expressions/structs','struct_ranking',['is_duplicated', 'struct'])}}

```python exec="on" result="text" session="user-guide/structs"
--8<-- "python/user-guide/expressions/structs.py:struct_ranking"
```

Polars でとてもエレガントに実現できるかなり複雑な要求のセットです！

### 複数カラム適用の使用

これは前のセクションの _ユーザー定義関数_ で議論されました。
