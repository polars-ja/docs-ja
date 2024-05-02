# ストリーミングインターフェース

lazy APIの追加の利点の1つは、クエリをストリーミング方式で実行できることです。Polarsは一度に全てのデータを処理するのではなく、バッチ処理することで、メモリ以上のデータセットを処理できます。

Polarsにクエリをストリーミングモードで実行させるには、`collect`メソッドに`streaming=True`引数を渡します。

{{code_block('user-guide/concepts/streaming','streaming',['collect'])}}

## いつストリーミングが利用可能か

ストリーミングは現在開発中です。Polarsに任意のlazyクエリをストリーミングモードで実行させることができます。ただし、すべてのlazyオペレーションがストリーミングをサポートしているわけではありません。ストリーミングがサポートされていないオペレーションがある場合、Polarsはノンストリーミングモードでクエリを実行します。

ストリーミングは以下のようなオペレーションでサポートされています:

- `filter`,`slice`,`head`,`tail`
- `with_columns`,`select`
- `group_by`
- `join`
- `unique`
- `sort`
- `explode`,`melt`
- `scan_csv`,`scan_parquet`,`scan_ipc`

この一覧は完全なものではありません。Polarsは活発に開発が進められており、明示的な通知なしに、より多くのオペレーションがストリーミングに対応される可能性があります。

### ストリーミングをサポートするオペレーションの例

クエリのどの部分がストリーミングされるかを確認するには、`explain`メソッドを使用します。以下の例では、クエリプランの検査方法を示しています。クエリプランの詳細については、[Lazy API](https://docs.pola.rs/user-guide/lazy/query-plan/)の章を参照してください。

{{code_block('user-guide/concepts/streaming', 'example',['explain'])}}

```python exec="on" result="text" session="user-guide/streaming"
--8<-- "python/user-guide/concepts/streaming.py:import"
--8<-- "python/user-guide/concepts/streaming.py:streaming"
--8<-- "python/user-guide/concepts/streaming.py:example"
```

### ストリーミングをサポートしないオペレーションの例

{{code_block('user-guide/concepts/streaming', 'example2',['explain'])}}

```python exec="on" result="text" session="user-guide/streaming"
--8<-- "python/user-guide/concepts/streaming.py:import"
--8<-- "python/user-guide/concepts/streaming.py:example2"
```
