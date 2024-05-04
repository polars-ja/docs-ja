# フィルタリング

日付列のフィルタリングは、`.filter` メソッドを使って他の列タイプと同じように動作します。

Polars は Python の標準の `datetime`、`date`、`timedelta` を使って、`pl.Datetime`、`pl.Date`、`pl.Duration` データ型間の等価比較を行います。

次の例では、Apple の株価時系列データを使います。

{{code_block('user-guide/transformations/time-series/filter','df',['read_csv'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/filter"
--8<-- "python/user-guide/transformations/time-series/filter.py:df"
```

## 単一の日付でのフィルタリング

希望の日付文字列を `Date` オブジェクトにキャストすることで、単一の日付でフィルタリングできます:

{{code_block('user-guide/transformations/time-series/filter','filter',['filter'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/filter"
--8<-- "python/user-guide/transformations/time-series/filter.py:filter"
```

ここでは、大文字の `Datetime` データ型ではなく、小文字の `datetime` メソッドを使用していることに注意してください。

## 日付範囲でのフィルタリング

開始日と終了日を使って `is_between` メソッドを使うことで、日付範囲でフィルタリングできます:

{{code_block('user-guide/transformations/time-series/filter','range',['filter','is_between'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/filter"
--8<-- "python/user-guide/transformations/time-series/filter.py:range"
```

## 負の日付でのフィルタリング

考古学者と一緒に仕事をしていて、負の日付を扱っているとします。
Polars はそれらを問題なく解析して保存できますが、Python の `datetime` ライブラリでは対応できません。
そのため、フィルタリングには `.dt` 名前空間の属性を使用する必要があります:

{{code_block('user-guide/transformations/time-series/filter','negative',['str.to_date'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/filter"
--8<-- "python/user-guide/transformations/time-series/filter.py:negative"
```
