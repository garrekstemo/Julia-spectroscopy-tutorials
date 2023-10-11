# Lesson 3

In this lesson we learn a bit more about using 
Julia in Visual Studio Code and selecting ranges of data using the `DataFrames` package.


## Evaluating a single line or block of code

In VS Code you can evaluate (run) a single line of code
by placing the cursor on a line and pressing `shift+enter`.
You can evaluate a block of code by selecting the block
and pressing `alt+enter`.
Blocks are separated by a double `##`

The following two blocks are separated.
If you type `alt+enter` with the cursor somewhere above `##` in a Julia file, it will run the first block.
The code after `##` will not run.

```
x = 1:100
y = sin.(x)

##

x = 2
y = sin(x)
```

## Loading data into a `DataFrame`

If you have ever used Python, you may be familiar with the popular `pandas` library.
`DataFrames` is the Julia equivalent, and both are used
to store and manipulate data in a table format.
Once you load plain text data into a `DataFrame`,
it is easy to perform analysis on sections or slices of the data.
First use the `CSV` or `DelimitedFiles` (for simple cases) packages to load the text file, then store it in a `DataFrame`.

Here is a simple `DataFrame` object:
```
data = DataFrame((a=[1, 2], b=[3, 4]))
```

Once the data is loaded, you can access columns in a few different ways. In this example, we can access column `a` using `data.a` or `data[!, :a]`.
Find more on the [`DataFrames` documentation page](https://dataframes.juliadata.org/stable/man/basics/).


## Step 1

Load your cavity data into a `DataFrame` and plot it in Makie.
Choose two neighboring peaks and find the cavity length
by finding the difference between the two peaks.
This can be done using the relation


$$\Delta\nu = \frac{1}{2nL}$$

where $\Delta\nu$ is the frequency difference between the two peaks, $n$ is the refractive index of the material, and $L$ is the cavity length.

## Step 2

Finding the peak frequency by eye is fine for rough approximations, but ideally we want to fit the data to a model.
What line shape does a cavity mode have? Explain your choice of fitting function.
Look up a model for a molecular mode and write a Julia function based on it.
Next, we need to select a range of data that includes only two peaks.
We can do this in a few ways.
Perhaps the simplest is to `filter()` the data based on a lower and upper bound. The `filter()` function is general, and not unique to the DataFrames package.

Here is an example of filtering a `DataFrame` by row value:
```
using DataFrames

df = DataFrame(x=1:10, y=sin.(1:10))

newdf = filter(row -> row.x > 10, df)
```

Since we want two bounds, we will need the boolean AND operator, `&&` (OR is `||`). Try this for yourself by modifying the example above.

Finally, plot your raw spectrum and two fits, one for each cavity mode.