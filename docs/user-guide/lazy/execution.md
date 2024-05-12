# クエリの実行

Reddit データセットの例クエリは次のとおりです:

{{code_block('user-guide/lazy/execution','df',['scan_csv'])}}

上記のコードを Reddit CSV で実行しても、クエリは評価されません。その代わり、Polars は各行のコードを取り込み、内部クエリグラフに追加し、クエリグラフを最適化します。

コードを実行すると、Polars はデフォルトで最適化されたクエリグラフを実行します。

### 完全なデータセットでの実行

クエリを完全なデータセットで実行するには、クエリの `.collect` メソッドを呼び出します。

{{code_block('user-guide/lazy/execution','collect',['scan_csv','collect'])}}

```text
shape: (14_029, 6)
┌─────────┬───────────────────────────┬─────────────┬────────────┬───────────────┬────────────┐
│ id      ┆ name                      ┆ created_utc ┆ updated_on ┆ comment_karma ┆ link_karma │
│ ---     ┆ ---                       ┆ ---         ┆ ---        ┆ ---           ┆ ---        │
│ i64     ┆ str                       ┆ i64         ┆ i64        ┆ i64           ┆ i64        │
╞═════════╪═══════════════════════════╪═════════════╪════════════╪═══════════════╪════════════╡
│ 6       ┆ TAOJIANLONG_JASONBROKEN   ┆ 1397113510  ┆ 1536527864 ┆ 4             ┆ 0          │
│ 17      ┆ SSAIG_JASONBROKEN         ┆ 1397113544  ┆ 1536527864 ┆ 1             ┆ 0          │
│ 19      ┆ FDBVFDSSDGFDS_JASONBROKEN ┆ 1397113552  ┆ 1536527864 ┆ 3             ┆ 0          │
│ 37      ┆ IHATEWHOWEARE_JASONBROKEN ┆ 1397113636  ┆ 1536527864 ┆ 61            ┆ 0          │
│ …       ┆ …                         ┆ …           ┆ …          ┆ …             ┆ …          │
│ 1229384 ┆ DSFOX                     ┆ 1163177415  ┆ 1536497412 ┆ 44411         ┆ 7917       │
│ 1229459 ┆ NEOCARTY                  ┆ 1163177859  ┆ 1536533090 ┆ 40            ┆ 0          │
│ 1229587 ┆ TEHSMA                    ┆ 1163178847  ┆ 1536497412 ┆ 14794         ┆ 5707       │
│ 1229621 ┆ JEREMYLOW                 ┆ 1163179075  ┆ 1536497412 ┆ 411           ┆ 1063       │
└─────────┴───────────────────────────┴─────────────┴────────────┴───────────────┴────────────┘
```

上記では、1,000万行からプレディケートにマッチする行が14,029行あることがわかります。

デフォルトの `collect` メソッドでは、Polars はすべてのデータを1つのバッチとして処理します。これは、クエリのメモリ使用量がピークに達した時点で、すべてのデータが使用可能なメモリに収まる必要があることを意味します。

!!! 警告  `LazyFrame` オブジェクトの再利用

    Remember that `LazyFrame`s are query plans i.e. a promise on computation and is not guaranteed to cache common subplans. This means that every time you reuse it in separate downstream queries after it is defined, it is computed all over again. If you define an operation on a `LazyFrame` that doesn't maintain row order (such as a `group_by`), then the order will also change every time it is run. To avoid this, use `maintain_order=True` arguments for such operations.

### 警告 「`LazyFrame` オブジェクトの再利用」

Polars は、_streaming_ mode を使用してデータをバッチ処理することができます。ストリーミングモードを使用するには、 `collect` に `streaming=True` 引数を渡します。

{{code_block('user-guide/lazy/execution','stream',['scan_csv','collect'])}}

[ストリーミングの詳細](streaming.md)を参照。

### 部分的なデータセットでの実行

大きなデータセットに対してクエリを書いたり、最適化したり、チェックしたりしているときに、利用可能なデータをすべてクエリすると、開発に時間がかかることがあります。

代わりに `.fetch` メソッドでクエリを実行することができます。`.fetch` メソッドは `n_rows` というパラメータを受け取り、データソースからその行数を `fetch` しようとします。しかし、遅延APIはクエリの各段階で行数をカウントしないため、行数を保証することはできないです。

ここでは、ソースファイルから100行を `.fetch` し、predicate を適用しています。

{{code_block('user-guide/lazy/execution','partial',['scan_csv','collect','fetch'])}}

```text
shape: (27, 6)
┌───────┬───────────────────────────┬─────────────┬────────────┬───────────────┬────────────┐
│ id    ┆ name                      ┆ created_utc ┆ updated_on ┆ comment_karma ┆ link_karma │
│ ---   ┆ ---                       ┆ ---         ┆ ---        ┆ ---           ┆ ---        │
│ i64   ┆ str                       ┆ i64         ┆ i64        ┆ i64           ┆ i64        │
╞═══════╪═══════════════════════════╪═════════════╪════════════╪═══════════════╪════════════╡
│ 6     ┆ TAOJIANLONG_JASONBROKEN   ┆ 1397113510  ┆ 1536527864 ┆ 4             ┆ 0          │
│ 17    ┆ SSAIG_JASONBROKEN         ┆ 1397113544  ┆ 1536527864 ┆ 1             ┆ 0          │
│ 19    ┆ FDBVFDSSDGFDS_JASONBROKEN ┆ 1397113552  ┆ 1536527864 ┆ 3             ┆ 0          │
│ 37    ┆ IHATEWHOWEARE_JASONBROKEN ┆ 1397113636  ┆ 1536527864 ┆ 61            ┆ 0          │
│ …     ┆ …                         ┆ …           ┆ …          ┆ …             ┆ …          │
│ 77763 ┆ LUNCHY                    ┆ 1137599510  ┆ 1536528275 ┆ 65            ┆ 0          │
│ 77765 ┆ COMPOSTELLAS              ┆ 1137474000  ┆ 1536528276 ┆ 6             ┆ 0          │
│ 77766 ┆ GENERICBOB                ┆ 1137474000  ┆ 1536528276 ┆ 291           ┆ 14         │
│ 77768 ┆ TINHEADNED                ┆ 1139665457  ┆ 1536497404 ┆ 4434          ┆ 103        │
└───────┴───────────────────────────┴─────────────┴────────────┴───────────────┴────────────┘
```
