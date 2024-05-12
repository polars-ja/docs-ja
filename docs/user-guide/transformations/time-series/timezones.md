---
hide:
  - toc
---

# タイムゾーン

!!! quote "Tom Scott"

    タイムゾーンを扱うべきではありません。できる限り避けましょう。

`Datetime` データ型には、タイムゾーンを関連付けることができます。
有効なタイムゾーンの例は以下のとおりです:

- `None`: タイムゾーンなし、「タイムゾーン無意識」とも呼ばれます。
- `UTC`: 協定世界時 (Coordinated Universal Time)。
- `Asia/Kathmandu`: 「エリア/場所」形式のタイムゾーン。
  利用可能なタイムゾーンについては、[tz database time zones のリスト](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)を参照してください。

注意: +02:00 のような固定オフセットは、タイムゾーンの処理には適していません。上記の「エリア/場所」形式を使うことをお勧めします。これにより、タイムゾーンをより効果的に管理できます。

`Datetime` には単一のタイムゾーンしか設定できないため、複数のタイムゾーンを持つ列を作ることはできません。複数のオフセットのデータを解析する場合は、`utc=True` を渡して、すべてを共通のタイムゾーン (UTC) に変換することをお勧めします。詳しくは [日付と時刻の解析](parsing.md) をご覧ください。

タイムゾーンの設定と変換の主な方法は以下のとおりです:

- `dt.convert_time_zone`: 1 つのタイムゾーンから別のタイムゾーンに変換します。
- `dt.replace_time_zone`: タイムゾーンを設定/解除/変更します。

一般的な操作の例を見てみましょう:

{{code_block('user-guide/transformations/time-series/timezones','example',['str.to_datetime','dt.replace_time_zone'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/timezones"
--8<-- "python/user-guide/transformations/time-series/timezones.py:setup"
--8<-- "python/user-guide/transformations/time-series/timezones.py:example"
```

{{code_block('user-guide/transformations/time-series/timezones','example2',['dt.convert_time_zone','dt.replace_time_zone'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/timezones"
--8<-- "python/user-guide/transformations/time-series/timezones.py:example2"
```
