# 基本演算子（Basic operators）

このセクションでは、基本演算子（例えば、加算、減算など）をエクスプレッションと組み合わせて使用する方法について説明します。以下のデータフレームのコンテキストで、異なるテーマを使用した様々な例を提供します。

!!! note 演算子のオーバーロード

    Rust や Python では、言語が演算子のオーバーロードを許可しているため、直接演算子（`+ - * / < >` など）を使用することが可能です。例えば、演算子 `+` は `.add()` メソッドに変換されます。好みの方法を選択できます。

{{code_block('user-guide/expressions/operators','dataframe',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/operators"
--8<-- "python/user-guide/expressions/operators.py:setup"
--8<-- "python/user-guide/expressions/operators.py:dataframe"
```

### 数値演算

{{code_block('user-guide/expressions/operators','numerical',['operators'])}}

```python exec="on" result="text" session="user-guide/operators"
--8<-- "python/user-guide/expressions/operators.py:numerical"
```

### 論理演算

{{code_block('user-guide/expressions/operators','logical',['operators'])}}

```python exec="on" result="text" session="user-guide/operators"
--8<-- "python/user-guide/expressions/operators.py:logical"
```
