# Basics of Programming in Julia

This lesson is a quick overview of basic programming concepts using the Julia language and the REPL.

Goals
1. Download and install [Microsoft Visual Studio Code](https://code.visualstudio.com/) (perhaps the most popular code editor in the world right now.)
2. Download and install [Julia](https://julialang.org/downloads/)
3. Learn the basics of programming in Julia (variables, if / else, loops, functions)
4. Learn to load a basic data file
5. Make a pretty graph


## A Tour of Visual Studio Code

1. Click "Open Folder"
2. Choose a place where you want to keep all of your coding projects now and in the future
3. Make a new folder called "projects" or something similar
4. Make a new folder for this project called "julia basics"
5. Click "Open"

### Addition, subtraction, multiplication, division

```
a = 2
b = 3.0

typeof(a)
typeof(b)

# output suppressed / write multiple lines
c = a + b;
b * c

typeof(c)

a * 4

a = a * 2
a *= 2
b += 3
```

### Mathematical notation uncommon in other languages

```
function f(x, y)
    return \sqrt(x^2 + y^2)
end

f(3, 4)
```

compact syntax
```
g(x, y) = \sqrt(x^2 + y^2)
g(3, 4)
```

Can even write unicode characters

```
\Delta
\gamma
\pi
```


if-else
```
function h(x)
    if 0 < x < 3
        return x
    else
        return 0
    end
end

h(2)

h(5)
```

## Broadcasting

```
p(x) = x^3 - 4x^2 + 2x

A = [1 2 3;
     4 5 6;
     7 8 9]

p(A)
```

What if we want to perform this function element-wise?

```
broadcast(p, A)

p.(A)

q(x) = exp.(x) .+ x

@. q(x) = exp(x) + x
```



- Matrices and matrix operations
- types (`dump`, `typeof`)


## Open a file

Send some example files in the Discord.
Use DelimitedFiles or DataFrames + CSV to read in the data.
Then plot the data using GLMakie.



## Making plots

```
using GLMakie
GLMakie.activate!(inline=false)

f, ax, l = lines(x, y)

fig = Figure()
ax = Axis(fig[1, 1])
lines!(x, y)
fig

```


## Resources

[Official Julia Documentation](https://docs.julialang.org/)

[Julia tutorials list](https://julialang.org/learning/tutorials/)

[The Julia WikiBook](https://en.wikibooks.org/wiki/Introducing_Julia)

[The Julia Express](https://ucidatascienceinitiative.github.io/IntroToJulia/)