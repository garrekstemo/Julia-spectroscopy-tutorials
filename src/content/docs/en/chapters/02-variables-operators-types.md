---
title: Variables, operators, and types
---

Open the REPL (the command line interface for Julia) by typing `julia` in the terminal.
REPL stands for Read-Eval-Print Loop.

Follow along with the code examples below in the REPL.
Try things out yourself and play with the code as you go.
Before running each snippet, pause and ask yourself, "What do I think will happen?" — it's a habit worth developing, and the same mindset transfers naturally to setting up experiments and interpreting their results.


## Assignment and basic operations
Start with basic operations on one variable.
In programming, `=` is used for assignment, not equality.

For example, `a = 2` means "assign the value 2 to the variable `a`".
In programming, we can write the following:
```julia
a = a + 1
```
This means "assign the value of `a + 1` to `a`".
In mathematics, this makes no sense, but in programming, it is perfectly valid.

Here are some basic operations you can do with numbers in Julia:
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

Notice that `a / 2` returns `1.0` even though both operands are integers. In Julia, `/` always returns a `Float64`, regardless of input types. If you want integer (floor) division, use `÷` (typed `\div<Tab>`); for an exact rational result, use `//`:

```julia
julia> 7 / 2
3.5

julia> 7 ÷ 2
3

julia> 7 // 2
7//2
```


### Exercises

1. Find the value of `x` at the end of this block of code.

    ```julia
    x = 3
    y = x
    x = x + 1
    x = y
    ```

2. What happens if you try to use a variable that has not been defined yet?

    ```julia
    cats = 5
    Cats
    ```


## Types
We can use the `typeof` function to check the type of a variable.
Now let's create some variables of different types and explore Julia's type system.

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


### Exercises
1. Try operations with different types (like `1 + 2.0`). What happens?
2. What is the type of operators like `*` and `+`?


## Unicode variable names
Julia variable names can be Unicode characters, which is handy for matching the notation in physics and math. In the REPL or VS Code, type a LaTeX-style command followed by `Tab` to insert the symbol.

```julia
julia> λ = 620  # \lambda<Tab>
620

julia> ν = 1e7 / λ  # \nu<Tab>
16129.032258064515

julia> α, β = 0.1, 0.9  # \alpha<Tab>, \beta<Tab>
(0.1, 0.9)
```

Greek letters, subscripts, primes, and many other symbols are supported. The Julia manual lists [all available completions](https://docs.julialang.org/en/v1/manual/unicode-input/).


## Strings
Text data is represented as a sequence of characters called a string.
String can be operated on, but the operations are different from those for numbers.

```julia
julia> s = "hello"
"hello"

julia> s * s  # string concatenation
"hellohello"

julia> s^3
"hellohellohello"
```

There are also multi-line strings, which are defined with triple quotes.

```julia
"""
This is a multi-line string.
It can span multiple lines.
It is useful for writing long text or documentation.
"""
```

We can also return a character from a string by indexing.
We can get the third to eighth characters of a string by using the colon operator `:`.

```julia
julia> s = "Hello world"
"Hello world"

julia> s[1]  # first character
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> s[3:8]  
"llo wo"
```


### String interpolation
String interpolation is a way to include variables or expressions inside a string.
You can use the `$` symbol to interpolate a variable or expression into a string.

```julia
julia> name = "Alice"
"Alice"

julia> age = 30
30

julia> "My name is $name and I am $age years old."
"My name is Alice and I am 30 years old."
```
You can also use `$()` syntax to include expressions inside a string.

```julia
julia> "In 5 years, I will be $(age + 5) years old."
"In 5 years, I will be 35 years old."
```


### Exercises
1. What happens when you type `a = hello` (no quotes)? What is the meaning of the single and double quotes?
2. What happens if you try to multiply a string by a number? Read the error message.
3. What does the function `string` do? Try it on a number, a string, and a variable.


## Problems
1. In a new file, calculate how many seconds there are in 3 years. Use variables to assign intermediate values.

2. In Julia, `pi` is a constant that represents the value of π (3.14159...).
You can also use `π` (the Greek letter pi) by typing `\pi` and pressing `Tab`.
Calculate the area of a circle with radius 5 using `pi` or `π`.
Assign the radius to a variable and use it in the calculation.
Make sure to assign the result to a variable, also.

3. The Beer-Lambert law relates the absorbance $A$ of a sample to its molar absorptivity $\varepsilon$, concentration $c$, and path length $\ell$ as $A = \varepsilon \cdot c \cdot \ell$. Calculate the absorbance for a sample with $\varepsilon = 1500$ M⁻¹·cm⁻¹, $c = 0.001$ M, and $\ell = 1$ cm. Assign each input to a variable, then assign the result to another variable.
