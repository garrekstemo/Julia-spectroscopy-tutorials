# Lesson 4: Optimizing a function

In this final lesson, we will write our own squared
errors function to minimize.
This is often required if the data do not fit to a simple model, or you wish to use specific algorithms.
We will use the `Optim.jl` package to minimize
the loss or cost function that we write.

As a reminder, we want to minimize the square of the errors between the model and the raw data:

$\sum_i \left( y_\text{model}(x_i) - y_\text{data}(x_i) \right)^2$.

In this case, we will use generated data
representing the polariton dispersion curve
from an angle-resolved measurement.

To fit this data, we use a simple coupled-oscillator Hamiltonian model:

$$H_\text{total} = H_0 + H'$$

$$H_\text{total} = \begin{pmatrix}
E_\text{cavity} & 0 \\
0 & E_\text{vibration}
\end{pmatrix}
+ \begin{pmatrix}
0 & \Omega_R / 2 \\
\Omega_R / 2 & 0
\end{pmatrix}
= \begin{pmatrix}
E_\text{cavity} & \Omega_R / 2 \\
\Omega_R / 2 & E_\text{vibration}
\end{pmatrix}$$

The cavity mode energy is $E_\text{cavity}$, which depends on the angle $\theta$ of the beam with respect to the cavity. The molecular vibrational transition is $E_\text{vibration}$, and the Rabi splitting is $\Omega_R$.
Diagonalize the Hamiltonian to find the upper and lower polariton energies. (Do you remember how to do that?)

Finally, write an error function to minimize the lower and upper polariton energy equations.