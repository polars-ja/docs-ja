## 複数のファイルの扱い

Polars は、ニーズとメモリ負荷に応じて、複数のファイルを異なる方法で扱うことができます。

いくつかのファイルを作成して、コンテキストを与えましょう:

{{code_block('user-guide/io/multiple','create',['write_csv'])}}

## 単一の `DataFrame` への読み込み

複数のファイルを単一の `DataFrame` に読み込むには、グロブパターンを使うことができます:

{{code_block('user-guide/io/multiple','read',['read_csv'])}}

```python exec="on" result="text" session="user-guide/io/multiple"
--8<-- "python/user-guide/io/multiple.py:create"
--8<-- "python/user-guide/io/multiple.py:read"
```

これがどのように機能するかを確認するために、クエリプランを見てみましょう。 下記のように、すべてのファイルが個別に読み込まれ、単一の `DataFrame` にコンキャテネートされます。 Polars はこの読み込みを並列化しようとします。

{{code_block('user-guide/io/multiple','graph',['show_graph'])}}

```python exec="on" session="user-guide/io/multiple"
--8<-- "python/user-guide/io/multiple.py:creategraph"
```

## 並列での読み取りと処理

ファイルを単一のテーブルに入れる必要がない場合は、各ファイルのクエリプランを構築し、Polars スレッドプールで並列に実行することもできます。

すべてのクエリプラン実行は完全に並列化されており、通信は必要ありません。

{{code_block('user-guide/io/multiple','glob',['scan_csv'])}}

```python exec="on" result="text" session="user-guide/io/multiple"
--8<-- "python/user-guide/io/multiple.py:glob"
```
