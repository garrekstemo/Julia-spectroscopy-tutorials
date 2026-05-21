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

REPL でこれらの関数を実際に試してみましょう。以下の例は組み込み関数の多様さを示すためのものなので、すべてを試す必要はありません。

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


## キーワード引数とデフォルト値
関数の引数にはデフォルト値を指定できます。シグネチャの中で `=` を使って指定します。

```julia
greet(name, greeting="Hello") = println("$greeting, $name!")
greet("Alice")            # Hello, Alice!
greet("Bob", "Hi there")  # Hi there, Bob!
```

*キーワード引数 (keyword arguments)* も定義できます。キーワード引数は名前で渡し、セミコロン `;` で位置引数と区切ります。

```julia
function gaussian(x; μ=0.0, σ=1.0)
    return exp(-(x - μ)^2 / (2σ^2)) / (σ * sqrt(2π))
end

gaussian(0.5)              # μ と σ はデフォルト値が使われる
gaussian(0.5; μ=1.0)       # μ を上書き、σ はデフォルト
gaussian(0.5; μ=1.0, σ=2)  # 両方上書き
```

キーワード引数を使うと、呼び出し側で引数の意味が明示されるので、引数が多い関数では特に読みやすくなります。


## 無名関数
名前を付ける必要のない 1 回限りの関数を作りたいことがあります。構文は `args -> body` です。

```julia
julia> (x -> x^2)(5)
25

julia> map(x -> 2x + 1, 1:5)
5-element Vector{Int64}:
  3
  5
  7
  9
 11
```

無名関数は `map`、`filter`、`sort` のような高階関数の引数として渡す用途で特に役立ちます。


## ブロードキャスト
Julia の関数の多くは単一の値を受け取ります。配列のすべての要素に関数を適用したいときは、関数名の後ろに `.` を付けます。

```julia
julia> square(x) = x^2
square (generic function with 1 method)

julia> square.([1, 2, 3, 4, 5])
5-element Vector{Int64}:
  1
  4
  9
 16
 25
```

これを *ブロードキャスト (broadcasting)* と呼びます。組み込み関数にもユーザー定義関数にも使え、ループを書くより簡潔です。多次元配列でも同じように動作します。

```julia
xs = 0.0:0.1:1.0
ys = sin.(2π .* xs)  # 各 x に sin を適用
```

後の章でモデル関数を点列にわたって評価する際にも、ブロードキャストを使うことになります。


## 問題
1. 波長 620 nm、310 nm、1240 nm の光子のエネルギーを eV 単位で計算する関数を書いてください。
    ```julia
    function photon_energy(wavelength_in_nm)
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

4. 赤外分光ではピーク位置を波数 $\tilde\nu$ (cm⁻¹) で表すことが多い一方、レーザーは波長 (nm) で指定されるのが普通です。$\lambda$ が nm 単位のとき、両者は $\tilde\nu = 10^7 / \lambda$ で結ばれます。波数 (cm⁻¹) を波長 (nm) に変換する関数 `wavenumber_to_wavelength(ν)` を書いてみましょう。

    ```julia
    wavenumber_to_wavelength(ν) = # your code here

    using Test
    @test wavenumber_to_wavelength(2000) ≈ 5000 atol=1e-6
    @test wavenumber_to_wavelength(10000) ≈ 1000 atol=1e-6
    ```

5. ローレンツ型のラインシェイプは、分光学で最もよく現れるピーク形状のひとつです。`p = [A, x₀, Γ]` に振幅・中心・半値全幅 (FWHM) を詰め込み、点 `x` でローレンツ型ピークを評価する関数 `lorentzian(p, x)` を書いてください。

    $$
    L(x) = \frac{A}{1 + \left(\frac{x - x_0}{\Gamma/2}\right)^2}
    $$

    引数の順番 (パラメータが先、独立変数が後) は、第 8 章で使う CurveFit パッケージの慣例に合わせています。

    ```julia
    lorentzian(p, x) = # your code here

    using Test
    @test lorentzian([1.0, 0.0, 2.0], 0.0) ≈ 1.0
    @test lorentzian([1.0, 0.0, 2.0], 1.0) ≈ 0.5  # x = Γ/2 で半値
    ```

6. もうひとつのよく現れるピーク形状がガウシアン (Gaussian) です。同じ `[A, x₀, Γ]` パラメータ化で `gaussian(p, x)` を書きましょう。ここで `Γ` は半値全幅 (FWHM) です。

    $$
    G(x) = A \exp\!\left(-\frac{(x - x_0)^2}{2\sigma^2}\right), \quad \sigma = \frac{\Gamma}{2\sqrt{2 \ln 2}}
    $$

    ```julia
    gaussian(p, x) = # your code here

    using Test
    @test gaussian([1.0, 0.0, 2.0], 0.0) ≈ 1.0
    @test gaussian([1.0, 0.0, 2.0], 1.0) ≈ 0.5  # x = Γ/2 で半値
    ```

7. 実際のピークは、純粋なローレンツでもガウシアンでもないことが多くあります。自然幅とドップラー広がりが重なるためです。*疑似 Voigt (pseudo-Voigt)* ラインシェイプは、混合パラメータ $\eta \in [0, 1]$ で 2 つのプロファイルを重み付き和として近似します。

    $$
    V(x) = \eta \cdot L(x) + (1 - \eta) \cdot G(x)
    $$

    `p = [A, x₀, Γ, η]` を受け取る `pseudo_voigt(p, x)` を書いてみましょう。上で書いた `lorentzian` と `gaussian` を再利用してください。これは「関数が別の関数を呼ぶ」例になります。

    ```julia
    pseudo_voigt(p, x) = # your code here

    using Test
    @test pseudo_voigt([1.0, 0.0, 2.0, 1.0], 0.0) ≈ 1.0  # 純粋ローレンツ
    @test pseudo_voigt([1.0, 0.0, 2.0, 0.0], 0.0) ≈ 1.0  # 純粋ガウシアン
    @test pseudo_voigt([1.0, 0.0, 2.0, 0.5], 1.0) ≈ 0.5  # 半値での 50:50 混合
    ```

    これら 3 つのラインシェイプ関数は、第 8 章でもモデル関数として再利用するので、保存しておいてください。
