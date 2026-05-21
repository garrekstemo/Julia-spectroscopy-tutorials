---
title: 2. 変数、演算子、型
---

ターミナルで `julia` と入力して REPL (Julia のコマンドラインインタフェース) を開きましょう。
REPL は Read-Eval-Print Loop の略です。

以下のコード例を REPL で実際に手を動かしながら追ってみてください。
気になる箇所はどんどん書き換えて遊んでみましょう。
コードを実行する前に「どうなると思うか?」を自分に問いかける習慣をつけると、コードの理解が深まります。これは実験の設計や結果の解釈にもそのまま役立つ思考法です。


## 代入と基本演算
ひとつの変数に対する基本演算から始めます。
プログラミングでは、`=` は等号 (equality) ではなく代入 (assignment) を意味します。

たとえば `a = 2` は「変数 `a` に値 2 を代入する」という意味です。
プログラミングでは次のような書き方もできます。
```julia
a = a + 1
```
これは「`a + 1` の値を `a` に代入する」という意味です。
数学的には意味をなしませんが、プログラミングではまったく自然な書き方です。

Julia で数値に対してできる基本演算をいくつか紹介します。
```julia
julia> a = 2  # assignment
2

julia> a  # print the value of a
2

julia> a + 1  # addition
3

julia> a - 1  # subtraction
1

julia> a * 2  # multiplication
4

julia> a^2  # exponentiation
4

julia> a / 2  # division
1.0  # what's going on here?

julia> a % 2  # modulo
0
```

`a` も `2` も整数なのに、`a / 2` の結果は `1.0` になっていることに注目してください。Julia の `/` 演算子は、引数の型にかかわらず常に `Float64` を返します。整数の商 (切り下げ除算) が欲しいときは `÷` (`\div<Tab>` で入力) を、正確な有理数で扱いたいときは `//` を使います。

```julia
julia> 7 / 2
3.5

julia> 7 ÷ 2
3

julia> 7 // 2
7//2
```


### 演習

1. 次のコードブロックの最後で `x` の値はいくつになるでしょうか?

    ```julia
    x = 3
    y = x
    x = x + 1
    x = y
    ```

2. まだ定義されていない変数を使おうとしたらどうなるでしょうか?

    ```julia
    cats = 5
    Cats
    ```


## 型
変数の型を調べるには `typeof` 関数を使います。
ここではいろいろな型の変数を作って、Julia の型システムを少し見てみましょう。

```julia
julia> a = 2
2

julia> b = 2.0
2.0

julia> c = 3.0 + 4.0im  # complex number
3.0 + 4.0im

julia> d = "hello"  # double quotes for strings
"hello"

julia> e = 'a'  # single quotes for characters
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> typeof(a)
Int64

julia> typeof(b)
Float64

julia> typeof(c)
ComplexF64 (alias for Complex{Float64})

julia> typeof(d)
String
```


### 演習
1. 異なる型を組み合わせた演算 (`1 + 2.0` など) を試してみましょう。何が起きますか?
2. `*` や `+` といった演算子の型は何になるでしょうか?


## Unicode 変数名
Julia の変数名には Unicode 文字を使えるため、物理や数学の記法をそのまま再現できて便利です。REPL や VS Code では、LaTeX 風のコマンドを入力してから `Tab` を押すと、対応する記号が挿入されます。

```julia
julia> λ = 620  # \lambda<Tab>
620

julia> ν = 1e7 / λ  # \nu<Tab>
16129.032258064515

julia> α, β = 0.1, 0.9  # \alpha<Tab>, \beta<Tab>
(0.1, 0.9)
```

ギリシャ文字や下付き文字、プライム記号など、多くの記号に対応しています。利用できる入力コマンドの一覧は Julia 公式マニュアルの [Unicode Input](https://docs.julialang.org/en/v1/manual/unicode-input/) にあります。


## 文字列
テキストデータは、文字 (character) の並びである文字列 (string) として表現されます。
文字列に対しても演算ができますが、数値とは違った演算になります。

```julia
julia> s = "hello"
"hello"

julia> s * s  # string concatenation
"hellohello"

julia> s^3
"hellohellohello"
```

トリプルクォートで囲むと、複数行の文字列を作れます。

```julia
"""
This is a multi-line string.
It can span multiple lines.
It is useful for writing long text or documentation.
"""
```

文字列はインデックスを使って 1 文字を取り出せます。
コロン演算子 `:` を使えば、たとえば 3 〜 8 文字目の部分文字列を取り出せます。

```julia
julia> s = "Hello world"
"Hello world"

julia> s[1]  # first character
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> s[3:8]  
"llo wo"
```


### 文字列補間
文字列補間 (string interpolation) は、文字列の中に変数や式の値を埋め込む方法です。
`$` 記号を使って変数や式を文字列に挿入できます。

```julia
julia> name = "Alice"
"Alice"

julia> age = 30
30

julia> "My name is $name and I am $age years old."
"My name is Alice and I am 30 years old."
```
`$()` の形式を使えば、文字列の中に式を埋め込むこともできます。

```julia
julia> "In 5 years, I will be $(age + 5) years old."
"In 5 years, I will be 35 years old."
```


### 演習
1. `a = hello` (クォートなし) と入力するとどうなるでしょうか? シングルクォートとダブルクォートの違いは何でしょうか?
2. 文字列に数を掛けるとどうなりますか? エラーメッセージを読んでみましょう。
3. `string` 関数は何をする関数でしょうか? 数値、文字列、変数に対してそれぞれ試してみましょう。


## 問題
1. 新しいファイルを作って、3 年間が何秒になるかを計算しましょう。途中の値を変数に代入して使ってください。

2. Julia では `pi` という定数が π (3.14159...) の値を表します。
`\pi` と入力して Tab を押すと、ギリシャ文字の `π` を入力することもできます。
半径 5 の円の面積を `pi` または `π` を使って計算してみましょう。
半径を変数に代入し、それを使って計算してください。
計算結果も変数に代入することを忘れずに。

3. Beer-Lambert 則は、試料の吸光度 $A$ をモル吸光係数 $\varepsilon$、濃度 $c$、光路長 $\ell$ と $A = \varepsilon \cdot c \cdot \ell$ の関係で結びつけます。$\varepsilon = 1500$ M⁻¹·cm⁻¹、$c = 0.001$ M、$\ell = 1$ cm の試料の吸光度を計算してみましょう。各入力を変数に代入し、結果も別の変数に代入してください。
