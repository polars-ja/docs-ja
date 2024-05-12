# フォールド（Folds）

Polars は `sum`、`min`、`mean` などの水平集計のための式やメソッドを提供しています。
しかし、より複雑な集計が必要な場合、Polars が提供するデフォルトのメソッドでは十分でないことがあります。そんな時に便利なのが `folds` です。

`fold` 式はカラム上で最大の速度で動作します。データレイアウトを非常に効率的に活用し、しばしばベクトル化された実行が行われます。

### 手動での合計

まずは `fold` を使って `sum` 操作を自分たちで実装する例から始めましょう。

{{code_block('user-guide/expressions/folds','mansum',['fold'])}}

```python exec="on" result="text" session="user-guide/folds"
--8<-- "python/user-guide/expressions/folds.py:setup"
--8<-- "python/user-guide/expressions/folds.py:mansum"
```

上のスニペットでは、関数 `f(acc, x) -> acc` をアキュムレータ `acc` と新しいカラム `x` に再帰的に適用しています。この関数はカラム個々に操作を行い、キャッシュ効率とベクトル化を活用することができます。

### 条件

`DataFrame` のすべてのカラムに条件/述語を適用したい場合、`fold` 操作はこれを表現する非常に簡潔な方法となります。

{{code_block('user-guide/expressions/folds','conditional',['fold'])}}

```python exec="on" result="text" session="user-guide/folds"
--8<-- "python/user-guide/expressions/folds.py:conditional"
```

スニペットでは、**各**カラム値が `> 1` のすべての行をフィルタリングします。

### 文字列データと Folds

Folds は文字列データの連結に使用することができます。しかし、中間カラムの具体化のため、この操作は二次の複雑さを持ちます。

そのため、`concat_str` 式の使用を推奨します。

{{code_block('user-guide/expressions/folds','string',['concat_str'])}}

```python exec="on" result="text" session="user-guide/folds"
--8<-- "python/user-guide/expressions/folds.py:string"
```
