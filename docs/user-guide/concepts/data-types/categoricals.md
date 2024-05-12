# カテゴリカルデータ

カテゴリカルデータは、カラムの値が有限のセットの文字列データを表します（通常、カラムの長さよりはるかに小さい）。性別、国、通貨ペアリングなどのカラムを考えることができます。これらの値を単純な文字列として保存すると、同じ文字列を繰り返し保存することになり、メモリとパフォーマンスの無駄になります。さらに、結合操作の際に、コストのかかる文字列比較を行わなければなりません。

そのため、Polarsはディクショナリ形式でストリング値をエンコーディングすることをサポートしています。Polarsでカテゴリカルデータを扱うには、`Enum`と`Categorical`の2つの異なるデータ型を使用できます。それぞれに固有の使用例があり、このページでさらに詳しく説明します。
まずは、Polarsにおけるカテゴリカルの定義を見ていきましょう。

Polarsでは、カテゴリカルは、ディクショナリでエンコーディングされた文字列カラムと定義されます。文字列カラムは2つの要素に分割されます：エンコーディングされた整数値と実際の文字列値です。

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
            <th>エンコーディング値</th>
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
            <th>カテゴリ</th>
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

この場合、エンコーディング値の`0`は'Polar Bear'を表し、値`1`は'Panda Bear'、値`2`は'Brown Bear'を表します。このエンコーディングにより、文字列値を1回だけ保存すればよくなります。さらに、ソートやカウントなどの操作をエンコーディング値に対して直接行うことができるため、文字列データを扱うよりも高速です。

### `Enum` vs `Categorical`

Polarsは、カテゴリカルデータを扱うために2つの異なるデータ型をサポートしています： `Enum`と`Categorical`です。カテゴリが事前に分かっている場合は`Enum`を、カテゴリが分からないか固定されていない場合は`Categorical`を使用します。要件が変わった場合は、いつでも片方から他方にキャストできます。

{{code_block('user-guide/concepts/data-types/categoricals','example',[])}}

上記のコードブロックから、`Enum`データ型は事前にカテゴリを要求するのに対し、`Categorical`データ型はカテゴリを推論することがわかります。

#### `Categorical`データ型

Categoricalデータ型は柔軟性があります。Polarsは新しいカテゴリを見つけるたびに追加します。これは`Enum`データ型に比べて明らかに優れているように聞こえますが、推論にはコストがかかります。ここでの主なコストは、エンコーディングを制御できないことです。

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
