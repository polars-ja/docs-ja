# カテゴリカルデータ

カテゴリカルデータは、カラムの値が有限のセットの文字列データを表します（通常、カラムの長さよりはるかに小さい）。性別、国、通貨ペアリングなどのカラムを考えることができます。これらの値を単純な文字列として保存すると、同じ文字列を繰り返し保存することになり、メモリとパフォーマンスの無駄になります。さらに、結合の場合、高価な文字列比較に困ってしまいます。

そのため、Polarsはディクショナリ形式でストリング値をエンコーディングすることをサポートしています。Polarsでカテゴリカルデータを扱うには、`Enum`と`Categorical`の2つの異なるデータ型を使用できます。それぞれに固有の使用例があり、このページでさらに説明します。
まずは、Polarsでカテゴリカルとは何かを見ていきましょう。

Polarsでは、カテゴリカルは、ディクショナリでエンコーディングされた文字列カラムと定義されます。文字列カラムは2つの要素に分割されます: エンコーディングと実際の文字列値。

<table>
<tr><th>文字列カラム </th><th>カテゴリカルカラム</th></tr>
<tr><td>
<table>
    <thead>
        <tr>
            <th>Series</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Polar Bear</td>
        </tr>
        <tr>
            <td>Panda Bear</td>
        </tr>
        <tr>
            <td>Brown Bear</td>
        </tr>
        <tr>
            <td>Panda Bear</td>
        </tr>
        <tr>
            <td>Brown Bear</td>
        </tr>
        <tr>
            <td>Brown Bear</td>
        </tr>
        <tr>
            <td>Polar Bear</td>
        </tr>
    </tbody>
</table>
</td>
<td>
<table>
<tr>
<td>

<table>
    <thead>
        <tr>
            <th>Physical</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0</td>
        </tr>
        <tr>
            <td>1</td>
        </tr>
        <tr>
            <td>2</td>
        </tr>
        <tr>
            <td>1</td>
        </tr>
        <tr>
            <td>2</td>
        </tr>
        <tr>
            <td>2</td>
        </tr>
        <tr>
            <td>0</td>
        </tr>
    </tbody>
</table>

</td>
<td>
<table>
    <thead>
        <tr>
            <th>Categories</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Polar Bear</td>
        </tr>
        <tr>
            <td>Panda Bear</td>
        </tr>
        <tr>
            <td>Brown Bear</td>
        </tr>
    </tbody>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

この場合、物理的な`0`は'Polar Bear'にエンコーディングされ、値`1`は'Panda Bear'、値`2`は'Brown Bear'にエンコーディングされます。このエンコーディングにより、文字列値を1回しか保存する必要がなくなります。さらに、操作（ソート、カウントなど）を物理的な表現で直接行うことができるため、文字列データを扱うよりも高速です。

### `Enum` vs `Categorical`

Polarsは、カテゴリカルデータを扱うために2つの異なるデータ型をサポートしています: `Enum`と`Categorical`。カテゴリが事前に分かっている場合は`Enum`を使用します。カテゴリが分からないか固定されていない場合は`Categorical`を使用します。要件が変わっていく場合は、いつでも片方から他方にキャストできます。

{{code_block('user-guide/concepts/data-types/categoricals','example',[])}}

上記のコードブロックから、`Enum`データ型は事前にカテゴリを要求するのに対し、`Categorical`データ型はカテゴリを推論することがわかります。

#### `Categorical`データ型

`Categorical`データ型は柔軟なものです。Polarsは新しいカテゴリを見つけるたびに追加します。これは`Enum`データ型に比べて明らかに優れているように聞こえますが、推論にはコストがかかります。ここでの主なコストは、エンコーディングを制御できないことです。

次のシナリオを考えてみましょう。2つのカテゴリカル`Series`を追加する場合

{{code_block('user-guide/concepts/data-types/categoricals','append',[])}}

Polarsは文字列値を出現順にエンコーディングします。そのため、`Series`は次のようになります:

<table>
<tr><th>cat_series </th><th>cat2_series</th></tr>
<tr><td>
<table>
<tr>
<td>
<table>
    <thead>
        <tr>
            <th>Physical</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0</td>
        </tr>
        <tr>
            <td>1</td>
        </tr>
        <tr>
            <td>2</td>
        </tr>
        <tr>
            <td>2</td>
        </tr>
        <tr>
            <td>0</td>
        </tr>
    </tbody>
</table>

</td>
<td>
<table>
    <thead>
        <tr>
            <th>Categories</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Polar</td>
        </tr>
        <tr>
            <td>Panda</td>
        </tr>
        <tr>
            <td>Brown</td>
        </tr>
    </tbody>
</table>

</td>
</tr>
</table>
</td>
<td>
<table>
<tr>
<td>
<table>
    <thead>
        <tr>
            <th>Physical</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0</td>
        </tr>
        <tr>
            <td>1</td>
        </tr>
        <tr>
            <td>1</td>
        </tr>
        <tr>
            <td>2</td>
        </tr>
        <tr>
            <td>2</td>
        </tr>
    </tbody>
</table>
