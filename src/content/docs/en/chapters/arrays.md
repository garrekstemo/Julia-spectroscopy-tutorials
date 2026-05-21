---
title: 6. Arrays
---

Arrays are a collection of elements usually of the same type and usually stored in contiguous memory locations.
They are a fundamental data structure used for storing lists, searching, and sorting data.
Arrays in Julia can contain the same type or a mixture of types.
They are also **mutable**, which means that you can change the elements of an array after the array has been created.
A one-dimensional `Array` is called a `Vector` in Julia.
Let's look at some simple examples of how vectors work in Julia.

```julia
julia> [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3
```

If all the elements can be converted to the same type, Julia will infer the type of the array.
In this example, Julia promotes the integers to floats.
```julia
julia> [1, 2.2, 3]
3-element Vector{Float64}:
 1.0
 2.2
 3.0 
```

If the elements are of different types that cannot be converted, the array is given the most general type. In the example below, the array contains strings, a float, an int, and a bool.
These types cannot be promoted to a single type like in the previous example, so the vector will be of type `Any`.
```julia
julia> a = ["hello", 2.0, 3, false, "🌵"]
5-element Vector{Any}:
    "hello"
    2.0
    3
false
    "🌵"
```

We can find out the number of elements in an array using the `length` function.
```julia
julia> length(a)
5
```

And we can find out if an element is in an array using the `in` function, which will return either `true` or `false`.
```julia
julia> "hello" in a
true
```


## Indexing and slicing
You can access elements of an array using *indexing*.
Julia uses 1-based indexing, which means that the first element of an array is at index 1 (many languages start at 0).

```julia
a = ["hello", 2.0, false, "🌵", 6]
a[1]  # returns "hello"
a[2]  # returns 2.0
a[end-1]  # returns "🌵"
```

Elements in a list can be reassigned using their index.
In the following example, we change the first element of the array `v` to 5.
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

Subarrays can be extracted by *slicing* with `i:j` notation.
```julia
a = ["hello", 2.0, false, "🌵", 6]
a[1:2]  # returns ["hello", 2.0]
a[3:end]  # returns [false, "🌵", 6]
```

We can step through the array with a step size.
Here, we step through the array with a step size of 2.
```julia
a = ["hello", 2.0, false, "🌵", 6]
a[1:2:end]  # returns ["hello", false, 6]
```

We can also step *backwards* through the array using a step of -1.
```julia
a = ["hello", 2.0, false, "🌵", 6]
a[end:-1:1]  # returns [6, "🌵", false, 2.0, "hello"]
```


### Exercises
1. Consider an array created as follows:

    ```julia
    x = 3
    my_array = [1, 2, x]
    ```
    What happens to `my_array` if `x` is changed after the array is created?


## Range objects
Often we want to create a list of numbers linearly spaced between a start and stop value, like the numbers from 1 to 10.
This is easy to using range objects. 
For example, `r = 1:10` is a `UnitRange` object that represents the numbers from 1 to 10 with step size 1 (Unit means a step size of 1).
You can also create a range object with an arbitrary step size.
For example, `r = 1:2:10` represents the numbers from 1 to 10 with a step size of 2 (a `StepRange` object).

