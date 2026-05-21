---
title: 条件分岐
---

## ブール式
ブール式 (boolean expression) とは、結果が `true` か `false` のいずれかになる式のことです。

```julia
julia> t = true
true

julia> f = false
false
```

ブール変数の型は `typeof` 関数で確認できます。

```julia
julia> typeof(true)
Bool

julia> typeof(false)
Bool
```

## 比較演算子
比較演算子は値どうしを比較して、ブール値を返します。
`a = 1`、`b = 2` としたとき、比較演算子は次のように使えます。

```julia
julia> a, b = 1, 2
(1, 2)

julia> a == b  # equal to
false

julia> a != b  # not equal to
true

julia> a < b  # less than
true

julia> a >= b  # greater than or equal to
false
```

### 演習
1. `1 == 2` が返す結果の型は何でしょうか?
3. `==` と `===` の違いは何でしょうか?
4. `"Hello world"[i:j] == "o wo"` が `true` を返すように、`i` と `j` を選んでみましょう。


## 論理演算子
論理演算子は、ブール値に対する論理演算を行うための演算子です。
Julia には 3 つの論理演算子があります: `&&` (AND), `||` (OR), `!` (NOT)。
論理演算子はブール式を組み合わせるために使います。

```julia
julia> t && f  # logical AND
false

julia> t || f  # logical OR
true

julia> !t  # logical NOT
false
```
複雑な式では、括弧を使って演算順序をグループ化できます。
```julia
julia> (a < b) && (b > 0)  # true
true
```


### 演習
1. `x = 5`、`y = 10` のとき、次の式の値は何になるでしょうか?

    ```julia
    !(x > 0) && y < 0
    ```


## if 文
if 文を使うと、ブール式の結果に応じて条件付きでコードを実行できます。
たとえば、ある数が 0 より大きいかどうかを `if` で調べられます。

```julia
x = 5
if x > 0
    println("x is positive")
end
```

`x` は 0 より大きいので、このコードは "x is positive" を出力します。
もし `x` が 0 以下なら、`if` ブロックの中のコードは実行されず、何も起こりません。
通常は条件が偽の場合にも何かしらの処理を行いたいので、`else` を使って代替のコードブロックを指定できます。

```julia
x = -5
if x > 0
    println("x is positive")
else
    println("x is not positive")
end
```

3 つ目の選択肢として `elseif` があり、複数の条件をチェックできます。
これを使って、数が正・負・0 のいずれかを判定してみましょう。

```julia
x = 0
if x > 0
    println("x is positive")
elseif x < 0
    println("x is negative")
else
    println("x is zero")
end
```


### 演習
1. 気温に応じてメッセージを表示するプログラムを書いてみましょう。たとえば次のようなものです。

    0 未満: "It's freezing!" \
    0 〜 20: "It's cold." \
    20 〜 30: "It's warm." \
    30 より上: "It's hot!"


## 問題
1. 次のプログラムを完成させ、1 から 10 までの偶数のうち 4 で割り切れないものだけを表示しましょう。

    ```julia
    for i in 1:10
        if # Your code here. This should return `true`.
            println(i)
        end
    end
    ```

2. 次の条件分岐のロジックを修正してみましょう。`x` が 10 以上 20 以下かどうかを判定したいプログラムです。
元のコードがなぜ期待通りに動かないのか、考えてみましょう。

    ```julia
    x = 15
    if x > 10 || x < 20
        println("x is between 10 and 20")
    else
        println("x is not between 10 and 20")
    end
    ```
