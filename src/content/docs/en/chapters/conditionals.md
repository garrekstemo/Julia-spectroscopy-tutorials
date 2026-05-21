---
title: 3. Conditionals
---

## Boolean expressions
A boolean expression is a statement that is either `true` or `false`.

```julia
julia> t = true
true

julia> f = false
false
```

We can use the `typeof` function to check the type of a boolean variable.

```julia
julia> typeof(true)
Bool

julia> typeof(false)
Bool
```

## Comparison operators
Comparison operators are used to compare values and return a boolean value.
Let `a = 1` and `b = 2`. The comparison operators are:

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

### Exercises
1. What is the type result returned by `1 == 2`?
2. What is the difference between `==` and `===`?
3. Make the statement `"Hello world"[i:j] == "o wo"` return `true`.


## Logical operators
Logical operators are used to perform logical operations on boolean values.
There are three logical operators in Julia: `&&` (AND), `||` (OR), and `!` (NOT).
The logical operators are used to combine boolean expressions.

```julia
julia> t && f  # logical AND
false

julia> t || f  # logical OR
true

julia> !t  # logical NOT
false
```
For complicated expressions, we can use parentheses to group operations.
```julia
julia> (a < b) && (b > 0)  # true
true
```


### Exercises
1. Let `x = 5` and `y = 10`. What is the result of the following expression?

    ```julia
    !(x > 0) && y < 0
    ```


## If statements
If statements allow you to execute code conditionally based on a boolean expression.
For example, you can use `if` to check if a number is greater than zero.

```julia
x = 5
if x > 0
    println("x is positive")
end
```

This statement will print "x is positive" because `x` is greater than zero.
If `x` were less than or equal to zero, the code inside the `if` block would not execute.
Nothing happens.
Usually, you want to do something if the condition is false, so you can use `else` to specify an alternative block of code.

```julia
x = -5
if x > 0
    println("x is positive")
else
    println("x is not positive")
end
```

There is a third option called `elseif` that allows you to check multiple conditions.
Let's use this to check if a number is positive, negative or zero.

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


### Exercises
1. Write a program that prints a message based on the temperature. For example:

    Below 0: "It's freezing!" \
    Between 0 and 20: "It's cold." \
    Between 20 and 30: "It's warm." \
    Above 30: "It's hot!"


## Short-circuit evaluation
The logical operators `&&` and `||` use *short-circuit* evaluation: they only evaluate the second operand when its value is needed to determine the result. This is often used as a compact alternative to `if`:

```julia
x = 5
x > 0 && println("x is positive")   # prints only when x > 0
x > 0 || println("x is not positive")  # prints only when x <= 0
```

This pattern is common in Julia.


## The ternary operator
The ternary operator `? :` is a one-line `if/else` that returns a value:

```julia
x = 5
sign = x > 0 ? "positive" : "non-positive"
```

Use it for short conditional expressions; for longer logic, prefer a full `if/else` block.


## The `in` operator
The `in` operator checks whether a value belongs to a collection or range:

```julia
julia> 3 in 1:10
true

julia> 5 in [1, 2, 3]
false

julia> 'a' in "banana"
true
```

This is often more readable than chaining comparisons.


## Problems
1. Complete the following program so that it prints only the even numbers between 1 and 10 that are not divisible by 4.

    ```julia
    for i in 1:10
        if # Your code here. This should return `true`.
            println(i)
        end
    end
    ```

2. Try fixing the logic in this conditional. It's supposed to check if x is between 10 and 20, inclusive.
Why doesn't the original code work as expected?

    ```julia
    x = 15
    if x > 10 || x < 20
        println("x is between 10 and 20")
    else
        println("x is not between 10 and 20")
    end
    ```

3. Given a wavelength `λ` in nanometers, write a program that prints the spectral region it falls in:

    - UV: 10–400 nm
    - Visible: 400–700 nm
    - NIR (near-infrared): 700–2500 nm
    - MIR (mid-infrared): 2500–25000 nm
    - Anything outside this range: "out of range"

    Test it with `λ = 254` (germicidal UV), `532` (green laser), `1550` (telecom), and `10000` (CO₂ laser).
