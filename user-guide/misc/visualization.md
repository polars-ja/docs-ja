# 可視化

Polars の `DataFrame` 内のデータは、一般的な可視化ライブラリを使用して可視化することができます。

ここでは、Iris データセットを使用してプロット機能を示します。CSV をスキャンし、`species` カラムでグループ化を行い、`petal_length` の平均を取得します。

{{code_block('user-guide/misc/visualization','dataframe',[])}}

```python exec="on" result="text" session="user-guide/misc/visualization"
--8<-- "python/user-guide/misc/visualization.py:dataframe"
```

## hvPlot による組み込みのプロット

Polars には [hvPlot](https://hvplot.holoviz.org/) を使用してインタラクティブなプロットを作成するための `plot` メソッドがあります。

{{code_block('user-guide/misc/visualization','hvplot_show_plot',[])}}

```python exec="on" session="user-guide/misc/visualization"
--8<-- "python/user-guide/misc/visualization.py:hvplot_make_plot"
```

## Matplotlib

棒グラフを作成するには、DataFrame の各カラムを Matplotlib に Series として直接渡すことができます。Matplotlib は Polars オブジェクトを明示的にサポートしていませんが、Polars の Series を受け入れることができます。これは、null 値がないデータは Series をゼロコピーで numpy 配列に変換できるためです。


{{code_block('user-guide/misc/visualization','matplotlib_show_plot',[])}}

```python exec="on" session="user-guide/misc/visualization"
--8<-- "python/user-guide/misc/visualization.py:matplotlib_make_plot"
```

## Seaborn, Plotly & Altair

[Seaborn](https://seaborn.pydata.org/)、[Plotly](https://plotly.com/) 、[Altair](https://altair-viz.github.io/) は [Dataframe 変換プロトコル](https://data-apis.org/dataframe-api/)を活用して Polars の `DataFrame` を受け入れることができます。これにより、可能な場合はゼロコピー変換が提供されます。

### Seaborn

{{code_block('user-guide/misc/visualization','seaborn_show_plot',[])}}

```python exec="on" session="user-guide/misc/visualization"
--8<-- "python/user-guide/misc/visualization.py:seaborn_make_plot"
```

### Plotly

{{code_block('user-guide/misc/visualization','plotly_show_plot',[])}}

```python exec="on" session="user-guide/misc/visualization"
--8<-- "python/user-guide/misc/visualization.py:plotly_make_plot"
```

### Altair

{{code_block('user-guide/misc/visualization','altair_show_plot',[])}}

```python exec="on" session="user-guide/misc/visualization"
--8<-- "python/user-guide/misc/visualization.py:altair_make_plot"
```
