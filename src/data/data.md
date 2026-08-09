# Data

## Dataset Description

The corpus is delivered as two TSV files. The first column is the
label; the second is the sentence with `<BOS>` and `<EOS>` markers
around the propaganda span. The training set contains 2,560 rows and
the validation set 640 rows. After splitting comma-separated
multi-technique rows, the unique label set is:

- appeal to fear prejudice
- causal oversimplification
- doubt
- exaggeration,minimisation
- flag waving
- loaded language
- name calling,labeling
- not propaganda
- repetition

Class distribution is heavily skewed toward *not propaganda*. We
report per-class counts in the results section.

## Preprocessing

We lowercase the sentence, replace `<BOS>` and `<EOS>` with sentential
separators, and tokenise on whitespace and punctuation. For Task 1 we
extract the snippet between the markers together with a fixed-width
window of context tokens on either side. For Task 2 the BOS/EOS
positions are retained as the gold span.

## Probabilistic Structures

Two Bloom filters [@bloom-1970-space] are built from the training set:

- `labelCollection` records which labels the system has been exposed
  to during training. It is used to gate evaluation: a predicted label
  is flagged as out-of-distribution if it is absent from the filter.
- `vocabulary` records the union of word types seen in any training
  sentence. It is used to flag out-of-vocabulary tokens in error
  analysis, and to support cheap subset queries during ablations.

Both filters are sized to give an expected false-positive rate below
1% at the observed cardinalities. False positives do not affect
correctness; they only affect which tokens are flagged for analysis.
