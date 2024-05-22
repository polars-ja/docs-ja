# ピボット解除(Melts)

データフレームを横形式から縦形式に変換する Melt 操作

## データセット

{{code_block('user-guide/transformations/melt','df',['DataFrame'])}}

```python exec="on" result="text" session="user-guide/transformations/melt"
--8<-- "python/user-guide/transformations/melt.py:df"
```

## Eager + lazy

`Eager` と `lazy` は同じ API を持っています。

{{code_block('user-guide/transformations/melt','melt',['melt'])}}

```python exec="on" result="text" session="user-guide/transformations/melt"
--8<-- "python/user-guide/transformations/melt.py:melt"
```
