# Foreword 

In previous years of study, I have produced `pagerts`, an application with behaviour similar to a web scraper. I was curious how its build process affected the runtime of the application.
When installing it to the system repository it would somehow begin to exhibit correct behaviour, yet running it from the local installation folder it would perform like a highly unoptimised code.

\pagebreak{}

To address the issue and report on the matter, which was only possible to produce through trial and error, I had discovered that running the package from system shared library path was the correct approach. 

Conversely, running from development folder it would have to call across multiple system boundaries without any optimisations in order to open the code necessary to function, rendering its runtime nondeterministic.
