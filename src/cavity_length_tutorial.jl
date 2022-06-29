using GLMakie
using CSV
using DataFrames
using LsqFit

# Load data and rename the two columns
data = DataFrame(CSV.File(abspath("data/vacant_cavity.csv"), skipto = 20, footerskip = 37))
rename!(data, ["wavenumber", "transmittance"])


# Make a basic figure to view the data in a separate window

f = Figure()

display(f)
ax = Axis(f[1, 1])
lines!(data.wavenumber, data.transmittance)

# xlims!(,)


# Calculations stop at a double # if you press Alt+Return.
# Press Shift+Return to evaluate a single line.

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

ν1 = 1000
ν2 = 1500

Δν = ν2 - ν1

x = 2

r = x^3 + 4

##

#############################
#           Step 2          #
#############################

# Find the center of two peaks using a fitting function
# to get a more accurate fit of the peak center.
# Then calculate the Q-factor for your cavity.



"""
Write a lorentzian function here to fit a single peak
in your spectrum.
"""
function lorentzian(x, p)
    A, x0, Γ = p
    return @. A^2 + x0 / (2*Γ)
end

# lines!(ax, fitdata.wavenumber, lorentzian(fitdata.wavenumber, []))

##

# Change the upper and lower bound to trim the data to one peak for fitting.

lowerbound = 2400
upperbound = 2500

fitdata = data[(data.wavenumber .> lowerbound) .& (data.wavenumber .< upperbound), :]

describe(fitdata)

fitdata.wavenumber

p0 = []  # initial guess
fit = curve_fit(lorentzian, fitdata.wavenumber, fitdata.transmittance, p0)

coef(fit)

lines!(ax, fitdata.wavenumber, lorentzian(fitdata.wavenumber, coef(fit)))