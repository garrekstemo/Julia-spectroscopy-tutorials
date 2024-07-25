using GLMakie
using Optim

function square_error(p, f, X, Y)
	error = 0.0
	for i in eachindex(X)
		model_i = f(X[i], p)
		error += (Y[i] - model_i)^2
	end
	return error
end

xdata = 0:1:100
y(x, p) = p[1] .* exp.(- x / p[2]) .+ p[3]
ydata = y(xdata, [0.8, 15, 0.2]) .+ 0.03 * randn(length(xdata))

p0 = [2, 10, 0.0]
result = optimize(b -> square_error(b, y, xdata, ydata), p0)
params = Optim.minimizer(result)

fig = Figure()
ax = Axis(fig[1, 1])
scatter!(ax, xdata, ydata, color = :red, label = "raw")
lines!(xdata, y(xdata, p0), label = "guess")
lines!(xdata, y(xdata, params), color = :black, label = "fit")
axislegend(ax)

fig