using CSV, DataFrames, GLMakie, Optim


#############################
#           Step 1          #
#############################

# Minimize the squared error for a simple exponential function

y(x, p) = p[1] * exp.(-x / p[2]) .+ p[3]

xdata = -6:17
ydata = y(xdata, [1.2, 3.0, 0.3])

# quickly make a figure in one line of code
fig, ax, l = lines(xdata, ydata)
DataInspector()  # Make a cursor to inspect data
fig
##
"""
    squared_error(p, X, Y)

The squared error between the data and the model.
This function will be minimized by the optimizer.
"""
function squared_error(p, X, Y)
    error = 0.0

    for i in eachindex(X)
        # do something
    end

    return error
end

# Use an optimizer to minimize the squared error and find a best fit.
# p0 = []
# fit = optimize(b -> squared_error(b, xdata, ydata), p0)

# params = Optim.minimizer(fit)

# Plot your results on the same figure and axis made above.


##

#############################
#           Step 2          #
#############################

# Write your own loss function here 
# and use it to find the best fit for the generated polariton data
# in the `data` directory. Plot your results.
