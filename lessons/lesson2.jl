using CSV
using DataFrames
using GLMakie
using LsqFit


# Load data into a DataFrame and rename x and y columns
dir = "data/"
filenames = ["autocorr1", "autocorr2", "autocorr3"] .* ".lvm"
data = []

for filename in filenames
    filepath = dir * filename
    raw = DataFrame(CSV.File(filepath, header = [2]))
    rename!(raw, ["time", "signal"])
    push!(data, raw)
end

# Write a fitting function
function myfunction(t, p)
end

# Average your three data sets here
# avg = 

# Now fit your function to the averaged data.
# Use what you learned in Lesson 1,
# then calculate the pulse width from the fit parameters.
# Look up how pulse width is defined for femtosecond lasers.


# Create a figure to plot your data and fit

fig = Figure()

# Your code here

fig