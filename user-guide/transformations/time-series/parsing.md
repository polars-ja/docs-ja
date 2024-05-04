# 解析

Polars には、時系列データの解析や、時間単位のグループ化やリサンプリングなどの高度な操作をサポートする機能が組み込まれています。

## データ型

Polars には以下のような日時データ型が用意されています:

- `Date`: 日付表現、例: 2014-07-08。内部的には UNIX エポックからの経過日数を 32 ビット符号付き整数で表現しています。
- `Datetime`: 日時表現、例: 2014-07-08 07:00:00。内部的には UNIX エポックからの経過時間を 64 ビット整数で表現しており、ns、us、ms などの単位を持つことができます。
- `Duration`: `Date/Datetime` の差分として生成される時間差型。Python の `timedelta` に似ています。
- `Time`: 時間表現、内部的には午前 0 時からの経過ナノ秒数で表現されます。

## ファイルからの日付解析

CSV ファイルからデータを読み込む際、`try_parse_dates` フラグを `True` に設定すると、Polars は日付と時刻の解析を試みます。

{{code_block('user-guide/transformations/time-series/parsing','df',['read_csv'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/parsing"
--8<-- "python/user-guide/transformations/time-series/parsing.py:setup"
--8<-- "python/user-guide/transformations/time-series/parsing.py:df"
```

一方、Parquet のようなバイナリ形式は、Polars によって尊重されるスキーマを持っています。

## 文字列を日付に変換する

文字列でエンコードされた日時のカラムを、日時型に変換することもできます。これを行うには、文字列の `str.to_date` メソッドを呼び出し、日付文字列のフォーマットを渡します:

{{code_block('user-guide/transformations/time-series/parsing','cast',['read_csv','str.to_date'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/parsing"
--8<-- "python/user-guide/transformations/time-series/parsing.py:cast"
```

[フォーマット文字列の仕様は こちら](https://docs.rs/chrono/latest/chrono/format/strftime/index.html) で確認できます。

## 日付カラムから日付の特徴を抽出する

日付カラムから、年や日などの日付の特徴を抽出することができます。これには、日付カラムの `.dt` 名前空間を使います:

{{code_block('user-guide/transformations/time-series/parsing','extract',['dt.year'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/parsing"
--8<-- "python/user-guide/transformations/time-series/parsing.py:extract"
```

## 混在するオフセット

オフセットが混在している場合 (例えば、夏時間の変更によって)、`utc=True` を使い、その後自分のタイムゾーンに変換することができます:

{{code_block('user-guide/transformations/time-series/parsing','mixed',['str.to_datetime','dt.convert_time_zone'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/parsing"
--8<-- "python/user-guide/transformations/time-series/parsing.py:mixed"
```
