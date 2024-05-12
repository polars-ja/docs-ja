# Excel

Polars は Python から Excel ファイルの読み書きができます。
パフォーマンスの観点から、可能であれば Parquet や CSV ファイルなどの他のフォーマットを使うことをお勧めします。

## 読み込み

Polars には Excel リーダーがネイティブに用意されていません。代わりに、Excel ファイルをPolars が解析できるオブジェクトに変換するための外部ライブラリを使用しています。利用可能なエンジンは以下の通りです:

- xlsx2csv: これが現在のデフォルトです。
- openpyxl: xls2csv と比べて通常は遅いですが、解析が難しいファイルに対してより柔軟な対応ができます。
- pyxlsb: バイナリの Excel ファイル (xlsb) の読み込みに使用します。
- fastexcel: このリーダーは [calamine](https://github.com/tafia/calamine) に基づいており、通常最も高速ですが、xls2csv ほどの機能はありません。

fastexcel がデフォルトではありませんが、まずは fastexcel を試してみて、問題がある場合は xlsx2csv や openpyxl を使うことをお勧めします。

これらのエンジンを使うには、対応する Python パッケージをインストールする必要があります。

=== ":fontawesome-brands-python: Python"

    ```shell
    $ pip install xlsx2csv openpyxl pyxlsb fastexcel
    ```

デフォルトの Excel リーダーは xlsx2csv です。
これは Excel ファイルを CSV ファイルに変換し、Polars のネイティブ CSV リーダーでそれを読み込みます。
`read_excel` を使って Excel ファイルを読み込みます:

{{code_block('user-guide/io/excel','read',['read_excel'])}}

`sheet_name` 引数を使って、読み込むシート名を指定できます。シート名を指定しない場合は、最初のシートが読み込まれます。

{{code_block('user-guide/io/excel','read_sheet_name',['read_excel'])}}

## 書き込み

Excel ファイルに書き込むには、追加の依存関係として xlswriter ライブラリをインストールする必要があります。

=== ":fontawesome-brands-python: Python"

    ```shell
    $ pip install xlsxwriter
    ```

Rust Polars では現在 Excel ファイルへの書き込みは利用できませんが、 [このクレート](https://docs.rs/crate/xlsxwriter/latest) を使って Rust から Excel ファイルに書き込むことは可能です。

`DataFrame` を Excel ファイルに書き込むには `write_excel` メソッドを使います:

{{code_block('user-guide/io/excel','write',['write_excel'])}}

ワークシートの名前は `worksheet` 引数で指定できます。

{{code_block('user-guide/io/excel','write_sheet_name',['write_excel'])}}

Polars では、複数のシートや書式設定を持つ豊かな Excel ファイルを作成できます。詳細は `write_excel` の API ドキュメントをご覧ください。
