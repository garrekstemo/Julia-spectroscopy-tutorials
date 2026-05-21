---
title: Intro to Julia for Spectroscopy
---

Placeholder landing page. Real content lands in a later task.

Inline math sample: $E = mc^2$.

Display math sample:

$$
\hat{H} \psi = E \psi
$$

A Julia code sample:

```julia
function lorentzian(p, x)
    A, x0, gamma = p
    @. A * gamma^2 / ((x - x0)^2 + gamma^2)
end
```
