# 文字列（Strings）

このセクションでは、`DataFrame` を扱う際によく使用される `DataType` である `String` データに対して行われる操作について説明します。しかし、文字列を処理することは、その予測不可能なメモリーサイズのためにしばしば非効率的であり、CPU が多くのランダムなメモリー位置にアクセスすることを要求します。この問題に対処するため、Polars はそのバックエンドとして Arrow を使用し、すべての文字列を連続したメモリーブロックに保存します。その結果、文字列のトラバーサルはキャッシュ最適であり、CPU にとって予測可能です。

文字列処理関数は `str` 名前空間で利用可能です。

##### 文字列名前空間へのアクセス

`str` 名前空間は、`String` データタイプのカラムの `.str` 属性を通じてアクセスできます。次の例では、`animal` という名前のカラムを作成し、カラム内の各要素のバイト数および文字数での長さを計算します。ASCII テキストを扱っている場合、これら二つの計算の結果は同じになり、より速い `lengths` の使用が推奨されます。

{{code_block('user-guide/expressions/strings','df',['str.len_bytes','str.len_chars'])}}

```python exec="on" result="text" session="user-guide/strings"
--8<-- "python/user-guide/expressions/strings.py:setup"
--8<-- "python/user-guide/expressions/strings.py:df"
```

#### 文字列の解析

Polars は、文字列の要素をチェックし、解析するための複数の方法を提供します。まず、`contains` メソッドを使用して、部分文字列内に特定のパターンが存在するかどうかをチェックできます。その後、これらのパターンを抽出して他の方法で置換することが、今後の例で示されます。

##### パターンの存在チェック

文字列内にパターンが存在するかをチェックするには、`contains` メソッドを使用できます。`contains` メソッドは、`literal` パラメーターの値に応じて、通常の部分文字列または正規表現パターンのいずれかを受け入れます。私たちが探しているパターンが文字列の始まりまたは終わりに位置する単純な部分文字列である場合、代わりに `starts_with` および `ends_with` 関数を使用することができます。

{{code_block('user-guide/expressions/strings','existence',['str.contains', 'str.starts_with','str.ends_with'])}}

```python exec="on" result="text" session="user-guide/strings"
--8<-- "python/user-guide/expressions/strings.py:existence"
```

##### パターンの抽出

`extract` メソッドを使用して、指定された文字列からパターンを抽出できます。この方法では、パターンに含まれる一つ以上のキャプチャグループ（パターン内の括弧 `()` によって定義されます）を含む正規表現パターンを取ります。グループインデックスは、どのキャプチャグループを出力するかを示します。

{{code_block('user-guide/expressions/strings','extract',['str.extract'])}}

```python exec="on" result="text" session="user-guide/strings"
--8<-- "python/user-guide/expressions/strings.py:extract"
```

文字列内のパターンのすべての出現を抽出するには、`extract_all` メソッドを使用できます。以下の例では、正規表現パターン `(\d+)` を使用して文字列からすべての数字を抽出し、一つ以上の数字に一致します。`extract_all` メソッドの結果として出力されるのは、文字列内の一致したパターンのすべてのインスタンスを含むリストです。

{{code_block('user-guide/expressions/strings','extract_all',['str.extract_all'])}}

```python exec="on" result="text" session="user-guide/strings"
--8<-- "python/user-guide/expressions/strings.py:extract_all"
```

##### パターンの置換

これまでにパターンの一致と抽出の二つの方法を議論しましたが、今度は文字列内でパターンを置換する方法を探ります。`extract` と `extract_all` と同様に、Polars はこの目的のために `replace` と `replace_all` メソッドを提供します。以下の例では、単語の終わり（`\b`）にある `abc` の一つの一致を `ABC` に置き換え、`a` のすべての出現を `-` に置き換えます。

{{code_block('user-guide/expressions/strings','replace',['str.replace','str.replace_all'])}}

```python exec="on" result="text" session="user-guide/strings"
--8<-- "python/user-guide/expressions/strings.py:replace"
```

#### API ドキュメント

上記でカバーされた例に加えて、Polars は書式設定、ストリッピング、分割などのタスクのためのさまざまな他の文字列操作方法を提供します。これらの追加的な方法を探るためには、あなたが選んだプログラミング言語の Polars の API ドキュメントにアクセスできます。
