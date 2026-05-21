---
title: Intro to Julia for Spectroscopy
---

This short course introduces students to the Julia programming language applied to spectroscopy data analysis. It is intended for students who have never programmed before, or who have only done a little programming in another language.

The course covers programming fundamentals (Chapters 1–6) and data analysis and visualization (Chapters 7–10). Tested with Julia 1.12.

## How the course is organized

Lessons include short in-class exercises and longer take-home problems, organized by chapter. The code that generates figures is in the [`generate_images`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/generate_images) directory of the source repository. Data for exercises is in [`data`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/data).

The corresponding experimental tutorials are at [Optics Tutorials](https://github.com/garrekstemo/Optics-Tutorials).

## Recommended pace

Chapters 1 through 6 cover programming fundamentals — ideally two weeks with about one hour of class per chapter and 2–3 hours of homework per week.

Chapters 7 through 10 cover data analysis and visualization — about one week, depending on depth.

### Example schedule

#### Week 1
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Ch 1: Introduction to Julia | Installation, files, folders, environments |
| Wednesday | Ch 2: Variables, operators, and types | Variables, basic operations, types, strings |
| Friday | Ch 3: Conditionals | Boolean expressions, comparison operators, logic, if/else |

#### Week 2
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Ch 4: Iteration | while and for loops |
| Wednesday | Ch 5: Functions | Built-in functions, user-defined functions, assignment form |
| Friday | Ch 6: Arrays | Indexing, slicing, range objects, multi-dimensional arrays, broadcasting, comprehensions |

#### Week 3
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Review Ch 1–6 | Variables, conditionals, iteration, arrays, functions |
| Wednesday | Ch 7: Plotting | Basic plotting with Makie.jl |
| Friday | Ch 8: Fitting | Least squares fitting with CurveFit.jl |

#### Week 4
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Ch 9: Fourier transform | FT basics with FFTW.jl |
| Wednesday | Ch 10: Transfer matrix | Thin-film optics with TransferMatrix.jl |
| Friday | Review Ch 7–10 | Plotting, fitting, Fourier transforms, transfer matrix |
