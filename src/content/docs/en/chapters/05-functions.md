---
title: Functions
---

Functions are used to organize code and make it reusable.
Once it is written, you don't have to think about how it works.
Solving a large problem is much easier by building up from smaller functions that perform specific tasks.

Functions in programming operate similarly to mathematical functions.
They take inputs (arguments) and produce outputs (return values).
The difference is that programming functions can take and return more than just numerical values.
They perform operations on data, manipulate variables, and control the flow of a program.


## Built-in functions
Julia has many built-in functions, and you can also define your own functions.
We have already seen basic functions like `*` and `+` for multiplication and addition.
Other built-in mathematical functions include: `sin`, `cos`, `exp`, `log`, `sqrt`, `abs`, `round`, `floor`, `ceil`, `max`, `min`.
Non-numerical functions include: `length`, `size`, `typeof`, `print`, `println`, `push!`, `pop!`, `sort`, `reverse`, and many more.

Play around with these functions in the REPL. The examples below illustrate the variety of built-in functions available — you don't need to work through every one.

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


## User-defined functions
User-defined functions are the heart of programming.
This is the first step towards writing code to solve complex problems, automate tasks, and share your work with others.

You can define your own functions in Julia using the `function` keyword.
Let's define a simple function that takes a number as input and returns that number plus one.

```julia
function add_one(x)
    return x + 1
end

y = 10 + add_one(5)
```
The `return` keyword can be omitted in Julia if it is the last line of the function.
The block above can be rewritten as

```julia
function add_one(x)
    x + 1
end
```

You can also define a function in a single line using the `=` operator.

```julia
add_one(x) = x + 1
```
This shorthand way makes mathematical functions easier to read and write. They look just like regular mathematical notation.

```julia
f(x) = x^2 + 2x + 1
```

A function does not have to return anything. It can just perform an action.

```julia
function print_twice(x)
    print(x)
    print(x)
end

print_twice("Hello")
```

The variable `x` is a parameter and it is a dummy variable just like in a mathematical function, like the $x$ in $f(x) = x^2$.
When you call the function, you can pass in any value for `x`, and the function will use that value in its calculations.
It is internal to the function and only exists within the function's scope.

Operators like `*` and `+` are also functions in Julia, but have a special syntax called *infix notation*.
For example, you can write `3 * 5` or `*(3, 5)`.

Let's try another example that squares a number.

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

You can see that the function automatically works with different types of inputs.
This is one of the powerful features of Julia: it can automatically determine the type of the input and return the appropriate type for the output.
This is allowed because of Julia's "multiple dispatch" functionality and is a key feature of Julia's design.

### Exercises
1. Write a function that checks if a number is even. It should return `true` if the number is even and `false` otherwise.

    ```julia
    is_even(x) = # your code here
    ```

2. Write a function that takes two strings and joins them together with a space in between.

    ```julia
    join_with_space(a, b) = # your code here
    ```


## Problems
1. Calculate the energy in eV for photons of wavelengths 620 nm, 310 nm, and 1240 nm.
    ```julia
    function wavelength_to_ev(wavelength_in_nm)
        # Your code here
    end

    using Test
    @test photon_energy(620) ≈ 2.0 atol=1e-2
    @test photon_energy(310) ≈ 4.0 atol=1e-2
    @test photon_energy(1240) ≈ 1.0 atol=1e-2
    ```

2. Write a function that returns the quadrant (1, 2, 3, 4) of a point (x, y) in 2D Cartesian space.

    *Bonus: What should the function return if the point is on an axis or the origin?*

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

3. There is a famous conjecture in mathematics ([the Collatz conjecture](https://en.wikipedia.org/wiki/Collatz_conjecture)) that states that any positive integer can be reduced to 1 by repeated application of these rules:
    1. If the number is even, divide it by two.
    2. If the number is odd, triple it and add one.

    Write a function that produces a sequence of numbers starting from a positive integer $n$ and applying the rules above until it reaches 1.

$$
f(n) = \begin{cases}
    n/2 & \text{ if } n \text{ is even} \\
    3n + 1 & \text{ if } n \text{ is odd}
\end{cases}
$$
