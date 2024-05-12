# Numpy

Polars のエクスプレッションは NumPy [ufuncs（ユニバーサルファンクション）](https://numpy.org/doc/stable/reference/ufuncs.html) をサポートしています。すべてのサポートされている NumPy 関数のリストについては、[こちら](https://numpy.org/doc/stable/reference/ufuncs.html#available-ufuncs)を参照してください。

これは、Polars が提供していない関数がある場合、NumPy を使用できることを意味し、NumPy API を通じて高速な列操作が可能であることを意味します。

### 例

{{code_block('user-guide/expressions/numpy-example',api_functions=['DataFrame','np.log'])}}

```python exec="on" result="text" session="user-guide/numpy"
--8<-- "python/user-guide/expressions/numpy-example.py"
```

### 相互運用性

Polars `Series` は NumPy ユニバーサルファンクション（ufuncs）をサポートしています。`np.exp()`、`np.cos()`、`np.div()` などの要素ごとの関数は、ほとんどオーバーヘッドなしで動作します。

ただし、Polars 固有の注記として：欠損値は別のビットマスクであり、NumPy には見えません。これにより、窓関数や `np.convolve()` が不完全な結果や誤った結果をもたらすことがあります。

Polars `Series` を NumPy 配列に変換するには、`.to_numpy()` メソッドを使用します。変換中に欠損値は `np.nan` に置き換えられます。
