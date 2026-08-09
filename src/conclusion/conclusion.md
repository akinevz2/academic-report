# Conclusion

We presented two approaches to propaganda-technique detection: a
bag-of-words linear baseline for Task 1 and a finite-state tagger for
Task 2. Both approaches are reproducible, interpretable, and small
enough to inspect by hand. The Bloom filter infrastructure turned out
to be more useful in the error-analysis phase than in the modelling
phase: the filters gave us a clean way to stratify confusion by
vocabulary exposure and to detect any future label-schema drift
without changing evaluation code.
