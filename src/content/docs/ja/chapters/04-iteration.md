---
title: 反復処理
---

## *while* 文
while ループは、条件が真である限りコードブロックを繰り返し実行します。
以下のコードでは、変数 `i` を 1 ずつ減らしながら、1 から 10 までの数を表示します (実際にはここでは 5 から 1 までを表示しています)。

```julia
n = 5
while n > 0
    println(n)
    n = n - 1
end
println("Blast off!")
```

while ループは扱いを誤ると厄介で、条件がいつまでも偽にならない場合、ループが永遠に続いてしまいます。
```julia
while true
    println("This will run forever!")
end
```


## *for* 文
for ループは、値の範囲やコレクションの要素を順に処理するために使います。
```julia
fruits = ["apple", "banana", "cherry"]
for fruit in fruits
    println(fruit)
end
```

Julia では、`:` 演算子で範囲 (range) を作れます。
たとえば `1:5` は 1 から 5 までの範囲を表します。
この記法を使って、1 から 10 までの数を表示してみましょう。

```julia
for i in 1:10
    println(i)
end
```


## 問題
1. 正の整数を受け取り、1 からその数までの整数の総和を `for` ループで計算する関数を書いてみましょう。
