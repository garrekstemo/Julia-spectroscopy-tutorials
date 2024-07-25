using GLMakie
using Optim

function cavity(θs, p)
    E0, n = p
    return @. E0 / sqrt(1 - sin(θs)^2 / n^2)
end

function square_error(p, f, X, Y)
	error = 0.0
	for i in eachindex(X)
		model_i = f(X[i], p)
		error += (Y[i] - model_i)^2
	end
	return error
end

θs = 0:2:40
θrad = deg2rad.(θs)
p_real = [2000, 1.5]
cav = cavity(θrad, p_real) .+ 10 * randn(length(θs))

p0 = [1800, 1.2]
result = optimize(b -> square_error(b, cavity, θrad, cav), p0)
params = Optim.minimizer(result)

fig = Figure(size = (600, 1000))
ax = Axis(fig[1, 1])
scatter!(θs, cav, color = :red, label = "raw")
# lines!(θs, cavity(θrad, p0), label = "guess")
lines!(θs, cavity(θrad, params), label = "fit", color = :black)

ax2 = Axis(fig[2, 1], title = "Residuals")

residuals = (cav .- cavity(θrad, params))

scatter!(θs, residuals, color = :blue, label = "residuals")

axislegend(ax)

fig