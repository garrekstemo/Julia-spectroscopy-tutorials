# using GLMakie
using Optim
using LsqFit


f0(x) = x^2
f1(x) = x^3
f2(x) = 1 + x + x^2 + x^3

funcs = [f0, f1, f2]

for f in funcs
    println(f.(1:10))
end

xdata = -30:1:10
y(x, p) = p[1] .* exp.(- p[2] .* x) .+ p[3]
ydata = y(xdata, [0.08, 1/20, 0.3]) .+ 1.2 * randn(length(xdata))

function square_error(p, X, Y)
	error = 0.0

	for i in eachindex(X)
		
		model_i = y(X[i], p)
		error += (Y[i] - model_i)^2
	end
	return error
end


p0 = [1.0, 0.1, 0.0]
result = optimize(b -> square_error(b, xdata, ydata), p0, extended_trace = true)

params = Optim.minimizer(result)

summary(result)

Optim.converged(result)


Optim.hessian!(square_error, params)