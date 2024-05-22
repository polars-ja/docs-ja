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
            <td>Panda</td>
        </tr>
        <tr>
            <td>Brown</td>
        </tr>
        <tr>
            <td>Polar</td>
        </tr>
    </tbody>
</table>

</td>
</tr>
</table>
</td>
</tr>
</table>

`Series` の結合は、両方の `Series` における物理的な値0が異なる意味を持つため、非自明で高コストなタスクとなります。Polarsは利便性のためにこの種の操作をサポートしていますが、一般的にはパフォーマンスが低下するため避けるべきです。これは、マージ操作を行う前に両方のエンコーディングを互換性のあるものにする必要があるためです。

##### グローバルな string cache を使う

この問題を解決する一つの方法は、`StringCache` を有効にすることです。`StringCache` を有効にすると、文字列は列ごとに出現順にエンコードされるのではなく、各文字列に対して単一のエンコードが保証されます。つまり、`StringCache` を使用することで、文字列 `Polar` は常に同じ物理的エンコードにマップされます。これにより、マージ操作（例：追加、結合）はエンコードの互換性を事前に確保する必要がなくなるため、高速になります。これにより、上記の問題が解決されます。

{{code_block('user-guide/concepts/data-types/categoricals','global_append',[])}}

しかし、`StringCache` は `Series` の構築時に、キャッシュ内で文字列の検索や挿入を行うため、若干のパフォーマンス低下を招きます。したがって、事前にカテゴリーが分かっている場合は、Enumデータ型を使用することが推奨されます。

#### `Enum` データ型

`Enum` データ型では、事前にカテゴリーを指定します。これにより、異なる列や異なるデータセットからのカテゴリカルデータが同じエンコードを持つことが保証され、高コストな再エンコードやキャッシュ検索が不要になります。

{{code_block('user-guide/concepts/data-types/categoricals','enum_append',[])}}

Polarsは、`Enum` で指定されていない値が見つかった場合、`OutOfBounds` エラーを発生させます。

{{code_block('user-guide/concepts/data-types/categoricals','enum_error',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:setup"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:enum_error"
```

### 比較

カテゴリカルデータに対して許可されている比較演算子は次のとおりです：

- Categorical vs Categorical
- Categorical vs String

#### `Categorical` 型


`Categorical` 型の比較は、同じグローバルキャッシュセットを持っている場合、または同じ順序で同じ基礎カテゴリーを持っている場合に有効です。

{{code_block('user-guide/concepts/data-types/categoricals','global_equality',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:setup"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:global_equality"
```

CategoricalとStringの比較では、Polarsは語彙順を使用して結果を決定します：

{{code_block('user-guide/concepts/data-types/categoricals','str_compare_single',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:str_compare_single"
```

{{code_block('user-guide/concepts/data-types/categoricals','str_compare',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:str_compare"
```

#### `Enum` 型

`Enum` 型の比較は、同じカテゴリーを持っている場合に有効です。

{{code_block('user-guide/concepts/data-types/categoricals','equality',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:equality"
```

`Enum` と `String` の比較では、語彙順ではなくカテゴリー内の順序が使用されます。比較が有効であるためには、`String` 列のすべての値が `Enum` のカテゴリーリストに含まれている必要があります。

{{code_block('user-guide/concepts/data-types/categoricals','str_enum_compare_error',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:str_enum_compare_error"
```

{{code_block('user-guide/concepts/data-types/categoricals','str_enum_compare_single',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:str_enum_compare_single"
```

{{code_block('user-guide/concepts/data-types/categoricals','str_enum_compare',[])}}

```python exec="on" result="text" session="user-guide/datatypes/categoricals"
--8<-- "python/user-guide/concepts/data-types/categoricals.py:str_enum_compare"
```
