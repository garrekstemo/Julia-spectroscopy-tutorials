---
title: 関数
---

関数 (function) はコードを整理し、再利用しやすくするために使います。
いったん書いてしまえば、その内部で何が起きているかを考える必要はありません。
大きな問題は、特定のタスクを担う小さな関数を組み合わせて作ると、ずっと解きやすくなります。

プログラミングの関数は、数学の関数とよく似た働きをします。
入力 (引数) を受け取り、出力 (戻り値) を生み出します。
違いは、プログラミングの関数は数値以外の値も受け取ったり返したりできるという点です。
データに対して演算を行い、変数を操作し、プログラムの流れを制御します。


## 組み込み関数
Julia には多くの組み込み関数があり、自分で関数を定義することもできます。
すでに掛け算と足し算のための `*` や `+` といった基本的な関数は見てきました。
他の組み込み数学関数には次のようなものがあります: `sin`, `cos`, `exp`, `log`, `sqrt`, `abs`, `round`, `floor`, `ceil`, `max`, `min`。
数値以外の関数には `length`, `size`, `typeof`, `print`, `println`, `push!`, `pop!`, `sort`, `reverse` などがあり、他にも多数あります。

REPL でこれらの関数を実際に試してみましょう。\
(指導者向け: 以下の例を全部やる必要はありません。さまざまな組み込み関数があることを示すための例です。)

```julia
julia> round(3.14159, digits=2)  # This function has two arguments (inputs).
3.14

julia> floor(3.14159)
3.0

julia> max(3, 5)
5

julia> reverse("Hello, world!")
"!dlrow ,olleH"
```


## ユーザー定義関数
ユーザー定義の関数はプログラミングの中心です。
複雑な問題を解決するコードを書き、作業を自動化し、その成果を他人と共有するための第一歩です。

Julia では `function` キーワードを使って自分で関数を定義できます。
数を受け取って、その数に 1 を足した値を返す簡単な関数を書いてみましょう。

```julia
function add_one(x)
    return x + 1
end

y = 10 + add_one(5)
```
Julia では、関数の最終行が結果を返す式である場合、`return` キーワードは省略できます。
上のブロックは次のように書き換えられます。

```julia
function add_one(x)
    x + 1
end
```

`=` 演算子を使えば、1 行で関数を定義することもできます。

```julia
add_one(x) = x + 1
```
この簡潔な書き方は、数学的な関数を読み書きしやすくしてくれます。通常の数学の表記そのままに見えます。

```julia
f(x) = x^2 + 2x + 1
```

関数は値を返す必要はありません。何らかの動作だけを行うこともあります。

```julia
function print_twice(x)
    print(x)
    print(x)
end

print_twice("Hello")
```

変数 `x` は仮引数 (parameter) で、数学の関数における $f(x) = x^2$ の $x$ と同じく、ダミー変数です。
関数を呼び出すときに `x` に任意の値を渡せ、関数はその値を計算に使います。
`x` は関数の内部だけに存在し、関数のスコープの中でのみ有効です。

`*` や `+` などの演算子も Julia では関数ですが、*中置記法 (infix notation)* と呼ばれる特別な構文を持っています。
たとえば `3 * 5` と書くこともできますし、`*(3, 5)` と書くこともできます。

別の例として、数を二乗する関数を試してみましょう。

```julia
julia> square(x) = x^2  # function definition
square (generic function with 1 method)

julia> square(3)
9

julia> square(4.0)
16.0

julia> square(4.0 + 2.0im)
12.0 + 16.0im
```

この関数が異なる型の入力に対して自動的に動作することがわかります。
これは Julia の強力な特徴のひとつで、入力の型を自動的に判別し、適切な型の出力を返してくれます。
これは Julia の「多重ディスパッチ (multiple dispatch)」という仕組みによって可能になっていて、Julia の設計の中核をなす機能です。

### 演習
1. 数が偶数かどうかを判定する関数を書いてみましょう。偶数なら `true`、そうでなければ `false` を返します。

    ```julia
    is_even(x) = # your code here
    ```

2. 2 つの文字列を受け取り、間にスペースを挟んで連結する関数を書いてみましょう。

    ```julia
    join_with_space(a, b) = # your code here
    ```


## 問題
1. 波長 620 nm、310 nm、1240 nm の光子のエネルギーを eV 単位で計算する関数を書いてください。
    ```julia
    function wavelength_to_ev(wavelength_in_nm)
        # Your code here
    end

    using Test
    @test photon_energy(620) ≈ 2.0 atol=1e-2
    @test photon_energy(310) ≈ 4.0 atol=1e-2
    @test photon_energy(1240) ≈ 1.0 atol=1e-2
    ```

2. 2 次元のデカルト座標 (x, y) の点が、第何象限 (1, 2, 3, 4) にあるかを返す関数を書いてみましょう。

    *おまけ: 点が軸上や原点にある場合は、関数は何を返すべきでしょうか?*

    ```julia
    function quadrant(x, y)
        # add code here
    end

    using Test
    @test quadrant(1.0, 2.0) == 1
    @test quadrant(-13.0, -2) == 3
    @test quadrant(4, -3) == 4
    @test quadrant(-2, 6) == 2
    ```

3. 数学に有名な予想があります ([コラッツ予想](https://en.wikipedia.org/wiki/Collatz_conjecture))。これは、どんな正の整数も以下の規則を繰り返し適用すれば 1 に到達できる、というものです。
    1. 数が偶数なら 2 で割る。
    2. 数が奇数なら 3 倍して 1 を足す。

    正の整数 $n$ から始めて上の規則を 1 になるまで適用したときの数列を生成する関数を書いてみましょう。

$$
f(n) = \begin{cases}
    n/2 & \text{ if } n \text{ is even} \\
    3n + 1 & \text{ if } n \text{ is odd}
\end{cases}
$$
