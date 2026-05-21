---
title: Iteration
---

## *While* statements
While loops allow you to execute a block of code as long as a condition is true.
The code block below will print the numbers from 1 to 10 by incrementing a variable `i` by 1 with each iteration.

```julia
n = 5
while n > 0
    println(n)
    n = n - 1
end
println("Blast off!")
```

While loops can be tricky because if the condition never becomes false, the loop will run indefinitely.
```julia
while true
    println("This will run forever!")
end
```


## *For* statements
For loops allow you to iterate over a range of values or elements in a collection.
```julia
fruits = ["apple", "banana", "cherry"]
for fruit in fruits
    println(fruit)
end
```

In Julia, the `:` operator can be used to create ranges.
For example, `1:5` creates a range from 1 to 5.
Let's use this notation to print the numbers from 1 to 10.

```julia
for i in 1:10
    println(i)
end
```

You can also specify a step between the start and stop using `start:step:stop`:

```julia
for i in 1:2:10
    println(i)  # prints 1, 3, 5, 7, 9
end

for x in 0.0:0.1:1.0
    println(x)  # prints 0.0, 0.1, ..., 1.0
end
```


## `break` and `continue`
You can exit a loop early with `break`, or skip ahead to the next iteration with `continue`.

```julia
for i in 1:10
    if i > 5
        break  # stops the loop entirely
    end
    println(i)
end

for i in 1:10
    if iseven(i)
        continue  # skip this iteration
    end
    println(i)  # prints only odd numbers
end
```


## Iterating with an index
Sometimes you need the index as well as the value while iterating. Julia has a few helpers for this.

`eachindex` returns the valid indices of a collection. Prefer it over `1:length(x)` — it works for arrays that don't start at index 1 and is generally safer.

```julia
v = [10.0, 20.0, 30.0]
for i in eachindex(v)
    println("v[$i] = $(v[i])")
end
```

`enumerate` pairs each element with its position:

```julia
for (i, value) in enumerate(v)
    println("position $i: $value")
end
```

`zip` lets you iterate over two collections in parallel:

```julia
wavelengths = [400, 500, 600]
intensities = [0.2, 0.9, 0.5]
for (λ, I) in zip(wavelengths, intensities)
    println("λ = $λ nm, I = $I")
end
```


## List comprehensions
A *comprehension* is a compact way to build a vector by transforming each element of a range or collection. The syntax mirrors set-builder notation in mathematics.

```julia
julia> squares = [i^2 for i in 1:5]
5-element Vector{Int64}:
  1
  4
  9
 16
 25
```

You can filter elements with an `if` clause:

```julia
julia> evens = [i for i in 1:10 if iseven(i)]
5-element Vector{Int64}:
  2
  4
  6
  8
 10
```

Comprehensions can use any expression on the left of `for`, including function calls. They are a Julia idiom — you will see them everywhere.


## Problems
1. Use a `for` loop to compute the sum of all integers from 1 to 100. (The total should be 5050.)

2. Use a list comprehension to build a vector containing the squares of the integers from 1 to 10.

3. Given the vector below, write a loop that finds the index where the value is largest. (Don't use `argmax`.)

    ```julia
    y = [0.1, 0.3, 0.5, 1.2, 0.8, 0.4, 0.2]
    # Your code here. Expected result: 4.
    ```

4. A *moving average* smooths a noisy signal by averaging neighboring points. Given a vector `y` and a window size `w`, compute a new vector whose `i`-th element is the mean of `y[i:i+w-1]`. Test it on:

    ```julia
    y = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    w = 3
    # Expected result: [2.0, 3.0, 4.0, 5.0, 6.0]
    ```
