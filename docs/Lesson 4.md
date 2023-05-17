# Lesson 4: Optimizing a function

In the final experiment tutorial, you measured the spectrum for
a polariton system.
If the two polariton peaks have the sample transmission amplitude,
then the Rabi splitting is the frequency (energy) difference between the two peaks.
Another way to extract the Rabi splitting is to measure
the angle-resolved spectrum, plot the energy versus incidence angle, and fit the data to a simple coupled harmonic oscillator model. We did not measure the angle dependence, so this lesson
provides some fake data to work with.

Since the data is more complicated than a simple curve, we will write our own loss function and minimize it using the `Optim.jl` package. This is often required if the data do not fit to a simple model, or you wish to use a specific algorithm. 
(Julia has a rich ecosystem of machine learning and optimization packages that you may wish to take advantage of during your studies).

As a reminder, we want to minimize the square of the errors between the model and the raw data:

$$\text{min}\sum_i \left( y_\text{model}(x_i) - y_\text{i, data} \right)^2.$$

In this case, we will use generated data
representing the polariton dispersion curve
from an angle-resolved measurement.

To fit this data, we use a simple coupled-oscillator Hamiltonian:

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

The cavity mode energy is $E_\text{cavity}$, which depends on the angle $\theta$ of the beam with respect to the normal of the cavity surface.
The molecular vibrational transition is $E_\text{vibration}$, and the Rabi splitting is $\Omega_R$.
Diagonalize the Hamiltonian to find the upper and lower polariton energies.

Finally, write an error function to minimize the lower and upper polariton energy equations.