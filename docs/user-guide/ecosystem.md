# エコシステム

## はじめに

このページでは、Polars をサポートするライブラリやツールの非網羅的なリストを見つけることができます。データエコシステムは急速に進化しているため、今後さらに Polars をサポートするライブラリが登場する可能性があります。主な要因の 1 つは、Polars が自身のバックエンドで `Apache Arrow` を使用していることです。

### 目次：

- [Apache Arrow](#apache-arrow)
- [データ可視化](#data-visualisation)
- [IO](#io)
- [機械学習](#machine-learning)
- [その他](#other)

---

### Apache Arrow

[Apache Arrow](https://arrow.apache.org/) は、同一プロセス内でデータの zero-copy 読み取りを可能にします。つまり、コピーやシリアル化の必要なく、メモリ内のフォーマットでデータに直接アクセスできます。これにより、Apache Arrow を使用するさまざまなツールとの統合時のパフォーマンスが向上します。Polars は、Pandas や DuckDB など、Apache Arrow を活用する幅広いライブラリと互換性があります。

### データ可視化

#### hvPlot

[hvPlot](https://hvplot.holoviz.org/) は、Polars のデフォルトのプロットバックエンドとして利用可能で、対話型および静的な可視化を簡単に作成できます。インストール時に `plot` 機能フラグを使用して hvPlot を使用できます。

```python
pip install 'polars[plot]'
```

#### Matplotlib

[Matplotlib](https://matplotlib.org/) は、Python で静的、アニメーション、対話型の可視化を作成するための包括的なライブラリです。Matplotlib は簡単なことを簡単に、難しいことを可能にします。

#### Plotly

[Plotly](https://plotly.com/python/) は、Python 用の対話型、オープンソース、ブラウザベースのグラフィックライブラリです。plotly.js 上に構築されており、科学的なチャート、3D グラフ、統計チャート、SVG マップ、金融チャートなど、30 種類以上のチャートタイプを提供しています。

#### [Seaborn](https://seaborn.pydata.org/)

Seaborn は、Matplotlib ベースの Python データ可視化ライブラリです。魅力的で情報豊富な統計グラフィックスを描くための高レベルのインターフェイスを提供します。

### IO

#### Delta Lake

[Delta Lake](https://github.com/delta-io/delta-rs) プロジェクトは、開発者やインテグレーターを対象とした低レベルの API と、Delta Lake を簡単に参照、検査、操作できる高レベルの操作 API を提供することで、Deltalake の力を多くのユーザーやプロジェクトに解放することを目的としています。

Polars での Delta Lake の使用方法については、[Delta Lake](https://delta-io.github.io/delta-rs/integrations/delta-lake-polars/#reading-a-delta-lake-table-with-polars) を参照してください。

### 機械学習

#### Scikit Learn

Scikit Learn 1.4 以降、すべての変換器が Polars の出力をサポートしています。[詳細](https://scikit-learn.org/dev/whats_new/v1.4.html#changes-impacting-all-modules)は[変更履歴] を参照してください。

### その他

#### DuckDB

[DuckDB](https://duckdb.org) は、高性能な分析データベースシステムです。高速、信頼性、ポータビリティ、使いやすさを目指して設計されています。DuckDB は、基本的な SQL を遥かに超えた豊富な SQL 言語をサポートしています。任意の入れ子になった相関サブクエリ、ウィンドウ関数、照合順序、複雑な型(配列、構造体)などがあります。Polars との統合については、[DuckDB のウェブサイト](https://duckdb.org/docs/guides/python/polars) を参照してください。

#### Great Tables

[Great Tables](https://posit-dev.github.io/great-tables/articles/intro.html) を使えば、誰でも素晴らしい見た目のテーブルを Python で作成できます。Polars との使用方法については、[ブログ記事](https://posit-dev.github.io/great-tables/blog/polars-styling/) を参照してください。

#### LanceDB

[LanceDB](https://lancedb.com/) は、AI アプリケーション向けの開発者に優しいサーバーレスベクトルデータベースです。Polars との直接的な統合を追加しました。LanceDB は Polars DataFrame をインジェストし、結果を Polars DataFrame で返し、テーブル全体を Polars lazyframe としてエクスポートできます。端的なチュートリアルは、[LanceDB + Polars](https://blog.lancedb.com/lancedb-polars-2d5eb32a8aa3) のブログで確認できます。

#### Mage

[Mage](https://www.mage.ai) は、データの変換と統合を行うためのオープンソースのデータパイプラインツールです。Polars との統合については、[docs.mage.ai](https://docs.mage.ai/integrations/polars) を参照してください。
