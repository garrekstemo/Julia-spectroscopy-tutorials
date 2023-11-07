using DelimitedFiles
using GLMakie

function cavity_mode_energy(θs, E_0, n)
    E_c = Float64[]
    for θ_i in θs
        E_ci = E_0 / sqrt(1 - sin(θ_i)^2 / n^2)
        push!(E_c, E_ci)
    end
    return E_c
end

function polariton_branches(θs, E_v, E_0, n, Ω, branch = 1)
    E = Float64[]
    E_c = cavity_mode_energy(θs, E_0, n)

    if branch == 1
        for i in eachindex(θs)
            E_i = 0.5 * (E_v + E_c[i] - sqrt(Ω^2 + (E_c[i] - E_v)^2)) 
            push!(E, E_i)
        end
    elseif branch == 2
        for i in eachindex(θs)
            E_i = 0.5 * (E_v + E_c[i] + sqrt(Ω^2 + (E_c[i] - E_v)^2))
            push!(E, E_i)
        end
    end
    
    return E
end

##

# Generate fake data here by setting n, E_v, E_0, and Ω,
# which students must find by writing a fitting procedure.

θs = range(0.0, 40, length = 10)
θsrad = θs .* π/180.0
LP = polariton_branches(θsrad, E_v, E_0, n, Ω, 1) .+ 1 * randn(length(θsrad))
UP = polariton_branches(θsrad, E_v, E_0, n, Ω, 2) .+ 3.5 * randn(length(θsrad))

fig = Figure()
ax = Axis(fig[1, 1])
scatter!(θs, LP)
scatter!(θs, UP)

fig


##
# open("data/generated_polariton_data.csv", "w") do io
#     writedlm(io, [θs LP UP], ',')
# end