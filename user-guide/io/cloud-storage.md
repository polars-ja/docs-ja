# クラウドストレージ

Polars は AWS S3、Azure Blob Storage、Google Cloud Storage の読み書きが可能です。 これらの3つのストレージプロバイダに対するAPIは同じです。

クラウドストレージから読み取る場合、ユースケースやクラウドストレージプロバイダによっては、追加の依存関係が必要になる可能性があります。

=== ":fontawesome-brands-python: Python"

    ```shell
    $ pip install fsspec s3fs adlfs gcsfs
    ```

=== ":fontawesome-brands-rust: Rust"

    ```shell
    $ cargo add aws_sdk_s3 aws_config tokio --features tokio/full
    ```

## クラウドストレージからの読み込み

Polars は、eager モードで CSV、IPC、または Parquet ファイルをクラウドストレージから読み込むことができます。

{{code_block('user-guide/io/cloud-storage','read_parquet',['read_parquet','read_csv','read_ipc'])}}

この eager クエリは、ファイルをメモリ内のバッファーにダウンロードし、そこから `DataFrame` を作成します。Polars は内部で `fsspec` を使ってこのダウンロードを管理しており、すべてのクラウドストレージプロバイダーに対応しています。

## クラウドストレージからのクエリ最適化付きスキャン

Polars は、クラウドストレージから Parquet ファイルをレイジーモードでスキャンできます。ソースURLの他に、認証情報やストレージリージョンなどの詳細を提供する必要があるかもしれません。 Polarsは環境変数でこれらを検索しますが、 `storage_options` 引数として `dict` を渡すこともできます。

{{code_block('user-guide/io/cloud-storage','scan_parquet',['scan_parquet'])}}

このクエリは、ファイルをダウンロードせずに `LazyFrame` を作成します。 `LazyFrame` では、スキーマなどのファイルメタデータにアクセスできます。 Polars は内部で `object_store.rs` ライブラリを使ってクラウドストレージプロバイダとのインターフェースを管理しているため、クラウド Parquet ファイルをスキャンするためにPythonで追加の依存関係は必要ありません。

[述語と射影のプッシュダウン](../lazy/optimizations.md)を使ってレイジークエリを作成すると、ファイルがダウンロードされる前にクエリオプティマイザーが適用します。これにより、ダウンロードする必要のあるデータ量を大幅に削減できます。クエリの評価は `collect` を呼び出すことで開始されます。

{{code_block('user-guide/io/cloud-storage','scan_parquet_query',[])}}

## Pythonアロー(PyArrow)によるスキャン

PyArrowを使ってクラウドストレージからスキャンすることもできます。これは、Hiveパーティショニングなどのパーティション化されたデータセットに特に便利です。

まず、PyArrowデータセットを作成し、その後にデータセットから`LazyFrame`を作成します。

{{code_block('user-guide/io/cloud-storage','scan_pyarrow_dataset',['scan_pyarrow_dataset'])}}

## クラウドストレージへの書き込み

Python で s3fs (S3 用)、adlfs (Azure Blob Storage 用)、gcsfs (Google Cloud Storage 用) を使って、`DataFrame` をクラウドストレージに書き込むことができます。この例では、Parquet ファイルを S3 に書き込みます。

{{code_block('user-guide/io/cloud-storage','write_parquet',['write_parquet'])}}