Range objects are memory-efficient; they do not store all of their numbers in memory.
They just store the start, stop, and step size.
We can use the `dump` function to examine their structure.
Try using `dump()` on the range object `1:2:10` and compare it to a `Vector` object created using `[1, 2, 3]` (called an "array literal").
You can see that `1:2:10` contains a start value, a stop value, and a step size but does not store the numbers 1 through 10.
A UnitRange object is even lazier; it only stores the start and stop values.
See [this StackOverflow post](https://stackoverflow.com/questions/55438134/creating-arrays-from-ranges-in-julia-without-using-collect) for a detailed discussion.
If you need all of the numbers in a range you can use `collect()` to create new array with the elements of the range object.

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

If you need more specificity you can use the `range()` function.
There are several ways to use this function, but here are just a couple of examples.
```julia
julia> range(1, stop=10, step=2)
1:2:9

julia> range(1, step=0.5, length=5)
1.0:0.5:3.0
```


## Multi-dimensional arrays
Matrices are two-dimensional arrays in Julia.
The elements of a row of a matrix are separated by spaces.
Rows are separated either by semicolons or newlines.

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

There are several other ways to create complex arrays.
These are detailed in the documentation.

We can retrieve the dimensions of the matrix with the `size` function.
```julia
julia> size(A)
(2, 3)
```

Getting an element from the matrix is similar to getting an element from a vector, but we specify the row and column.
 ```julia
julia> A[2, 3]
6
```

You can also get a whole row or column of the matrix.
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


## Creating and manipulating arrays
There are many ways to construct arrays in Julia, including a few provided functions.
The `rand` function creates an array of random numbers.
Often we want a normal distribution, which can be achieved with the `randn` function.
This is useful for creating gaussian noise in simulations, for example.
We will use it later.

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

You can also create an array of zeros, ones, or an arbitrary value.
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

We can also use the `push!` function to add an element to the end of an array.

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

A useful way to use this is to create an empty array and then add elements to it with a `for` loop.
We can include a calculation in the loop and add the results to the array.
```julia
a = []
for x in 1:5
    y = x^2
    push!(a, y)
end
```

We can remove elements from an array using `pop!` (remove the last element from an array) and `popat!` (remove an element at an arbitrary index).
These two functions also return the element that was removed.
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


### Exercises
1. Create an array of 5 random numbers between 1 and 20 using the `rand` function.

2. Create a 2D array of random numbers between 1 and 20 with 2 rows and 3 columns.


## Iteration
Two common ways to iterate over an array are to iterate over each element in the array and iterate over each index, the position of the element.

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

If you need both the value and the index, you can use the `enumerate` function.
```julia
fruits = ["apple", "banana", "cherry"]
julia> for (i, fruit) in enumerate(fruits)
           println("$i: $fruit")
       end
1: apple
2: banana
3: cherry
```

There are special functions that allow you to iterate over rows and columns of a matrix
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


## Broadcasting
Broadcasting allows you to apply a function to each element of an array or collection.
Dot `.` syntax is a convenient notation to apply a function element-wise.
This is also known as [vectorizing](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized) a function.
You can perform element-wise operations using the `.*`, `./`, and `.^` operators.
Let's see some examples.

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

It is also possible to define a function that takes a vector as input and returns a vector as output.
```julia
v = [1, 2, 3]
f(x) = x .+ 1
f(v)  # returns [2, 3, 4]
```

or using the `@.` macro, another convenience feature.
```julia
julia> @. f(x) = x + 1
f (generic function with 1 method)

julia> f(v)
3-element Vector{Int64}:
 2
 3
 4
```


### Exercises
1. Consider the following function:

    ```julia
    f(x) = x^2 + 1
    ```
    What happens if you try to apply this function to an array?


## Comprehensions
Comprehensions are a powerful way to construct arrays.
In the following example, we create a new array with the squares of the even numbers from 0 to 5.
Here are some examples.

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


### Exercises
1. Use a comprehension to create an array of numbers 1 to 100 that are divisible by 7.


## Problems
1. Write a function that initializes a vector of ten random integers and returns every element at an even index.

2. For a vector of integers, write a function that removes the middle element if the vector length is odd and the middle two if the length is even. For example, if the vector is `[1, 2, 3, 4, 5]`, the result should be `[1, 2, 4, 5]`.


## Table of useful functions

### Constructing arrays
| Function | Description |
|----------|-------------|
| `zeros(n)` | Creates an array of `n` zeros |
| `ones(n)` | Creates an array of `n` ones |
| `fill(x, n)` | Creates an array of `n` elements, all equal to `x` |
| `rand(n)` | Creates an array of `n` random numbers from a uniform distribution |
| `randn(n)` | Creates an array of `n` random numbers from a normal distribution |
| `collect(r)` | Creates an array from a range object `r` |


### Inspecting arrays
| Function | Description |
|----------|-------------|
| `length(a)` | Returns the number of elements in array `a` |
| `in(x, a)` | Returns `true` if `x` is in array `a` |
| `size(a)` | Returns the dimensions of array `a` |
| `findall(f, a)` | Returns the indices of elements in `a` that satisfy the condition `f` |
| `findfirst(f, a)` | Returns the first index of an element in `a` that satisfies the condition `f` |
| `findlast(f, a)` | Returns the last index of an element in `a` that satisfies the condition `f` |


### Modifying arrays in-place
| Function | Description |
|----------|-------------|
| `push!(a, x)` | Adds element `x` to the end of array `a` |
| `append!(a, b)` | Adds array `b` to the end of array `a` |
| `pop!(a)` | Removes the last element of array `a` |
| `popat!(a, i)` | Removes the element at index `i` of array `a` |
| `deleteat!(a, i)` | Removes the element at index `i` of array `a` |
| `sort!(a)` | Sorts array `a` in-place |
| `reverse!(a)` | Reverses array `a` in-place |


### Transforming arrays
| Function | Description |
|----------|-------------|
| `map(f, a)` | Applies function `f` to each element of array `a` |
| `sort(a)` | Returns a sorted copy of array `a` |
| `reverse(a)` | Returns a reversed copy of array `a` |
| `filter(f, a)` | Returns a new array containing elements of `a` that satisfy the condition `f` |


### Concatenating (combining) arrays
| Function | Description |
|----------|-------------|
| `vcat(a, b)` | Concatenates arrays `a` and `b` vertically (row-wise) |
| `hcat(a, b)` | Concatenates arrays `a` and `b` horizontally (column-wise) |
| `cat(a, b, dims)` | Concatenates arrays `a` and `b` along the specified dimension `dims` |


## Bonus: [Generator expressions](https://docs.julialang.org/en/v1/manual/arrays/#man-generators)
There are many ways to programmatically create arrays in Julia.
One way is to apply a function to each element of an array.
For example, if we want to apply a function `square` to each element of a vector containing integers from 0 to 5, we can use the `map` function.

```julia
square(x) = x^2
map(square, 0:5)  # returns [0, 1, 4, 9, 16, 25]
```
Another method is to filter the elements of an array.
For example, if we want to filter the even numbers from a vector containing integers from 0 to 5, we can use the `filter` function and the function `iseven` that returns true if a number is even.

```julia
filter(iseven, 0:5)  # returns [0, 2, 4]
```

Sometimes we don't want a lazy array. If we want each element in an array to be stored in memory, we can use the `collect` function.
```julia
collect(0:5)  # returns [0, 1, 2, 3, 4, 5]
```