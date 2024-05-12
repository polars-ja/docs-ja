# データベース

## データベースから読み込む

Polars は `pl.read_database_uri` および `pl.read_database` 関数を使ってデータベースから読み込むことができます。

### `read_database_uri` と `read_database` の違い

接続文字列（URI）を使ってデータベース接続を指定したい場合は `pl.read_database_uri` を使います。以下のスニペットは、Postgres データベースの `foo` テーブルのすべての列を読み込む例で、URI を使って接続しています:

{{code_block('user-guide/io/database','read_uri',['read_database_uri'])}}

一方、SQLAlchemy のようなライブラリで作成した接続エンジンを使って接続したい場合は `pl.read_database` を使います。

{{code_block('user-guide/io/database','read_cursor',['read_database'])}}

`pl.read_database_uri` は、SQLAlchemy や DBAPI2 接続を使っている場合、 `pl.read_database` よりも高速です。これは、これらの接続ではデータがまずPythonの行単位で読み込まれ、その後列単位のApache Arrowフォーマットにコピーされるためです。

### エンジン

Polars は自身でデータベースからの接続やデータ転送を管理しません。代わりに、外部ライブラリ（「 _エンジン_ 」と呼ばれる）がこれを処理します。

`pl.read_database` を使用する際は、接続オブジェクトを作成するときにエンジンを指定します。`pl.read_database_uri` を使用する際は、2つのエンジンのいずれかを指定してデータベースから読み取ることができます:

- [ConnectorX](https://github.com/sfu-db/connector-x)
- [ADBC](https://arrow.apache.org/docs/format/ADBC.html)

両方のエンジンは Apache Arrow のネイティブサポートを持っているため、データをコピーすることなく Polars の `DataFrame` に直接読み込むことができます。

#### ConnectorX

ConnectorX はデフォルトのエンジンで、Postgres、Mysql、SQL Server、Redshift など[多数のデータベースをサポート](https://github.com/sfu-db/connector-x#sources)しています。ConnectorX は Rust で書かれており、Polars への zero-copy を可能にするために Arrow 形式でデータを保存します。

`ConnectorX` を使ってサポートされているデータベースから読み取るには、Polars をインストールする際に追加の依存関係 `ConnectorX` を有効にするか、手動で以下のようにインストールする必要があります:

```shell
$ pip install connectorx
```

#### ADBC

ADBC（Arrow Database Connectivity）は、Apache Arrow プロジェクトでサポートされているエンジンです。ADBC は、データベースに接続するための API 標準と、この標準を実装したさまざまな言語のライブラリを目指しています。

ADBC はまだ初期段階なので、さまざまなデータベースへの対応は限られています。現時点では、ADBC のドライバーは [Postgres](https://pypi.org/project/adbc-driver-postgresql/)、[SQLite](https://pypi.org/project/adbc-driver-sqlite/)、[Snowflake](https://pypi.org/project/adbc-driver-snowflake/) でのみ利用可能です。ADBC をインストールするには、お使いのデータベース用のドライバーをインストールする必要があります。例えば、SQLite 用のドライバーをインストールするには、以下のように実行します:

```shell
$ pip install adbc-driver-sqlite
```

ADBC がデフォルトのエンジンではないため、`pl.read_database_uri` の引数でエンジンを指定する必要があります。

{{code_block('user-guide/io/database','adbc',['read_database_uri'])}}

## データベースへの書き込み

Polars を使ってデータベースに書き込むには、`pl.write_database` 関数を使います。

### エンジン

上記のデータベースからの読み込みと同様に、Polars はデータベースへの書き込みにも _エンジン_ を使います。現在サポートされているエンジンは以下の通りです:

- [SQLAlchemy](https://www.sqlalchemy.org/)
- Arrow Database Connectivity (ADBC)

#### SQLAlchemy

デフォルトの SQLAlchemy エンジンを使えば、SQLAlchemy がサポートするあらゆるデータベースに書き込むことができます。このエンジンを使うには、SQLAlchemy と Pandas をインストールする必要があります。

```shell
$ pip install SQLAlchemy pandas
```

この例では、`DataFrame` を `records` というテーブルにデータベースに書き込みます。

{{code_block('user-guide/io/database','write',['write_database'])}}

SQLAlchemy アプローチでは、Polars が `DataFrame` を PyArrow 支援の Pandas `DataFrame` に変換し、その後 Pandas `DataFrame` の SQLAlchemy メソッドを使ってデータベースに書き込みます。

#### ADBC

ADBC を使ってデータベースに書き込むこともできます。書き込みは、ADBC で読み取りがサポートされているデータベースと同じものでサポートされています。上述のように、お使いのデータベース用の適切な ADBC ドライバをインストールする必要があります。

{{code_block('user-guide/io/database','write_adbc',['write_database'])}}
