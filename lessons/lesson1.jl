using GLMakie
using LsqFit

# Let's write a model of our data as a decaying exponential function, defined
# f(x) = Ae^{-x / τ} + y0

model(x, p) = p[1] * exp.(-x / p[2]) .+ p[3]


# Generate fake data and add noise to y.
xdata = 0:0.5:20
ydata = model(xdata, [6.0, 3.0, 0.1]) + 0.25 * randn(length(xdata))

# Perform the fit using the LsqFit package
p0 = [0.5, 0.5, 0.0]  # initial guess for parameters
fit = curve_fit(model, xdata, ydata, p0)
params = fit.param  # access the fit results


A = round(params[1], digits = 2)
τ = round(params[2], digits = 2)
y0 = round(params[3], digits = 2)

# Make the figure
fig = Figure()

ax = Axis(fig[1, 1], title = "Exponential Curve Fit", xlabel = "τ", ylabel = "Signal")

scatter!(ax, xdata, ydata, label = "data")
lines!(ax, xdata, model(xdata, fit.param), color = :orangered, label = "fit")

text!("τ = $(τ)\nA = $(A)", position = (12, 4.5))

axislegend(ax)
fig