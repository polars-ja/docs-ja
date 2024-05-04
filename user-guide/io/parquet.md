# Parquet

Polars の `DataFrame` メモリ上のデータレイアウトが Parquet ファイルのディスク上のレイアウトに多くの点で似ているため、 [`Parquet` ファイル](https://parquet.apache.org/) の読み込みや書き込みは高速です。

CSV とは異なり、Parquet はカラム型のフォーマットです。これは、データがロー単位ではなくカラム単位で格納されることを意味します。これはデータの圧縮と高速なデータアクセスを可能にする、より効率的な方法です。

## 読み込み

`read_parquet` 関数を使って、 `Parquet` ファイルを `DataFrame` に読み込むことができます:

{{code_block('user-guide/io/parquet','read',['read_parquet'])}}

## 書き込み

{{code_block('user-guide/io/parquet','write',['write_parquet'])}}

## スキャン

Polars では、 `Parquet` 入力をスキャンすることができます。スキャンすると、ファイルの実際の解析が遅延され、代わりに `LazyFrame` と呼ばれる遅延計算ホルダーが返されます。

{{code_block('user-guide/io/parquet','scan',['scan_parquet'])}}

なぜこれが望ましいのかについては、Polars の最適化について [こちら](../concepts/lazy-vs-eager.md) で詳しく説明しています。

クラウドに保存された `Parquet` ファイルをスキャンする場合、述語と射影のプッシュダウンを適用することもできます。これにより、ダウンロードする必要のあるデータ量を大幅に削減できます。クラウドストレージからの Parquet ファイルのスキャンについては、[クラウドストレージ](cloud-storage.md/#scanning-from-cloud-storage-with-query-optimisation) をご覧ください。
