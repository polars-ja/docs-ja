# JSON ファイル

Polars は、標準の JSON と改行区切り JSON (NDJSON) の両方を読み書きできます。

## 読み込み

### JSON

JSON ファイルの読み込みは、お馴染みの操作です:

{{code_block('user-guide/io/json','read',['read_json'])}}

### 改行区切り JSON

改行で区切られた JSON オブジェクトは、標準の JSON よりも高パフォーマンスな方法で Polars に読み込むことができます。

Polars は `read_ndjson` 関数を使って、NDJSON ファイルを `DataFrame` に読み込むことができます:

{{code_block('user-guide/io/json','readnd',['read_ndjson'])}}

## 書き出し

{{code_block('user-guide/io/json','write',['write_json','write_ndjson'])}}

## スキャン

Polars では、 **改行区切り JSON** の入力を _スキャン_ することができます。スキャンすることで、ファイルの実際の解析を遅延させ、代わりに `LazyFrame` と呼ばれる遅延計算のホルダーを返します。

{{code_block('user-guide/io/json','scan',['scan_ndjson'])}}
