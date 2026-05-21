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

開始値と終了値の間に刻み幅を指定することもできます。書き方は `start:step:stop` です。

```julia
for i in 1:2:10
    println(i)  # 1, 3, 5, 7, 9 を表示
end

for x in 0.0:0.1:1.0
    println(x)  # 0.0, 0.1, ..., 1.0 を表示
end
```


## `break` と `continue`
`break` を使うとループを途中で抜け出し、`continue` を使うと次の反復に進めます。

```julia
for i in 1:10
    if i > 5
        break  # ループを完全に終了する
    end
    println(i)
end

for i in 1:10
    if iseven(i)
        continue  # この反復をスキップ
    end
    println(i)  # 奇数だけ表示される
end
```


## インデックスつきで反復する
反復処理の途中で要素の値だけでなく位置 (インデックス) も欲しいことがあります。Julia には便利なヘルパーがいくつかあります。

`eachindex` はコレクションの有効なインデックスを返します。`1:length(x)` よりも `eachindex` を使うことをおすすめします。1 から始まらない配列でも正しく動き、一般に安全です。

```julia
v = [10.0, 20.0, 30.0]
for i in eachindex(v)
    println("v[$i] = $(v[i])")
end
```

`enumerate` は各要素にインデックスをペアにして返します。

```julia
for (i, value) in enumerate(v)
    println("position $i: $value")
end
```

`zip` を使うと、複数のコレクションを並行して反復できます。

```julia
wavelengths = [400, 500, 600]
intensities = [0.2, 0.9, 0.5]
for (λ, I) in zip(wavelengths, intensities)
    println("λ = $λ nm, I = $I")
end
```


## 内包表記
*内包表記 (comprehension)* は、範囲やコレクションの各要素を変換してベクトルを作るコンパクトな書き方です。数学の集合の内包的記法に似た記法です。

```julia
julia> squares = [i^2 for i in 1:5]
5-element Vector{Int64}:
  1
  4
  9
 16
 25
```

`if` 節を使えば要素のフィルタリングもできます。

```julia
julia> evens = [i for i in 1:10 if iseven(i)]
5-element Vector{Int64}:
  2
  4
  6
  8
 10
```

`for` の左側には任意の式 (関数呼び出しを含む) が書けます。内包表記は Julia らしい書き方で、いたるところで目にします。


## 問題
1. `for` ループを使って、1 から 100 までの整数の総和を計算しましょう。(結果は 5050 になるはずです。)

2. 内包表記を使って、1 から 10 までの整数の二乗を要素とするベクトルを作ってみましょう。

3. 次のベクトルで、最大値が現れるインデックスをループで探しましょう。(`argmax` は使わないこと。)

    ```julia
    y = [0.1, 0.3, 0.5, 1.2, 0.8, 0.4, 0.2]
    # ここにコードを書く。期待される結果: 4
    ```

4. *移動平均 (moving average)* は、隣接する点を平均することでノイズの多い信号を平滑化する手法です。ベクトル `y` とウィンドウサイズ `w` を受け取り、`i` 番目の要素が `y[i:i+w-1]` の平均となる新しいベクトルを作ってみましょう。次のデータで試してください。

    ```julia
    y = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    w = 3
    # 期待される結果: [2.0, 3.0, 4.0, 5.0, 6.0]
    ```
