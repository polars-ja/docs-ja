# Lazy / eager API

Polars は 2 つの動作モードをサポートしています: lazy と eager です。eager API では、クエリが即座に実行されますが、lazy API では、クエリが「必要」とされるまで評価されません。最後の瞬間まで実行を遅らせることで、大幅なパフォーマンスの向上が期待できるため、ほとんどの場合 Lazy API が好ましいです。例を使って説明します:

{{code_block('user-guide/concepts/lazy-vs-eager','eager',['read_csv'])}}

この例では、eager API を使って以下を行っています:

1. iris [dataset](https://archive.ics.uci.edu/dataset/53/iris) を読み込む
1. データセットをsepal length でフィルタリングする
1. 種ごとのsepal width の平均を計算する

各ステップが即座に実行され、中間結果が返されます。しかし、使われていないデータを読み込んだり、不要な処理を行ったりするなど、無駄が生じる可能性があります。代わりに lazy API を使い、すべてのステップが定義されてから実行するようにすれば、クエリプランナーが最適化を行うことができます:

- Predicate pushdown: データセットの読み込み時に可能な限り早くフィルタを適用し、sepal length が 5 より大きい行のみ読み込む
- Projection pushdown: 必要なカラム（sepal width）のみ読み込み、不要なカラム（petal length & petal width）は読み込まない

{{code_block('user-guide/concepts/lazy-vs-eager','lazy',['scan_csv'])}}

これらの最適化により、メモリと CPU の負荷が大幅に軽減され、より大きなデータセットをメモリ上で処理し、高速に処理できるようになります。クエリの定義が完了したら、`collect` を呼び出して実行を指示します。Lazy API の実装については、後の章で詳しく説明します。

!!! info "Eager API"

    多くの場合、eager API は内部で lazy API を呼び出し、即座に結果を収集しています。これにより、クエリ内部での最適化も行われます。

### 使い分け

一般的に、lazy API を使うことをお勧めします。ただし、中間結果に興味がある場合や、探索的な作業を行っていて、クエリの形が確定していない場合は、eager API を使うことも検討してください。
