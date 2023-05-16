using CSV
using DataFrames
using GLMakie

function cavity_mode_energy(θ, E_0, n)
    E_c = Float64[]
    for θ_i in θ
        E_ci = E_0 / sqrt(1 - sin(θ_i)^2 / n^2)
        push!(E_c, E_ci)
    end
    return E_c
end

function polariton_branches(θ, E_v, E_0, n, Ω, branch = 1)
    E = Float64[]

    E_c = cavity_mode_energy(θ, E_0, n)

    if branch == 1
        for (i, θ_i) in enumerate(θ)
            E_i = 0.5 * (E_v + E_c[i] - sqrt(Ω^2 + (E_c[i] - E_v)^2)) 
            push!(E, E_i)
        end
    elseif branch == 2
        for (i, θ_i) in enumerate(θ)
            E_i = 0.5 * (E_v + E_c[i] + sqrt(Ω^2 + (E_c[i] - E_v)^2))
            push!(E, E_i)
        end
    end
    
    return E
end

### Generate fake data here with n, E_v, E_0, and Ω,
### which students must find by writing a fitting procedure.

# LP = polariton_branches(θ, E_v, E_0, n, Ω, 1) .+ 4 * randn(length(θ))
# UP = polariton_branches(θ, E_v, E_0, n, Ω, 2) .+ 6 * randn(length(θ))
