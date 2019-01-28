# Modified from code provided by "Doomphoenix Qxz" on discourse.julialang.com
"""
    SRDist(ν, k)

The *studentized range distribution* has probability density function:

```math
f(q; k, \\nu) = \\frac{\\sqrt{2\\pi}k(k - 1)\\nu^{\\nu/2}}{\\Gamma{(\\frac{\\nu}{2})}2^{\\nu/2 - 1}} \\int_{0}^{\\infty} {x^{\\nu}\\phi(\\sqrt{\\nu}x)} [\\int_{-\\infty}^{\\infty} {\\phi(u)\\phi(u - qx)(\\Phi(u) - \\Phi(u - qx))^{k - 2}du]dx

where

\\Phi(x) = \\frac{1 + erf(\\frac{x}{\\sqrt{2}})}{2}
\\phi(x) = \\Phi'(x)
```

```julia
SRDist(ν, k)     # Studentized Range Distribution with parameters ν and k

params(d)         # Get the parameters, i.e. (ν, k)
```

External links

* [Studentized range distribution on Wikipedia](http://en.wikipedia.org/wiki/Studentized_range_distribution)
"""
struct SRDist{T<:Real} <: ContinuousUnivariateDistribution
    ν::T
    k::T

    function SRDist{T}(ν::T, k::T) where T
        @check_args(SRDist, ν > zero(ν) && k > one(k))
        new{T}(ν, k)
    end
end

SRDist(ν::T, k::T) where {T<:Real} = SRDist{T}(ν, k)
SRDist(ν::Integer, k::Integer) = SRDist(Float64(ν), Float64(k))
SRDist(ν::Real, k::Real) = SRDist(promote(ν, k)...)

@distr_support SRDist 0.0 Inf


###  Conversions

function convert(::Type{SRDist{T}}, ν::S, k::S) where {T <: Real, S <: Real}
    SRDist(T(ν), T(k))
end

function convert(::Type{SRDist{T}}, d::SRDist{S}) where {T <: Real, S <: Real}
    SRDist(T(d.ν), T(d.k))
end


### Parameters
params(d::SRDist) = (d.ν, d.k)
@inline partype(d::SRDist{T}) where {T <: Real} = T


### Evaluation & Sampling

@_delegate_statsfuns SRDist srdist ν k
