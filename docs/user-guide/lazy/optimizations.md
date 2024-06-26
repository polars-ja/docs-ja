# 最適化

Polars の Lazy API を使用すると、Polars はクエリに対していくつかの最適化を実行します。それらの中には、前もって実行されるものもあれば、
マテリアライズされたデータが入ってきたときに、その時点で決定されるものもあります。

ここでは、Polars によって実行される最適化の概要、実行内容、実行頻度について説明します。

| Optimization               | Explanation                | runs          |
| -------------------------- |----------------------------|---------------|
| Predicate pushdown         | 可能な限り早く／スキャンレベルでフィルターを適用する。| 1 回           |
| Projection pushdown        | スキャンレベルで必要な列のみを選択する。      | 1 回           |
| Slice pushdown             | スキャンレベルから必要なスライスだけをロードする。スライスされた出力を実体化しない（例：join.head(10)）。 | 1 回           |
| Common subplan elimination | クエリプラン内の複数のサブツリーで使用されるサブツリー/ファイルスキャンをキャッシュします。 | 1 回           |
| Simplify expressions       | 定数の折りたたみや、高価な演算をより高速な代替演算に置き換えるなど、様々な最適化します。 | 定点まで          |
| Join ordering              | メモリへの負担を減らすために最初に実行されるべき結合の枝を推定する。 | 1 回           |
| Type coercion              | 演算が成功し、必要最小限のメモリで実行されるように型を強制する。 | 定点まで          |
| Cardinality estimation     | 最適なグループ化戦略を決定するためにカーディナリティを推定する。 | 0/n 回; クエリに依存 |
