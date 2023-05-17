# Lesson 1: Julia Basics and Fitting

Open the file in the `lessons` directory titled `lesson 1.jl` and follow along.

Goals:
1. Learn the basics of Julia
2. Build a simple least squares fitting script
3. Make a plot of the results

Let's say we measure a molecular vibrational decay and we want to
know the lifetime of the molecule. If you took some chemistry, 
you may know that it should be an exponential decay of some sort.
We can write a function that describes the decay and then fit
the data to that function. We won't go into the details of how
fitting algorithms work, or what least-squares fitting is. This
tutorial just focuses on fitting in Julia.

First we need a fitting function. There are two ways to write
functions in julia: a quick one-line function, or a 
traditional multi-line function. The quick syntax feature
makes functions look like math equations. You can type unicode
characters in Julia, so you can even include Greek symbols. 
For example, you can write `τ` by typing `\tau` and then pressing
`tab`. You can even perform operations on emoji, if you so choose.

Here's that exponential decay function using quick syntax:
```
f(x, τ) = exp(-x/τ)
``` 

A traditional function looks like this:

```
function f(x, A, τ, y0)
    return A * exp(-x / τ) + y0
end
```
where we also included an amplitude `A` and a y-offset `y0`.

The `return` keyword is optional, but it is good practice to
include it since other languages may require it.
The last line of a function is always returned in Julia.

Next we will make some fake data to fit. Let's make 
linearly spaced x values from 0 to 20. We can do this using
the simple syntax `0:20`, which automatically increments
by 1. We can also specify the increment by typing `0:0.1:20`,
which starts at `0`, increments by `0.1`, and ends at `20`.
You should try this for yourself in the command line or
in VS Code. For more complex ranges, you can use the `range`
function. In the REPL, type `?range` to find out how to do this.
(You don't need to press `return` after typing `?`. The
REPL automatically goes into help mode and you will see `help?>`).

Next we will make the y-axis data using our exponential model.
Let's set an amplitude of `A = 6.0`, a lifetime of `τ = 3.0`, and
a y-offset of `y0 = 0.1`. But if we just try
`y = f(x, 2.0, 3.0, 0.1)`, we will get an error.
Can you see why? Stop for a minute and think about what the code is doing.

## Intermission! Come back in a few minutes.

## Vectorization and dot syntax

The error is because we are trying to pass an array `x` to a function
that expects a single value. Traditionally, we would use a `for` loop
to iterate through each element of `x` and calculate `y`.
Many technical-computing languages (Matlab, Python/Numpy, or R) have a feature called
**vectorization**, where you can operate on a whole array.
In Julia, there is a convenient notation to do this using [dot syntax](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized).

Let's try an example in [the Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/):
```
julia> g(x) = 4x + 1

julia> a = [1.0, 2.0, 3.0]

julia> g.(a)
3-element Vector{Float64}:
  5.0
  9.0
 13.0
 ```

Finally, let's add random gaussian noise to the data and
use the parameters defined earlier.

```
xdata = 0:0.1:20
ydata = f.(xdata, 6.0, 3.0, 0.1) .+ 0.2 * randn(length(xdata))
```
A more convenient way to do this would be to use the `@.` macro, which distributes the dot syntax to all operations in the expression.

```
@. ydata = f(xdata, 6.0, 3.0, 0.1) + 0.2 * randn(length(xdata))
```

The function `randn()` generates random numbers from a normal
distribution with mean 0 and standard deviation 1. The `length`
function returns the number of elements in an array, and we
use it here to make an array of random numbers the same length
as `xdata`.

## Fit and plot

Next we perform the fit. We will use the `curve_fit()` function
from the `LsqFit` package. `curve_fit()` takes
four arguments: the fitting function, the x data, the y data, and an initial guess  for the parameters.
You can find the tutorial for the `LsqFit` package [here](https://github.com/JuliaNLSolvers/LsqFit.jl).

Finally, we use the plotting package Makie to generate
a plot of our data and the fit. First we must create a blank `Figure()` object.
The `Figure` can hold a grid of plots, buttons, sliders, labels,
and other things. We will just use a single plot for now.

Next we draw an empty `Axis` object on the `Figure` that takes the
first row and first column. Then, we make a `scatter!` plot
of the data and a `lines!` plot of the fit. Finally, we add
a bit of `text!` that displays the fit results and a legend.
(The exclamation mark `!` means that the function modifies
the object in place. This is a convention in Julia.)
Type `display(fig)` anywhere or `fig` at the end to display the plot.

```
fig = Figure()

ax = Axis(fig[1, 1])

scatter!(xdata, ydata, label="data")
lines!(xdata, model(xdata, fit.param), label="fit")
text!("τ = $(τ)\nA = $(A)", position = (12, 4.5))

axislegend(ax)

fig
```

Play around with this code to change the figure.
Can you put the two plots on different axes side by side?
Makie is a quite powerful program with the ability to create
interactive plots, 3D plots, and even simple GUIs.
You can find out more on the [Makie website](https://docs.makie.org).


## Resources

If you need some help remembering least squares fitting, here are some resources:

- Least Squares Fitting on [Wolfram MathWorld](https://mathworld.wolfram.com/LeastSquaresFitting.html)
- [Basic tutorials on residuals and least squares regression](https://www.khanacademy.org/math/ap-statistics/bivariate-data-ap/xfb5d8e68:residuals/v/regression-residual-intro)
- Ledvij, M. "[Curve Fitting Made Easy](http://physik.uibk.ac.at/hephy/muon/origin_curve_fitting_primer.pdf)." Industrial Physicist 9, 24-27, Apr./May 2003.
