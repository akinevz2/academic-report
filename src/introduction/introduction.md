# Introduction

## Problem Statement

We tackle propaganda-technique detection over a corpus of English news
sentences annotated with the spans of text that exhibit one of eight
propaganda techniques, plus a *not propaganda* class. Each instance is a
sentence in which the relevant snippet is delimited by `<BOS>` and
`<EOS>` tokens.

We separate the work into two tasks that match the assignment brief:

- **Task 1: Technique classification.** Given a snippet known to be
  propaganda together with its sentential context, predict the technique
  used.
- **Task 2: Span and technique detection.** Given a full sentence, find
  the span(s) that carry propaganda and classify the technique used in
  each.

## Motivation and Challenges

Propaganda detection is hard for three reasons. First, the categories
overlap in surface cues: *loaded language* and *name calling,
labeling* both trade on evaluative vocabulary, while *flag waving* and
*appeal to fear prejudice* both invoke group identity. Second, the same
lexical item can serve multiple techniques across contexts. Third,
training data is class-imbalanced: the *not propaganda* class
dominates, and several techniques have only a few hundred examples.

A practical system must therefore balance two things: a robust lexical
backbone that captures the surface vocabulary of each technique, and a
mechanism for span reasoning that does not require large annotated
spans per technique.

## Contributions

We make the following contributions:

1. A reproducible bag-of-words baseline for Task 1 with explicit
   hyper-parameter discussion (tokenisation, n-grams, regularisation,
   class weighting).
2. A finite-state tagger for Task 2 that models the BOS/EOS span as a
   regular language over part-of-speech and lexical features.
3. A small infrastructure contribution: the use of two Bloom filters,
   one over labels and one over vocabulary, to gate preprocessing and
   stratify error analysis. This is novel in the propaganda-detection
   setting, though the underlying data structure is not.

## Paper Outline

Section 2 situates the work. Section 3 describes the data and
preprocessing. Section 4 presents the two methods. Section 5 reports
results, hyper-parameters, and error analysis. Section 6 concludes and
Section 7 outlines further work. The code appendix follows.
