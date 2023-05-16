using GLMakie
using CSV
using DataFrames
using LsqFit

datapath = abspath("data/vacant_cavity.csv")

# Load data and rename the two columns
# Skip the header and footer metadata to load just the raw data.
data = DataFrame(CSV.File(datapath, skipto = 20, footerskip = 37))
rename!(data, ["wavenumber", "transmittance"])

# Make a basic figure to view the data in a separate window
GLMakie.activate!(inline=false)
fig = Figure()
ax = Axis(fig[1, 1])
lines!(data.wavenumber, data.transmittance)


##### Pro tip! #####

# Calculations stop at a double ## if you press alt+return.
# Press shift+return to evaluate a single line.

# evaluate the next two lines, one at a time, by pressing shift+return
x = rand(5)
y = sin.(x)


# here
# |
# | 
# |
# v

##

#############################
#           Step 1          #
#############################

# Find the difference between two peaks
# and use the equation
#
#    Δν = 1 / (2 * n * L)
#
# to find the cavity length.
#
# n = refractive index (屈折率)
# L = cavity length
# Δν = ν2 - ν1

ν1 = 0
ν2 = 0

Δν = ν2 - ν1

##

#############################
#           Step 2          #
#############################

# Find the centers of two peaks using a fitting function.
# Then calculate the Q-factor for your cavity.
# Finally, plot your data and two fits below.

"""
Write a lorentzian function here to fit a single peak
in your spectrum.
"""
function lorentzian()
    # Your code here
end

##

# Change the upper and lower bound to trim the data to one peak for fitting.

lowerbound = 1800
upperbound = 1950

# fitdata = filter()

p0 = []  # initial guess
# fit = curve_fit()

fig = Figure()

# Make your figure here