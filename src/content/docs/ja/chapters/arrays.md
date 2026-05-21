---
title: 6. 配列
---

配列 (array) は通常、同じ型の要素を連続したメモリ領域にまとめて格納したコレクションです。
リスト、探索、整列など、データを扱う際の基本的なデータ構造です。
Julia の配列は、同じ型の要素だけでなく異なる型の要素を混在させることもできます。
また配列は**ミュータブル (mutable)**、つまり作成後でも要素を変更できます。
1 次元の `Array` を Julia では `Vector` と呼びます。
まずは簡単な例で、ベクトルが Julia でどう動くかを見てみましょう。

```julia
julia> [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3
```

すべての要素を同じ型に変換できる場合、Julia は配列の型を自動的に推論します。
次の例では、Julia は整数を浮動小数点数に昇格させます。
```julia
julia> [1, 2.2, 3]
3-element Vector{Float64}:
 1.0
 2.2
 3.0 
```

異なる型が混在していて、共通の型に変換できない場合、配列はもっとも一般的な型になります。
下の例では、文字列、浮動小数点数、整数、ブール値が含まれていて、ひとつの型には昇格できないため、ベクトルの型は `Any` になります。
```julia
julia> a = ["hello", 2.0, 3, false, "🌵"]
5-element Vector{Any}:
    "hello"
    2.0
    3
false
    "🌵"
```

配列の要素数は `length` 関数で取得できます。
```julia
julia> length(a)
5
```

`in` 関数を使えば、ある要素が配列に含まれているかどうかを `true` または `false` で確認できます。
```julia
julia> "hello" in a
true
```


## インデックスとスライス
配列の要素には *インデックス* を使ってアクセスできます。
Julia は 1 始まりのインデックスを採用しています。つまり配列の最初の要素のインデックスは 1 です (多くの言語は 0 から始まります)。

```julia
a = ["hello", 2.0, false, "🌵", 6]
a[1]  # returns "hello"
a[2]  # returns 2.0
a[end-1]  # returns "🌵"
```

配列の要素はインデックスを使って再代入できます。
次の例では、配列 `v` の最初の要素を 5 に変更しています。
```julia
julia> v = [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3

julia> v[1] = 5
5

julia> v
3-element Vector{Int64}:
  5
  2
  3
```

`i:j` の記法で *スライス* を取り出して、部分配列を作れます。
```julia
a = ["hello", 2.0, false, "🌵", 6]
a[1:2]  # returns ["hello", 2.0]
a[3:end]  # returns [false, "🌵", 6]
```

ステップ幅を指定して配列を飛ばし飛ばし辿ることもできます。
ここではステップ幅 2 で配列を辿ります。
```julia
a = ["hello", 2.0, false, "🌵", 6]
a[1:2:end]  # returns ["hello", false, 6]
```

ステップ幅に -1 を指定すれば、配列を *逆向き* に辿れます。
```julia
a = ["hello", 2.0, false, "🌵", 6]
a[end:-1:1]  # returns [6, "🌵", false, 2.0, "hello"]
```


### 演習
1. 次のように作られた配列を考えます。

    ```julia
    x = 3
    my_array = [1, 2, x]
    ```
    配列を作った後で `x` を変更した場合、`my_array` はどうなるでしょうか?


## 範囲オブジェクト (Range)
1 から 10 までの数のように、始点と終点の間で線形に並んだ数のリストが欲しい場面はよくあります。
範囲オブジェクト (range object) を使うと簡単に作れます。
たとえば `r = 1:10` は、ステップ幅 1 で 1 から 10 までを表す `UnitRange` オブジェクトです (Unit はステップ幅 1 を意味します)。
任意のステップ幅で範囲オブジェクトを作ることもできます。
たとえば `r = 1:2:10` はステップ幅 2 で 1 から 10 までを表します (`StepRange` オブジェクト)。

