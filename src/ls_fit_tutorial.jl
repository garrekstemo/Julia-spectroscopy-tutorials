using LsqFit
using GLMakie

# Least Squares Fit Tutorial

# Goals:

# 1. Learn the basics of Julia and cool/convenient features of Pluto notebooks. 
# 2. Build a simple least squares fitting algorithm in Julia.


# Let's say we want to model our data on a decaying exponential function, defined as
# f(x) = Ae^{-τx}
# Julia has a quick syntax feature, so we can write functions that look like equations.

f(x, A, τ, y0) = A * exp(-τ * x) + y0  # write τ by typing "\tau" and then press "tab"

# We can also write traditional functions (with docstrings) like this:
"""
    myfunction(x, A, σ)

Gaussian function with amplitude `A` and width `σ`.
"""
function myfunction(x, x0, A, σ)
    return A * exp(-(x0 - x)^2 / (2 * σ^2))
end


# Generate fake data and add noise to y.
xdata = 0:0.5:20
ydata = f.(xdata, 5.0, 0.2, 0.1) .+ 0.2 * randn(length(xdata))


# Now let's write a simple algorithm to fit the data.
@. ymodel(x, p) = f(x, p[1], p[2], p[3])

p0 = [0.5, 0.5, 0.0]  # initial guess for parameters
fit = curve_fit(ymodel, xdata, ydata, p0)  # perform the fit
params = fit.param
cov = estimate_covar(fit)
error = stderror(fit)
se = stderror(fit)

A = round(params[1], digits = 2)
τ = round(params[2], digits = 2)
y0 = round(params[3], digits = 2)

# Make the figure
fig = Figure()

ax = Axis(fig[1, 1], title = "Exponential Curve Fit", xlabel = "τ", ylabel = "Signal")

scatter!(ax, xdata, ydata, label = "data")
lines!(ax, xdata, f.(xdata, params[1], params[2], params[3]), color = :orangered, label = "fit")

text!("τ = $(τ)\nA = $(A)", position = (12, 4.5))

axislegend(ax)

fig


# Now let's try fitting by minimizing a cost function. Let's start with a simple example.
# Again, we have some data and we want to fit a function to match the data.
# This data seems to be linear, so we could write the following:

# y(x) - y_data(x)

# but this way, negative and positive values might cancel.
# To avoid this, we square the difference and sum over all points:

#∑ (y(x) - y_data(x))^2


## Resources

# - Least Squares Fitting on [Wolfram MathWorld](https://mathworld.wolfram.com/LeastSquaresFitting.html)
# - [Basic tutorials on residuals and least squares regression](https://www.khanacademy.org/math/ap-statistics/bivariate-data-ap/xfb5d8e68:residuals/v/regression-residual-intro)
# - Ledvij, M. "[Curve Fitting Made Easy](http://physik.uibk.ac.at/hephy/muon/origin_curve_fitting_primer.pdf)." Industrial Physicist 9, 24-27, Apr./May 2003.
