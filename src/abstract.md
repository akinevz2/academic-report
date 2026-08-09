# Abstract

We present a two-track study of propaganda-technique detection in English
news sentences from the Propaganda Techniques Corpus. Task 1 frames the
problem as a 9-way classification of an already-located snippet given
its sentential context. Task 2 frames it as a joint span-and-label
detection problem over the full sentence.

We compare a bag-of-words baseline (linear model over a TF-IDF
vocabulary) against a finite-state tagger that models snippet
boundaries as a regular language. Probabilistic set-membership tests
against two Bloom filters (per-label exposure, vocabulary) gate
preprocessing and enable stratified error analysis. We discuss
hyper-parameters, evaluation methodology, class-level error patterns,
and limitations of both approaches.