範囲オブジェクトはメモリ効率が良く、すべての数値をメモリに格納していません。
始点・終点・ステップ幅のみを保持しています。
構造を調べるには `dump` 関数が使えます。
`1:2:10` という範囲オブジェクトに対して `dump()` を呼び出し、`[1, 2, 3]` ("配列リテラル" と呼ばれます) で作った `Vector` オブジェクトと比較してみてください。
`1:2:10` は始点・終点・ステップ幅を持っているだけで、1 から 10 までの数を格納していないことがわかります。
`UnitRange` はさらに「怠惰」で、始点と終点だけを持ちます。
詳しい議論は [このStackOverflowの投稿](https://stackoverflow.com/questions/55438134/creating-arrays-from-ranges-in-julia-without-using-collect) を参照してください。
範囲の中の数値そのものが必要な場合は、`collect()` を使って範囲オブジェクトの要素から新しい配列を作れます。

```julia
julia> dump([1, 2, 3])
Array{Int64}((3,)) [1, 2, 3]

julia> dump(1:2:10)
StepRange{Int64, Int64}:
  start: 1
  stop: 10
  step: 2

julia> dump(1:10)  # UnitRange is even lazier
UnitRange{Int64}
  start: Int64 1
  stop: Int64 10
```

より細かい指定が必要なときは `range()` 関数が使えます。
使い方はいくつもありますが、ここでは代表的な例を 2 つ紹介します。
```julia
julia> range(1, stop=10, step=2)
1:2:9

julia> range(1, step=0.5, length=5)
1.0:0.5:3.0
```


## 多次元配列
Julia では行列は 2 次元配列です。
行の中の要素はスペースで区切り、行同士はセミコロンか改行で区切ります。

```julia
julia> A = [1 2 3; 4 5 6]  # matrix with semicolons
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> A = [1 2 3
            4 5 6]  # matrix with newlines
2×3 Matrix{Int64}:
 1  2  3
 4  5  6
 ```

これ以外にも、複雑な配列を作る方法はいくつもあります。
詳細は公式ドキュメントを参照してください。

行列の次元 (サイズ) は `size` 関数で取得できます。
```julia
julia> size(A)
(2, 3)
```

行列から要素を取り出すのもベクトルと似ていますが、行と列の両方を指定します。
 ```julia
julia> A[2, 3]
6
```

行や列全体を取り出すこともできます。
```julia
julia> A[1, :]  # all elements in the first row
3-element Vector{Int64}:
 1
 2
 3

julia> A[:, 1]  # all elements in the first column
3-element Vector{Int64}:
 1
 4
```


## 配列の作成と操作
Julia には配列を作るための方法がたくさんあり、便利な関数も用意されています。
`rand` 関数は乱数からなる配列を作ります。
正規分布の乱数が欲しい場合は `randn` 関数が便利です。
これはたとえばシミュレーションでガウシアンノイズを生成するのに便利で、後ほど使います。

```julia
julia> x = rand(3)
3-element Vector{Float64}:
 0.5346195188930014
 0.630133797544507
 0.5654504803142291

julia> x = randn(3)
3-element Vector{Float64}:
 -1.305609652029686
  0.7823283852517753
  0.5642076071244995
```

すべて 0、すべて 1、または任意の値で埋めた配列を作ることもできます。
```julia
julia> zeros(3)
3-element Vector{Float64}:
 0.0
 0.0
 0.0

julia> ones(3)
3-element Vector{Float64}:
 1.0
 1.0
 1.0

julia> fill(3.2, 5)
5-element Vector{Float64}:
 3.2
 3.2
 3.2
 3.2
 3.2
```

配列の末尾に要素を追加するには `push!` 関数を使います。

```julia
julia> push!(a, "-2")
6-element Vector{Any}:
    "hello"
    2.0
 false
    "🌵"
    6
    "-2"
```

この関数の便利な使い方として、空の配列を作っておいて `for` ループで要素を追加していくパターンがあります。
ループ内で計算を行い、その結果を配列に追加できます。
```julia
a = []
for x in 1:5
    y = x^2
    push!(a, y)
end
```

配列から要素を取り除くには `pop!` (末尾の要素を削除) と `popat!` (任意のインデックスの要素を削除) を使います。
どちらも削除した要素を返します。
```julia
julia> v = rand(1:10, 5)
5-element Vector{Int64}:
  5
  2
 10
  5
  7

julia> pop!(v)
7

julia> v
4-element Vector{Int64}:
  5
  2
 10
  5

julia> popat!(v, 3)
10

julia> v
3-element Vector{Int64}:
 5
 2
 5
```


### 演習
1. `rand` 関数を使って、1 から 20 までの整数の乱数を 5 個含む配列を作ってみましょう。

2. 同じく 1 から 20 までの整数の乱数で、2 行 3 列の 2 次元配列を作ってみましょう。


## 反復処理
配列を順に処理する方法として、要素そのものを順に取り出す方法と、要素の位置 (インデックス) を順に辿る方法があります。

```julia
julia> fruits = ["apple", "banana", "cherry"]
3-element Vector{String}:
 "apple"
 "banana"
 "cherry"

julia> for fruit in fruits
           println("Fruit: $fruit")
       end
Fruit: apple
Fruit: banana
Fruit: cherry

julia> for i in eachindex(fruits)
           println("Index: $i")
       end
Index: 1
Index: 2
Index: 3
```

値とインデックスの両方が必要な場合は、`enumerate` 関数を使います。
```julia
fruits = ["apple", "banana", "cherry"]
julia> for (i, fruit) in enumerate(fruits)
           println("$i: $fruit")
       end
1: apple
2: banana
3: cherry
```

行列の行や列を順に処理するための専用の関数もあります。
```julia
julia> A = [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> for row in eachrow(A)
           println(row)
       end
[1, 2, 3]
[4, 5, 6]

julia> for col in eachcol(A)
           println(col)
       end
[1, 4]
[2, 5]
[3, 6]
```


## ブロードキャスト
ブロードキャスト (broadcasting) は、配列やコレクションの各要素に対して関数を適用する仕組みです。
ドット `.` 記法を使うと、関数を要素ごとに適用できます。
これは関数の [ベクトル化 (vectorizing)](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) とも呼ばれます。
`.*`、`./`、`.^` といった演算子で要素ごとの演算ができます。
いくつか例を見てみましょう。

```julia
julia> v = [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3

julia> v .+ 1
3-element Vector{Int64}:
 2
 3
 4

julia> sin.(v)
3-element Vector{Float64}:
 0.8414709848078965
 0.9092974268256817
 0.1411200080598672
```

ベクトルを入力として受け取り、ベクトルを返す関数を定義することもできます。
```julia
v = [1, 2, 3]
f(x) = x .+ 1
f(v)  # returns [2, 3, 4]
```

`@.` マクロを使うと、より簡潔に書けます。
```julia
julia> @. f(x) = x + 1
f (generic function with 1 method)

julia> f(v)
3-element Vector{Int64}:
 2
 3
 4
```


### 演習
1. 次の関数を考えます。

    ```julia
    f(x) = x^2 + 1
    ```
    この関数を配列に対して適用しようとするとどうなるでしょうか?


## 内包表記
内包表記 (comprehension) は、配列を作るための強力な記法です。
次の例では、0 から 5 までの偶数の二乗を要素とする新しい配列を作っています。
いくつか例を示します。

```julia
julia> [x^2 for x in 0:5]
6-element Vector{Int64}:
  0
  1
  4
  9
 16
 25
 
julia> [x^2 for x in 0:5 if iseven(x)]
3-element Vector{Int64}:
  0
  4
 16

julia> [i + j for i in 1:3, j in 1:3]
3×3 Matrix{Int64}:
 2  3  4
 3  4  5
 4  5  6
 ```


### 演習
1. 内包表記を使って、1 から 100 までの 7 で割り切れる数の配列を作ってみましょう。


## 問題
1. 10 個の整数の乱数からなるベクトルを生成し、偶数インデックスの要素だけを返す関数を書いてみましょう。

2. 整数のベクトルに対して、長さが奇数なら中央の 1 要素を、偶数なら中央の 2 要素を取り除く関数を書いてみましょう。たとえば `[1, 2, 3, 4, 5]` の場合、結果は `[1, 2, 4, 5]` となります。


## 便利な関数一覧

### 配列を作る
| 関数 | 説明 |
|----------|-------------|
| `zeros(n)` | 要素がすべて 0 の `n` 要素配列を作成 |
| `ones(n)` | 要素がすべて 1 の `n` 要素配列を作成 |
| `fill(x, n)` | 要素がすべて `x` の `n` 要素配列を作成 |
| `rand(n)` | 一様分布の乱数からなる `n` 要素配列を作成 |
| `randn(n)` | 正規分布の乱数からなる `n` 要素配列を作成 |
| `collect(r)` | 範囲オブジェクト `r` から配列を作成 |


### 配列を調べる
| 関数 | 説明 |
|----------|-------------|
| `length(a)` | 配列 `a` の要素数を返す |
| `in(x, a)` | `x` が配列 `a` に含まれていれば `true` を返す |
| `size(a)` | 配列 `a` の次元 (サイズ) を返す |
| `findall(f, a)` | 条件 `f` を満たす `a` の要素のインデックスをすべて返す |
| `findfirst(f, a)` | 条件 `f` を満たす最初の要素のインデックスを返す |
| `findlast(f, a)` | 条件 `f` を満たす最後の要素のインデックスを返す |


### 配列をその場で変更する
| 関数 | 説明 |
|----------|-------------|
| `push!(a, x)` | 要素 `x` を配列 `a` の末尾に追加 |
| `append!(a, b)` | 配列 `b` を配列 `a` の末尾に連結 |
| `pop!(a)` | 配列 `a` の最後の要素を削除 |
| `popat!(a, i)` | 配列 `a` のインデックス `i` の要素を削除 |
| `deleteat!(a, i)` | 配列 `a` のインデックス `i` の要素を削除 |
| `sort!(a)` | 配列 `a` をその場でソート |
| `reverse!(a)` | 配列 `a` をその場で反転 |


### 配列を変換する
| 関数 | 説明 |
|----------|-------------|
| `map(f, a)` | 関数 `f` を配列 `a` の各要素に適用 |
| `sort(a)` | 配列 `a` をソートした新しい配列を返す |
| `reverse(a)` | 配列 `a` を反転した新しい配列を返す |
| `filter(f, a)` | 条件 `f` を満たす要素からなる新しい配列を返す |


### 配列を連結する
| 関数 | 説明 |
|----------|-------------|
| `vcat(a, b)` | 配列 `a` と `b` を縦 (行方向) に連結 |
| `hcat(a, b)` | 配列 `a` と `b` を横 (列方向) に連結 |
| `cat(a, b, dims)` | 指定した次元 `dims` に沿って配列 `a` と `b` を連結 |


## おまけ: [ジェネレータ式](https://docs.julialang.org/en/v1/manual/arrays/#man-generators)
Julia には、プログラム的に配列を作る方法がたくさんあります。
そのひとつが、配列の各要素に関数を適用する方法です。
たとえば、0 から 5 までの整数を要素とするベクトルの各要素に `square` 関数を適用したい場合、`map` 関数を使えます。

```julia
square(x) = x^2
map(square, 0:5)  # returns [0, 1, 4, 9, 16, 25]
```
別の方法として、配列の要素をフィルタリングする方法もあります。
たとえば、0 から 5 までの整数のうち偶数だけを取り出したい場合、`filter` 関数と、偶数なら `true` を返す `iseven` 関数を使えます。

```julia
filter(iseven, 0:5)  # returns [0, 2, 4]
```

遅延評価ではなく、配列の各要素をメモリ上に展開したい場合は、`collect` 関数を使います。
```julia
collect(0:5)  # returns [0, 1, 2, 3, 4, 5]
```
