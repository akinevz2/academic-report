# Foreword

$$
z_{\mathrm{cr}}^{\mathrm{Hz}} = \left(\sum_{i=1}^{N-1} \mathbf{1}\{s_{i-1}s_i < 0\}\right)\,\frac{f_s}{2(N-1)}
$$

where $s=(s_0,\dots,s_{N-1})$ is the discrete signal of length $N$ and $f_s$ is the sampling frequency.

In previous years of study, I have produced `pagerts`, an application with behaviour similar to a web scraper. I was curious how its build process affected the runtime of the application.
When installing it to the system repository it would somehow begin to exhibit correct behaviour, yet running it from the local installation folder it would perform like a highly unoptimised code.

\pagebreak{}

To address the issue and report on the matter, which was only possible to produce through trial and error, I had discovered that running the package from system shared library path was the correct approach.

Conversely, running from development folder it would have to call across multiple system boundaries without any optimisations in order to open the code necessary to function, rendering its runtime nondeterministic.
