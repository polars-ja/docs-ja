## 読み書き

CSV ファイルの読み込みは以下のように行います:

{{code_block('user-guide/io/csv','read',['read_csv'])}}

CSV ファイルの書き出しは `write_csv` 関数を使って以下のように行います:

{{code_block('user-guide/io/csv','write',['write_csv'])}}

## スキャン

Polars では CSV 入力を _スキャン_ することができます。スキャンすることで、ファイルの実際の解析を遅延させ、代わりに遅延計算ホルダーである `LazyFrame` を返します。

{{code_block('user-guide/io/csv','scan',['scan_csv'])}}

なぜこれが望ましいのかについては、Polars の最適化について [こちら](../concepts/lazy-vs-eager.md) で詳しく説明しています。
