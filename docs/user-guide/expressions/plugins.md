# エクスプレッションプラグイン（Expression plugins）

エクスプレッション プラグインは、ユーザー定義関数を作成するための優先される方法です。
Rust 関数をコンパイルし、それを Polars ライブラリにエクスプレッションとして登録できます。
Polars エンジンはランタイムで関数を動的にリンクし、あなたのエクスプレッションはネイティブのエクスプレッションとほぼ同じ速度で実行されます。
Python の介入なしでこれが機能するため、GIL 競合はありません。

これらはデフォルトのエクスプレッションと同じ利点を享受します：

- 最適化
- 並列処理
- Rust ネイティブのパフォーマンス

カスタムエクスプレッションを作成するために必要なものを見ていきましょう。

## 最初のカスタムエクスプレッション：Pig Latin

最初のエクスプレッションとして、ピグ ラテン変換器を作成します。
ピグ ラテンは、各単語の最初の文字を取り除き、後ろに追加し、最後に "ay" を追加する、愚かな言語です。例えば、「pig」は「igpay」に変換されます。

もちろん、既存のエクスプレッションでもこれを行うことは可能ですが、
専用の関数を使用する方がパフォーマンスが向上し、プラグインについて学ぶ機会にもなります。

### 設定

次のような新しいライブラリを `Cargo.toml` ファイルで始めます。

```toml
[package]
name = "expression_lib"
version = "0.1.0"
edition = "2021"

[lib]
name = "expression_lib"
crate-type = ["cdylib"]

[dependencies]
polars = { version = "*" }
pyo3 = { version = "*", features = ["extension-module", "abi-py38"] }
pyo3-polars = { version = "*", features = ["derive"] }
serde = { version = "*", features = ["derive"] }
```

### エクスプレッションの作成

このライブラリでは、`&str` をピグ ラテンに変換するヘルパー関数を作成し、エクスプレッションとして公開する関数を作成します。
関数を公開するためには、`#[polars_expr(output_type=DataType)]` 属性を追加する必要があり、
関数は常に `inputs: &[Series]` を最初の引数として受け入れる必要があります。

```rust
// src/expressions.rs
use polars::prelude::*;
use pyo3_polars::derive::polars_expr;
use std::fmt::Write;

fn pig_latin_str(value: &str, output: &mut String) {
    if let Some(first_char) = value.chars().next() {
        write!(output, "{}{}ay", &value[1..], first_char).unwrap()
    }
}

#[polars_expr(output_type=String)]
fn pig_latinnify(inputs: &[Series]) -> PolarsResult<Series> {
    let ca = inputs[0].str()?;
    let out: StringChunked = ca.apply_to_buffer(pig_latin_str);
    Ok(out.into_series())
}
```

Rust 側で必要なのはこれだけです。Python 側では、`Cargo.toml` で定義されている名前と同じ名前のフォルダを設定します。
この場合「expression_lib」という名前です。Rust の `src` フォルダと同じディレクトリに `expression_lib` フォルダを作成し、`expression_lib/__init__.py` を作成します。
結果のファイル構造は次のようになります：

```
├── 📁 expression_lib/  # name must match "lib.name" in Cargo.toml
|   └── __init__.py
|
├── 📁src/
|   ├── lib.rs
|   └── expressions.rs
|
├── Cargo.toml
└── pyproject.toml
```

次に、新しいクラス `Language` を作成し、新しい `expr.language` 名前空間のエクスプレッションを保持します。
エクスプレッションの関数名は登録する必要があります。この名前が正確であることが重要です。
そうでないと、主要な Polars パッケージは関数名を解決できません。
さらに、このエクスプレッションがどのように動作するかを説明する追加のキーワード引数を設定できます。
この場合、この関数は要素ごとに動作するため、Polars はこのエクスプレッションをバッチで実行することができます。他の操作ではこれが許されない場合があります。例えば、ソートやスライスの場合です。

```python
# expression_lib/__init__.py
from pathlib import Path
from typing import TYPE_CHECKING

import polars as pl
from polars.plugins import register_plugin_function
from polars.type_aliases: IntoExpr


def pig_latinnify(expr: IntoExpr) -> pl.Expr:
    """Pig-latinnify expression."""
    return register_plugin_function(
        plugin_path=Path(__file__).parent,
        function_name="pig_latinnify",
        args=expr,
        is_elementwise=True,
    )
```

環境に `maturin` をインストールして `maturin develop --release` を実行することで、このライブラリをコンパイルできます。

それだけです。使用する準備が整いました！

```python
import polars as pl
from expression_lib import pig_latinnify

df = pl.DataFrame(
    {
        "convert": ["pig", "latin", "is", "silly"],
    }
)
out = df.with_columns(pig_latin=pig_latinnify("convert"))
```

