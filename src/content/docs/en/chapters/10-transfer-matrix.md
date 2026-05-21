---
title: Transfer matrix
---

This chapter blends physics and programming.
First we will cover strong coupling in microcavity structures and then we will use the transfer matrix method to simulate the propagation of electromagnetic waves through a series of layers.

The physics concepts will be based on the following text.

Skolnick, Fisher, and Whittaker. Strong coupling phenomena in quantum microcavity structures. *Semicond. Sci. and Technol*. **1998**, *13* (7), 645-669. https://doi.org/10.1088/0268-1242/13/7/003.

You may use outside literature to bolster your understanding.
In particular, you may find the Wikipedia entry on the [distributed Bragg reflector](https://en.wikipedia.org/wiki/Distributed_Bragg_reflector) helpful.


## Introduction
Read the introduction in Skolnick, *et al.* and answer the following conceptual questions.

1. What is an exciton? How does it form?
2. What is a quantum well?
3. How is a DBR mirror structured? How does this structure create a highly reflective surface?
4. How do the authors define a quantum microcavity (QMC)?
5. Why does a Fabry-Pérot cavity cause the photons to be quantized in the "growth" (vertical) direction and not in the in-plane direction?
6. What are the differences between "bulk" polaritons and "cavity" polaritons?
7. How does the dispersion of photons in cavity differ from photons in free space (the vacuum)?
8. How is the strong coupling limit defined? What phenomena occur in this limit? What about in the weak coupling limit?


## Basic microcavity physics
At 630 nm wavelength, TiO<sub>2</sub> has a refractive index of about 2.39 and SiO<sub>2</sub> has a refractive index of about 1.46. Consider a distributed Bragg reflector (DBR) mirror made from alternating layers of TiO<sub>2</sub> and SiO<sub>2</sub>.

1. What is the reflectivity of a DBR mirror for 2, 4, and 8 periods of TiO<sub>2</sub>/SiO<sub>2</sub> layers?

2. What is the bandwidth of the photonic stop band of the mirror?

Now consider a microcavity with a cavity length of 1 μm and a DBR mirror on each side.

3. What is the effective cavity length if the distance between the two mirror surfaces is 1 μm? Why is the effective cavity length different than when measured as the distance between the two mirror surfaces?

4. What is the cavity length required to have a resonance at 630 nm?

5. What is the cavity mode width Δc for the cavity in the previous question? What lifetime does this correspond to? What is the Q-factor of the cavity?


## Transfer matrix method
I find that one of the best ways to learn a physics concept is to implement it in code.
When I was in graduate school, that is exactly what I did when I built a transfer matrix simulation first in Python and then in Julia (which is the version we will be using).
Having you build an entire simulation from scratch is too much to ask, but at least we can use the transfer matrix method to simulate some simple structures with electromagnetic waves propagating through them.

The transfer matrix method simulates the propagation of electromagnetic waves through a series of layers.
It can produce a wide range of static phenomena, such as the reflection, transmission, and absorption of light, Bloch surface waves, and the electric fields existing inside the layers.
There are known limitations to the transfer matrix method, such as the fact that it cannot be used to simulate nonlinear effects or time-dependent phenomena, but it is a powerful tool in our lab for designing dielectric mirrors, simulating transmission spectra of complex structures, and analyzing polariton transmission spectra.
The transfer matrix implementation in TransferMatrix.jl is based on the work of Passler *et al.* (see references).
It is a general 4 x 4 matrix formalism that tries to avoid some of the traditional pitfalls of the traditional Yeh formalism (notably the tendency for singularities to occur in certain cases).
The code itself is modular and well-documented (I hope) so that it is easy to modify parts of the algorithm to suit your needs.


## Getting started

I have written both a quick start and longer tutorial on the [documentation website](https://garrek.org/TransferMatrix.jl/stable/) for TransferMatrix.jl.
First go through those examples and make sure you understand what the code is doing and also how to interpret the generated spectra.

Once you have done that, you will build your own structure and simulate a transmission spectrum.


### Problems

Simulate the reflection spectrum of the dielectric mirror structure from the previous problem set using the transfer matrix method and answer the following questions using the numerical approach and compare with your analytic answers from before.

1. What is the reflectivity of a DBR mirror for 2, 4, and 8 periods of TiO2/SiO2 layers?

2. What is the bandwidth of the photonic stop band of the mirror?

Now simulate a mirror with TiO<sub>2</sub> and Ta<sub>2</sub>O<sub>5</sub> layers for an incident wavelength of 630 nm.

3. How many layers do you need to have a higher reflectivity than 2 layers of TiO<sub>2</sub>/SiO<sub>2</sub>?

4. Which mirror has a larger stop band? Why?

Next simulate a gold-mirror cavity with a cavity length of $\lambda_0$/2 where $\lambda_0$ = 3. Let the intracavity medium be air (n = 1). (Make sure to plot the spectrum to long wavelengths.)

5. Plot the transmission spectrum in units of wavelength and frequency (cm<sup>-1</sup>). What do you notice about the mode spacing?

6. Adjust the gold thickness until you obtain a cavity mode FWHM of about 40 cm<sup>-1</sup> for the mode near 3200-3300 cm<sup>-1</sup>. What is this thickness?

7. What photon lifetime does this FWHM correspond to? What is the Q-factor of the mode?

8. The free spectral range (FSR) is defined as the frequency spacing between adjacent cavity modes. Calculate the average FSR for this cavity with a gold thickness of 10 nm.

9. Choose any cavity mode and calculate the electric field at that wavelength. Can you find the first order mode? What is its electric field profile?

10. Increase the cavity length to 3/2 $\lambda_0$. How does the electric field profile change? What is the new FSR?


## References
- [Transfer Matrix Method](https://en.wikipedia.org/wiki/Transfer-matrix_method_(optics)) Wikipedia entry
- Yeh, P. *Optical Waves in Layered Media*; Wiley Series in Pure and Applied Optics; Wiley, 2005.

- Passler, N. C.; Paarmann, A. *Generalized 4 × 4 Matrix Formalism for Light Propagation in Anisotropic Stratified Media: Study of Surface Phonon Polaritons in Polar Dielectric Heterostructures*. J. Opt. Soc. Am. B 2017, 34 (10), 2128. https://doi.org/10.1364/JOSAB.34.002128.
- Passler, N. C.; Paarmann, A. *Generalized 4 × 4 Matrix Formalism for Light Propagation in Anisotropic Stratified Media: Study of Surface Phonon Polaritons in Polar Dielectric Heterostructures: Erratum*. J. Opt. Soc. Am. B 2019, 36 (11), 3246. https://doi.org/10.1364/JOSAB.36.003246.
- Garibello, B.; Avilán, N.; Galvis, J. A.; Herreño-Fierro, C. A. *On the Singularity of the Yeh 4 × 4 Transfer Matrix Formalism*. Journal of Modern Optics 2020, 67 (9), 832–836. https://doi.org/10.1080/09500340.2020.1775905.
