# インストール

Polars はライブラリであり、インストールは対応するプログラミング言語のパッケージマネージャーを呼び出すだけで簡単です。

=== ":fontawesome-brands-python: Python"

    ``` bash
    pip install polars

    # Or for legacy CPUs without AVX2 support
    pip install polars-lts-cpu
    ```

=== ":fontawesome-brands-rust: Rust"

    ``` shell
    cargo add polars -F lazy

    # Or Cargo.toml
    [dependencies]
    polars = { version = "x", features = ["lazy", ...]}
    ```

### Big Index

デフォルトでは、Polars は 2^32 行（~42億行）に制限されています。この制限を 2^64 行（~18千兆行）まで増やすには、big index を有効にする必要があります:

=== ":fontawesome-brands-python: Python"

    ``` bash
    pip install polars-u64-idx
    ```

=== ":fontawesome-brands-rust: Rust"

    ``` shell
    cargo add polars -F bigidx

    # Or Cargo.toml
    [dependencies]
    polars = { version = "x", features = ["bigidx", ...] }
    ```

### レガシーな CPU

[AVX](https://ja.wikipedia.org/wiki/Advanced_Vector_Extensions) をサポートしていない古い CPU でPolarsをインストールするには:

=== ":fontawesome-brands-python: Python"

    ``` bash
    pip install polars-lts-cpu
    ```

## インポート

ライブラリを使用するには、プロジェクトにインポートする必要があります。

=== ":fontawesome-brands-python: Python"

    ``` python
    import polars as pl
    ```

=== ":fontawesome-brands-rust: Rust"

    ``` rust
    use polars::prelude::*;
    ```

## Feature Flags

上記のコマンドを使用すると、Polars のコアな機能がシステムにインストールされます。ただしユースケースによっては、オプションの依存関係もインストールしたい場合があります。これらは最小限のフットプリントを維持するために省略可能になっています。フラグはプログラミング言語によって異なります。ユーザーガイドを通して、追加の依存関係を必要とする機能が使われる場合は言及します。

### Python

```text
# For example
pip install 'polars[numpy,fsspec]'
```

| Tag        | Description                                                                                                                           |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| all        | すべてのオプション（以下のすべて）の依存関係をインストールします                                                                              |
| pandas     | Pandas の DataFrame や Series との相互変換のために Pandas と一緒にインストールします                                                          |
| numpy      | numpy 配列との相互変換のために numpy と一緒にインストールします                                                                       |
| pyarrow    | PyArrow を使ってデータ形式を読み込みます                                                        |
| fsspec     | リモートファイルシステムからの読み込みをサポートします                       |
| connectorx | SQL データベースからの読み込みをサポートします                                               |
| xlsx2csv   | Excel ファイルからの読み込みをサポートします                                                                                                  |
| deltalake  | Delta Lake テーブルからの読み込みをサポートします                                    |
| plot       | DataFrame のプロットをサポートします                                                                |
| timezone   | タイムゾーンをサポートします。Python 3.9 未満、またはWindowsの場合にのみ必要です。それ以外の場合は依存関係はインストールされません。 |

### Rust

```toml
# Cargo.toml
[dependencies]
polars = { version = "0.26.1", features = ["lazy", "temporal", "describe", "json", "parquet", "dtype-datetime"] }
```

オプションの機能は以下の通りです:

<!-- dprint-ignore-start -->

- 追加のデータ型:
    - `dtype-date`
    - `dtype-datetime`
    - `dtype-time`
    - `dtype-duration`
    - `dtype-i8`
    - `dtype-i16`
    - `dtype-u8`
    - `dtype-u16`
    - `dtype-categorical`
    - `dtype-struct`
- `lazy` - Lazy API
    - `regex` - [カラム選択](crate::lazy::dsl::col)で正規表現を使う。
    - `dot_diagram` - 遅延論理計画からドット図を作成。
- `sql` - SQL クエリを Polars に渡す。
- `streaming` - RAM よりも大きいデータセットを処理できるようになる。
- `random` - 値がランダムにサンプリングされた配列を生成。
- `ndarray`- `DataFrame` を `ndarray` に変換。
- `temporal` - 時間データ型の[Chrono](https://docs.rs/chrono/)と Polars の間の変換。
- `timezones` - タイムゾーンのサポートを有効化。
- `strings` - `StringChunked` のための追加の文字列ユーティリティ。
    - `string_pad` - `pad_start`, `pad_end`, `zfill`
    - `string_to_integer` - `parse_int`
- `object` - `ObjectChunked<T>` (`T` に対しジェネリック)と呼ばれるジェネリックな ChunkedArrays に対するサポート
  これらは [Any](https://doc.rust-lang.org/std/any/index.html) トレイトを通じてSeries からダウンキャストが可能。
- パフォーマンスに関連するもの:
    - `nightly` - SIMD や Specialization のような最新ビルドのみの機能を有効化。
    - `performant` - より高速なパスを行うが、コンパイル時間が遅くなる。
    - `bigidx` -  2^32行を大幅に超えることが予想される場合はこの機能を有効化。
    インデックスに`u64`を使うことで、はるかに大規模なデータセットにスケールアップが可能。
    この機能を有効にすると、多くのデータ構造がキャッシュ効率が低下するため、
    Polarsのパフォーマンスが少し低下する。
    - `cse` - 共通部分式除去の最適化を有効化。
- IO に関するもの:
    - `serde` - [serde](https://crates.io/crates/serde) によるシリアライズとデシリアライズをサポート。
    - `serde-lazy` - [serde](https://crates.io/crates/serde) によるシリアライズとデシリアライズをサポート。
    JSON などの serde 対応のシリアライズフォーマットで使用可能。
    - `parquet` - Apache Parquet フォーマットの読み込み
    - `json` - JSON のシリアライズ
    - `ipc` - Arrow's IPC フォーマットのシリアライズ
    - `decompress` - csvの圧縮形式を自動的に推測し、解凍。

- サポートする圧縮形式:
    - zip
    - gzip

- `DataFrame` の操作:
    - `dynamic_group_by` - 事前に定義されたキーではなく、時間窓に基づいてグループ化。
    ローリング窓のグループ化操作も有効化。
    - `sort_multiple` - 複数カラムの `DataFrame` のソートを許可。
    - `rows` - 行からDataFrameを作成し、DataFrameから行を抽出。
    また `pivot` と `transpose` の操作も有効化。
    - `join_asof` - 完全一致ではなく、最近傍のキーで結合する Join ASOF を提供。
    - `cross_join` - 2つの DataFrame のデカルト積を作成
    - `semi_anti_join` - SEMI JOIN と ANTI JOIN を提供。
    - `row_hash` - DataFrame の行を UInt64Chunked にハッシュする機能
    - `diagonal_concat` - 異なるスキーマの DataFrame を対角方向に結合。
    - `dataframe_arithmetic` - (DataFrame と DataFrame)や(DataFrame　と　Series)の演算
    - `partition_by` - グループごとに DataFrame を複数に分割
- `Series`/エクスプレッション の操作:
    - `is_in` - [`Series` のメンバーシップをチェックします](crate::chunked_array::ops::IsIn)
    - `zip_with` - [2つの Series/ ChunkedArrays を zip 化します](crate::chunked_array::ops::ChunkZip)
    - `round_series` - `Series` の浮動小数点型を丸める。
    - `repeat_by` - 別の配列で指定された回数だけ要素を繰り返する。
    - `is_first_distinct` - 要素が最初の一意の値かどうかをチェック。
    - `is_last_distinct` - 要素が最後の一意の値かどうかをチェック。
    - `checked_arithmetic` - 無効な演算に `None` を返す検査付き演算。
    - `dot_product` - `Series`とエクスプレッションの内積。
    - `concat_str` - 線形時間での文字列データの連結。
    - `reinterpret` - 符号付き/符号なしへのビット再解釈ユーティリティ
    - `take_opt_iter` - `Series` から `Iterator<Item=Option<usize>>` を取得する
    - `mode` - [最も頻出する値（または複数の値）を返します](crate::chunked_array::ops::ChunkUnique::mode)
    - `cum_agg` - cum_sum、cum_min、cum_max といった集約。
    - `rolling_window` - ローリング平均などのローリング窓関数
    - `interpolate` [`None`値を補間します](crate::chunked_array::ops::Interpolate)
    - `extract_jsonpath` - [StringChunked で JSONPath クエリを実行する](https://goessner.net/articles/JsonPath/)
    - `list` - リストのユーティリティ。
      - `list_gather` 複数のインデックスでサブリストを取得。
    - `rank` - ランキングアルゴリズム。
    - `moment` - 尖度や歪度の統計量
    - `ewma` - 指数平滑移動平均の窓関数
    - `abs` - `Series`の絶対値の取得
    - `arange` - `Series`での範囲操作
    - `product` - `Series`の積を計算。
    - `diff` - `diff` 操作。
    - `pct_change` - 変化率を計算。
    - `unique_counts` - 式の一意の値をカウントする。
    - `log` - `Series`の対数。
    - `list_to_struct` - `List` を `Struct` データ型に変換する。
    - `list_count` - リスト内の要素をカウントする。
    - `list_eval` - リスト要素に式を適用する。
    - `cumulative_eval` - 累積的に増加する窓に式を適用する。
    - `arg_where` - 条件を満たすインデックスを取得する。
    - `search_sorted` - 順序を維持するように要素を挿入すべき位置を見つける。
    - `date_offset` 月や閏年を考慮して日付にオフセットを追加する。
    - `trigonometry` 三角関数。
    - `sign` `Series`の要素ごとの符号を計算する。
    - `propagate_nans` NaN伝播型のmin/max集計。
- `DataFrame`の整形出力
    - `fmt` - `DataFrame` の書式設定を有効化する

<!-- dprint-ignore-end -->
