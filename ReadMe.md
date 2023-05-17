# Julia Spectroscopy Tutorials

These tutorials are the data analysis part of a series to learn basic optics and spectroscopy.
The data collected at the end of the optics tutorials will now be used
to develop skills in programming and data analysis.
We use the [Julia programming language](https://julialang.org) with Visual Studio Code. 


## Install Julia and Visual Studio Code

1. Download the [Julia](https://julialang.org/downloads/) programming language
2. Download [Visual Studio Code](https://code.visualstudio.com/download) (the easiest way to run Julia code right now)
3. In VS Code, install the Julia extension [from the VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=julialang.language-julia) or from the Extensions in the VS Code application
4. Activate the project environment by typing `]activate` in the Julia REPL
5. Choose a Julia file (ending in `.jl`) in `lab_notebook` or `results` and run it


## Lessons

Access the instructions in the `docs` folder and start with `Lesson 1.md`

- Lesson 1: Julia basics and fitting
- Lesson 2: Fitting to experimental data
- Lesson 3: Cavity fit tutorial
- Lesson 4: Optimizing a function


## Corresponding experiments

Start with the femtosecond pulse width experiment.
Then there is a three-part FTIR tutorial where students do the following

1. Measure the cavity length of a Fabry-Pérot etalon from the free spectral range.

2. Fill the cavity with a solvent and measure the refractive index.

3. Fill the cavity with a liquid with a resonant molecular mode. Students measure the mode splitting using a double Lorentzian function.


## Input and Output

Save all raw data to the `data` directory.
Output, such as processed data and figures, should be saved to the `output` directory.


## Why Julia

Any software can of course be used to analyze data,
but I choose Julia for a few reasons

1. It is designed specifically for scientific applications and has many scientific libraries
2. It is easy to learn, borrowing many ideas from Python and Matlab
3. It is responsive and interactive, and can be used in Jupyter notebooks or in the REPL (Read Evaluate Print Loop) in the command line
4. It is fast, comparable to C or Fortran. So if performance is your goal, you can stick with Julia and do not need to learn a second language.
5. It is free and open source, and has a large and growing community.
6. Reproducibiliy is a priority, and Julia has a built-in package manager that makes it easy to share code and reproduce results. This is important when designing code to be used for science.
