# Google BigQuery

GBQから読み書りするには、追加の依存関係が必要です:

=== ":fontawesome-brands-python: Python"

```shell
$ pip install google-cloud-bigquery
```

## 読み込み

クエリを `DataFrame` に読み込むことができます:

{{code_block('user-guide/io/bigquery','read',['from_arrow'])}}

## 書き込み
{{code_block('user-guide/io/bigquery','write',[])}}
