# Experiments

## Evaluation Methodology

For Task 1 we report per-class precision, recall, and F1, plus macro
and micro averages. For Task 2 we report span-level precision, recall,
and F1 (a predicted span counts as correct if its character offsets
match the gold span and the predicted label matches the gold label),
plus the same per-class breakdown as Task 1.

We hold out the provided validation set for all reported numbers; the
training set is used to fit all model parameters and the Bloom
filters. Hyper-parameter selection is done by 5-fold cross-validation
on the training set, and we report the chosen values explicitly.

## Hyper-parameter Settings

The following hyper-parameters are fixed across all runs:

- Tokenisation: lowercase, split on non-alphanumeric, drop tokens of
  length 1.
- BOS/EOS markers: stripped before tokenisation, retained as gold
  span boundaries for Task 2.
- Bloom filter false-positive rate: 0.01.

The following are explored:

- TF-IDF: n-gram range in {1, 1--2, 1--3}; min document frequency in
  {1, 2, 5}; sublinear TF on/off.
- Logistic regression: $C$ in {0.01, 0.1, 1, 10}; class weight in
  {uniform, balanced}.
- SVM: $C$ in {0.1, 1, 10}; character n-gram range in {2--4, 3--5}.
- State machine: feature set ablation; transition weights regularised
  with strength in {0.1, 1, 10}.

## Results: Task 1

[Results table: per-class P/R/F1 for BoW logistic regression, BoW SVM,
and a majority-class baseline. Macro-F1 for each.]

## Results: Task 2

[Results table: span-level P/R/F1 for the four-state machine, the
augmented label-state machine, and a sentence-level baseline. Per-class
F1 for each technique.]

## Error Analysis

We examine three axes of disagreement. First, confusion between
*loaded language* and *name calling, labeling* — both classes share
evaluative vocabulary. Second, the behaviour of the state machine on
multi-sentence inputs, where the BOS/EOS markers do not always align
with syntactic clauses. Third, the contribution of OOV tokens: the
`vocabulary` Bloom filter flags these at evaluation time, and we
report the OOV rate by predicted class.

The `labelCollection` filter is used here to detect cases where the
model produces a label not seen during training; in practice this is
zero in our runs, but the filter is cheap insurance against future
schema drift.
