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

In Julia, the `:` operators can be used to create ranges.
For example, `1:5` creates a range from 1 to 5.
Let's use this notation to print the numbers from 1 to 10.

```julia
for i in 1:10
    println(i)
end
```


## Problems
1. Write a function that take a positive integer and returns the sum of all integers from 1 to that number using a `for` loop.
