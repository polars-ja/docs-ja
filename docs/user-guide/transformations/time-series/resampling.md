# リサンプリング

データは以下のいずれかの方法でリサンプリングできます:

- アップサンプリング（データを高頻度にする）
- ダウンサンプリング（データを低頻度にする）
- これらの組み合わせ、例えばまずアップサンプリングしてからダウンサンプリングする

## 低頻度へのダウンサンプリング

Polars では、ダウンサンプリングを `group_by` 操作の特殊なケースとして扱っており、`group_by_dynamic` や `group_by_rolling` を使って行うことができます - [時系列 group by のページを参照してください](rolling.md)。

## 高頻度へのアップサンプリング

30 分間隔のデータを生成する例を見てみましょう:

{{code_block('user-guide/transformations/time-series/resampling','df',['DataFrame','date_range'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/resampling"
--8<-- "python/user-guide/transformations/time-series/resampling.py:setup"
--8<-- "python/user-guide/transformations/time-series/resampling.py:df"
```

アップサンプリングは、新しいサンプリング間隔を定義することで行うことができます。アップサンプリングにより、データがない行が追加されます。そのため、アップサンプリングだけでは null 値が含まれる DataFrame が得られます。これらの null 値は、埋め込み戦略や補間を使って埋めることができます。

### アップサンプリング戦略

この例では、元の 30 分から 15 分にアップサンプリングし、その後 `forward` 戦略を使って null 値を前の非 null 値で置き換えています:

{{code_block('user-guide/transformations/time-series/resampling','upsample',['upsample'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/resampling"
--8<-- "python/user-guide/transformations/time-series/resampling.py:upsample"
```

この例では、代わりに null 値を線形補間で埋めています:

{{code_block('user-guide/transformations/time-series/resampling','upsample2',['upsample','interpolate','fill_null'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/resampling"
--8<-- "python/user-guide/transformations/time-series/resampling.py:upsample2"
```