また、[カスタム名前空間を登録する](https://docs.pola.rs/py-polars/html/reference/api/polars.api.register_expr_namespace.html#polars.api.register_expr_namespace)ことで、次のように記述することができます：

```python
out = df.with_columns(
    pig_latin=pl.col("convert").language.pig_latinnify(),
)
```

## キーワード引数の受け入れ

Polars のエクスプレッションで `kwargs`（キーワード引数）を受け入れたい場合、
Rust の `struct` を定義し、それが `serde::Deserialize` を導出するようにするだけです。

```rust
/// Provide your own kwargs struct with the proper schema and accept that type
/// in your plugin expression.
#[derive(Deserialize)]
pub struct MyKwargs {
    float_arg: f64,
    integer_arg: i64,
    string_arg: String,
    boolean_arg: bool,
}

/// If you want to accept `kwargs`. You define a `kwargs` argument
/// on the second position in you plugin. You can provide any custom struct that is deserializable
/// with the pickle protocol (on the Rust side).
#[polars_expr(output_type=String)]
fn append_kwargs(input: &[Series], kwargs: MyKwargs) -> PolarsResult<Series> {
    let input = &input[0];
    let input = input.cast(&DataType::String)?;
    let ca = input.str().unwrap();

    Ok(ca
        .apply_to_buffer(|val, buf| {
            write!(
                buf,
                "{}-{}-{}-{}-{}",
                val, kwargs.float_arg, kwargs.integer_arg, kwargs.string_arg, kwargs.boolean_arg
            )
                .unwrap()
        })
        .into_series())
}
```

Python 側で kwargs を登録するときに渡すことができます。

```python
def append_args(
    expr: IntoExpr,
    float_arg: float,
    integer_arg: int,
    string_arg: str,
    boolean_arg: bool,
) -> pl.Expr:
    """
    This example shows how arguments other than `Series` can be used.
    """
    return register_plugin_function(
        plugin_path=Path(__file__).parent,
        function_name="append_kwargs",
        args=expr,
        kwargs={
            "float_arg": float_arg,
            "integer_arg": integer_arg,
            "string_arg": string_arg,
            "boolean_arg": boolean_arg,
        },
        is_elementwise=True,
    )
```

## 出力データ型

もちろん、出力データ型は固定される必要はありません。
それらは通常、エクスプレッションの入力タイプに依存します。
これに対応するために、`#[polars_expr()]` マクロに `output_type_func` 引数を提供して、その関数が入力フィールド `&[Field]` を出力 `Field`（名前とデータ型）にマッピングする関数を指します。

以下のスニペットは、このマッピングを補助するユーティリティ `FieldsMapper` を使用する例です。

```rust
use polars_plan::dsl::FieldsMapper;

fn haversine_output(input_fields: &[Field]) -> PolarsResult<Field> {
    FieldsMapper::new(input_fields).map_to_float_dtype()
}

#[polars_expr(output_type_func=haversine_output)]
fn haversine(inputs: &[Series]) -> PolarsResult<Series> {
    let out = match inputs[0].dtype() {
        DataType::Float32 => {
            let start_lat = inputs[0].f32().unwrap();
            let start_long = inputs[1].f32().unwrap();
            let end_lat = inputs[2].f32().unwrap();
            let end_long = inputs[3].f32().unwrap();
            crate::distances::naive_haversine(start_lat, start_long, end_lat, end_long)?
                .into_series()
        }
        DataType::Float64 => {
            let start_lat = inputs[0].f64().unwrap();
            let start_long = inputs[1].f64().unwrap();
            let end_lat = inputs[2].f64().unwrap();
            let end_long = inputs[3].f64().unwrap();
            crate::distances::naive_haversine(start_lat, start_long, end_lat, end_long)?
                .into_series()
        }
        _ => polars_bail!(InvalidOperation: "only supported for float types"),
    };
    Ok(out)
}
```

始めるために知っておくべきことはこれだけです。[このリポジトリ](https://github.com/pola-rs/pyo3-polars/tree/main/example/derive_expression)を見て、どのようにすべてが組み合わさっているかを確認し、
[このチュートリアル](https://marcogorelli.github.io/polars-plugins-tutorial/)でより徹底的な理解を得てください。

## コミュニティ プラグイン

以下は、コミュニティが実装したプラグインの厳選（無尽蔵ではない）リストです。

- [polars-xdt](https://github.com/pola-rs/polars-xdt) メインライブラリの範囲内ではない追加の日付関連機能を備えた
  Polars プラグイン
- [polars-distance](https://github.com/ion-elgreco/polars-distance) Polars プラグイン for pairwaise distance functions
- [polars-ds](https://github.com/abstractqqq/polars_ds_extension) 一般的な数値/文字列データ分析手順を簡素化することを目指した Polars 拡張
- [polars-hash](https://github.com/ion-elgreco/polars-hash) Polars 用の安定した非暗号的および暗号的ハッシュ関数
- [polars-reverse-geocode](https://github.com/MarcoGorelli/polars-reverse-geocode) 与えられた（緯度、経度）ペアに最も近い都市を見つけるための
  オフラインリバースジオコーダー

## その他の資料

- [Ritchie Vink - Polars Pluginsに関する基調講演](https://youtu.be/jKW-CBV7NUM)
- [Polars plugins チュートリアル](https://marcogorelli.github.io/polars-plugins-tutorial/) 簡単で最小限の例を通して
  プラグインの作成方法を学びます
- [cookiecutter-polars-plugin](https://github.com/MarcoGorelli/cookiecutter-polars-plugins) Polars Pluginsのプロジェクトテンプレート
