# グループ化

## 固定ウィンドウによるグループ化

`group_by_dynamic` を使って、日/月/年などのテンポラル統計を計算することができます。

### 年間平均の例

以下の簡単な例では、Apple の株価の年間平均終値を計算します。まずはCSVからデータを読み込みます:

{{code_block('user-guide/transformations/time-series/rolling','df',['upsample'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/rolling"
--8<-- "python/user-guide/transformations/time-series/rolling.py:setup"
--8<-- "python/user-guide/transformations/time-series/rolling.py:df"
```

!!! info

    日付は昇順にソートされている必要があります - そうでない場合、`group_by_dynamic` の出力は正しくありません!

年間平均終値を得るには、`group_by_dynamic` に以下のように指定します:

- `Date` 列で年単位(`1y`)でグループ化する
- `Close` 列の平均値を各年について取る

{{code_block('user-guide/transformations/time-series/rolling','group_by',['group_by_dynamic'])}}

年間平均終値は以下のようになります:

```python exec="on" result="text" session="user-guide/transformations/ts/rolling"
--8<-- "python/user-guide/transformations/time-series/rolling.py:group_by"
```

### `group_by_dynamic`のパラメーター

動的ウィンドウは以下のように定義されます:

- **every**: ウィンドウの間隔を示します
- **period**: ウィンドウの期間を示します
- **offset**: ウィンドウの開始をオフセットするのに使用できます

`every`の値は、グループの開始頻度を設定します。時間期間の値は柔軟です - 例えば、`1y`を`2y`に置き換えることで、2年間隔の平均を取ることができます。また、`1y`を`1y6mo`に置き換えることで、18ヶ月間隔の平均を取ることができます。

`period`パラメーターを使って、各グループの時間期間の長さを設定することもできます。例えば、`every`パラメーターを`1y`に、`period`パラメーターを`2y`に設定すると、1年間隔でそれぞれ2年間のグループが作成されます。

`period`パラメーターが指定されない場合は、`every`パラメーターと同じ値に設定されます。つまり、`every`パラメーターが`1y`に設定されている場合、各グループも`1y`のスパンになります。

_**every**_と_**period**_が等しくなる必要がないため、非常に柔軟な方法でたくさんのグループを作成できます。グループが重複したり、境界線が空いたりする可能性があります。

いくつかのパラメーター組み合わせでのウィンドウの様子を見てみましょう。退屈な例から始めましょう。🥱

- every: 1 day -> `"1d"`
- period: 1 day -> `"1d"`

```text
この操作は同じサイズの隣接するウィンドウを作成します
|--|
   |--|
      |--|
```

- every: 1 day -> `"1d"`
- period: 2 days -> `"2d"`

```text
これらのウィンドウには 1 日の重複があります
|----|
   |----|
      |----|
```

- every: 2 days -> `"2d"`
- period: 1 day -> `"1d"`

```text
これではウィンドウの間に隙間ができます
これらの隙間のデータポイントは、どのグループにも属しません
|--|
       |--|
              |--|
```

#### `truncate`

`truncate` パラメーターは、出力の各グループに関連付けられる datetime 値を決定する Boolean 変数です。上記の例では、最初のデータポイントが 1981 年 2 月 23 日です。`truncate = True`（デフォルト）の場合、年間平均の最初の年の日付は 1981 年 1 月 1 日になります。一方、`truncate = False` の場合、年間平均の最初の年の日付は 1981 年 2 月 23 日の最初のデータポイントの日付になります。`truncate` は `Date` 列に表示される内容にのみ影響し、ウィンドウの境界には影響しません。

### `group_by_dynamic` での式の使用

グループ化操作では、`mean` のような単純な集計だけでなく、Polars で利用可能な全ての式を使用することができます。

以下のスニペットでは、2021 年の **毎日** (`"1d"`) の `date range` を作成し、これを `DataFrame` に変換しています。

その後、`group_by_dynamic` で **毎月** (`"1mo"`) 始まる動的ウィンドウを作成し、ウィンドウ長を `1` か月に設定しています。これらの動的ウィンドウに一致する値は、そのグループに割り当てられ、強力な式 API を使って集計することができます。

以下の例では、`group_by_dynamic` を使って以下を計算しています:

- 月末までの残り日数
- 月の日数

{{code_block('user-guide/transformations/time-series/rolling','group_by_dyn',['group_by_dynamic','DataFrame.explode','date_range'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/rolling"
--8<-- "python/user-guide/transformations/time-series/rolling.py:group_by_dyn"
```

## ローリングウィンドウによるグループ化

ローリング操作 `rolling` は、`group_by`/`agg` コンテキストへの別のアクセス方法です。しかし、`group_by_dynamic` とは異なり、ウィンドウは `every` と `period` というパラメーターで固定されるのではありません。`rolling` では、ウィンドウは全く固定されていません! `index_column` の値によって決まります。

例えば、時間列に `{2021-01-06, 2021-01-10}` の値があり、`period="5d"` の場合、以下のようなウィンドウが作成されます:

```text
2021-01-01   2021-01-06
    |----------|

       2021-01-05   2021-01-10
             |----------|
```

ローリンググループ化のウィンドウは常に `DataFrame` 列の値によって決まるため、グループの数は常に元の `DataFrame` と同じになります。

## グループ化操作の組み合わせ

ローリングおよびダイナミックなグループ化操作は、通常のグループ化操作と組み合わせることができます。

以下は、ダイナミックなグループ化を使った例です。

{{code_block('user-guide/transformations/time-series/rolling','group_by_roll',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/rolling"
--8<-- "python/user-guide/transformations/time-series/rolling.py:group_by_roll"
```

{{code_block('user-guide/transformations/time-series/rolling','group_by_dyn2',['group_by_dynamic'])}}

```python exec="on" result="text" session="user-guide/transformations/ts/rolling"
--8<-- "python/user-guide/transformations/time-series/rolling.py:group_by_dyn2"
```
