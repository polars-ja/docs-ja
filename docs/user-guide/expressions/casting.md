# キャスティング（Casting）

キャスティングは、カラムの基本となる [`DataType`](../concepts/data-types/overview.md) を新しいものに変換します。Polars は Arrow を使用してメモリ内のデータを管理し、変換を行うために [Rust 実装](https://github.com/jorgecarleitao/arrow2) の計算カーネルに依存しています。キャスティングは `cast()` メソッドで利用可能です。

`cast` メソッドには `strict` パラメータが含まれており、これは Polars がソース `DataType` からターゲット `DataType` に変換できない値に遭遇したときの動作を決定します。デフォルトでは `strict=True` で、これは Polars が変換に失敗したことをユーザーに通知し、キャストできなかった値の詳細を提供するエラーを投げることを意味します。一方、`strict=False` の場合、ターゲット `DataType` に変換できない値は暗黙に `null` に変換されます。

## 数値

以下の `DataFrame` は、整数と浮動小数点数の両方を含んでいます。

{{code_block('user-guide/expressions/casting','dfnum',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:setup"
--8<-- "python/user-guide/expressions/casting.py:dfnum"
```

浮動小数点数と整数の間、またはその逆のキャスティング操作を行うには、`cast()` 関数を呼び出せます。

{{code_block('user-guide/expressions/casting','castnum',['cast'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:castnum"
```

小数値を整数にキャストする場合、これらは下向きに丸められることに注意してください。

##### ダウンキャスト

要素に割り当てられたビット数を変更することで、メモリフットプリントを削減することも可能です。例として、以下のコードは `Int64` から `Int16` へ、そして `Float64` から `Float32` へのキャスティングによってメモリ使用量を低減させる方法を示しています。

{{code_block('user-guide/expressions/casting','downcast',['cast'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:downcast"
```

#### オーバーフロー

ダウンキャストを行う際は、選択されたビット数（例えば 64、32、16）がカラムに含まれる最大および最小の数値を収容するのに十分であることを確認することが重要です。例えば、32ビット符号付き整数 (`Int32`) を使用すると、-2147483648 から +2147483647 の範囲の整数を扱うことができますが、`Int8` を使用すると -128 から 127 の整数しか扱うことができません。サイズが小さすぎる `DataType` にキャストしようとすると、Polars によってサポートされていない操作として `ComputeError` が投げられます。

{{code_block('user-guide/expressions/casting','overflow',['cast'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:overflow"
```

`strict` パラメータを `False` に設定することで、オーバーフローするような値を null 値に変換します。

{{code_block('user-guide/expressions/casting','overflow2',['cast'])}}

```python exec="on" result="text" session="user-guide/cast
--8<-- "python/user-guide/expressions/casting.py:overflow2"
```

## 文字列

文字列は数値データ型にキャストでき、その逆も同様です：

{{code_block('user-guide/expressions/casting','strings',['cast'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:strings"
```

列に数値でない値が含まれている場合、Polars は変換エラーの詳細を示す `ComputeError` を投げます。`strict=False` を設定すると、数値でない値を `null` に変換します。

{{code_block('user-guide/expressions/casting','strings2',['cast'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:strings2"
```

## ブール値

ブール値は 1 (`True`) または 0 (`False`) として表現されます。そのため、数値型の `DataType` とブール値の間、またはその逆のキャスティング操作を行うことが可能です。ただし、文字列 (`String`) からブール値へのキャスティングは許可されていません。

{{code_block('user-guide/expressions/casting','bool',['cast'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:bool"
```

## 日付

`Date` や `Datetime` などの時間データ型は、エポックからの日数（`Date`）およびマイクロ秒（`Datetime`）、すなわち UNIX 時間として表されます。したがって、数値型と時間データ型の間でのキャスティングが許可されています。

{{code_block('user-guide/expressions/casting','dates',['cast'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:dates"
```

文字列と `Dates`/`Datetimes` の間で変換する場合、`dt.to_string` と `str.to_datetime` が使用されます。Polars はフォーマットに [chrono format syntax](https://docs.rs/chrono/latest/chrono/format/strftime/index.html) を採用しています。`str.to_datetime` にはタイムゾーン機能をサポートする追加オプションがあります。さらなる情報については、API ドキュメントを参照してください。

{{code_block('user-guide/expressions/casting','dates2',['dt.to_string','str.to_date'])}}

```python exec="on" result="text" session="user-guide/cast"
--8<-- "python/user-guide/expressions/casting.py:dates2"
```
