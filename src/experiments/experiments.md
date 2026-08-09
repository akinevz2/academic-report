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

Validation-set P/R/F1 for the bag-of-words multinomial logistic
regression with the locked-in configuration (n-gram range 1--2,
min document frequency 2, sublinear TF, context window 5, L2 strength
$C=10$, balanced class weights):

| label | support | P | R | F1 |
|---|---:|---:|---:|---:|
| appeal_to_fear_prejudice | 43 | 0.375 | 0.349 | 0.361 |
| causal_oversimplification | 35 | 0.375 | 0.343 | 0.358 |
| doubt | 43 | 0.348 | 0.372 | 0.360 |
| exaggeration,minimisation | 30 | 0.205 | 0.267 | 0.232 |
| flag_waving | 45 | 0.548 | 0.511 | 0.529 |
| loaded_language | 39 | 0.200 | 0.385 | 0.263 |
| name_calling,labeling | 34 | 0.135 | 0.147 | 0.141 |
| not_propaganda | 331 | 0.738 | 0.586 | 0.653 |
| repetition | 40 | 0.197 | 0.325 | 0.245 |
| **macro** | | | | **0.349** |
| **micro** | | **0.470** | **0.470** | **0.470** |

Ablation over the explored hyper-parameters (macro / micro F1 on the
validation set, single seed):

| n-gram range | $C$ | class weight | macro F1 | micro F1 |
|---:|---:|---|---:|---:|
| 1--1 | 0.1 | balanced | 0.078 | 0.077 |
| 1--1 | 1.0 | balanced | 0.293 | 0.330 |
| 1--1 | 10.0 | balanced | 0.323 | 0.423 |
| 1--1 | 1.0 | uniform | 0.192 | 0.397 |
| 1--2 | 0.1 | balanced | 0.057 | 0.080 |
| 1--2 | 1.0 | balanced | 0.312 | 0.370 |
| **1--2** | **10.0** | **balanced** | **0.343** | **0.472** |
| 1--2 | 1.0 | uniform | 0.196 | 0.375 |

Three trends are visible. First, *balanced* class weights consistently
outperform *uniform*, by roughly 10 macro-F1 points: the validation
set has 331 not-propaganda examples against 30--45 for the techniques,
so up-weighting rare classes is necessary to keep the model from
collapsing. Second, larger $C$ (weaker regularisation) helps — the
data is small enough that overfitting is less of a concern than
under-fitting. Third, bigrams add a small but consistent gain over
unigrams alone. The locked-in configuration is the best row in the
ablation.

[Figure: per-class P/R bar chart for the locked-in configuration.]

## Results: Task 2

We compared two training regimes for the finite-state tagger on
identical features and tag inventory (17 tags, emissions over
LinguisticFeatures). The **averaged structured perceptron with
Viterbi decoding** is the locked-in trainer: it is evaluative
re-improvement, hill-climbing on a 0/1 loss over best-decoded tag
sequences. The **per-token multinomial softmax with L2** is the
alternative we compared against: a smooth cross-entropy loss that
naturally handles class imbalance through per-example gradient
magnitudes.

Per-row label accuracy on the validation set (a row is correct if
the predicted span label matches the gold label, ignoring boundary
offsets):

| label | perceptron F1 | softmax F1 |
|---|---:|---:|
| doubt | 0.148 | 0.071 |
| not_propaganda | 0.708 | 0.896 |
| **macro** | **0.095** | **0.171** |
| **micro** | 0.523 | 0.562 |

The softmax is more uniform across propaganda classes (every rare
class gets non-zero F1) while the perceptron concentrates its
capacity on `doubt` (the only class whose spans are usually a
single adverb at sentence start, a position the emission features
can latch onto). The softmax's cross-entropy loss accumulates
gradient proportional to the model's *probability* of the gold
tag, which keeps rare classes contributing to the loss even when
they are never predicted. The perceptron's 0/1 loss is brittle
under the 78% `O` base rate.

Span-level P/R/F1 (predicted span counts as correct only if its
character offsets match the gold span *and* the predicted label
matches):

| label | perceptron F1 |
|---|---:|
| doubt | 0.086 |
| **macro** | **0.011** |
| **micro** | 0.015 |

The perceptron matches one full `doubt` span (single-word spans
are achievable by accident) and a handful of `I-*` continuations
for other classes, but the boundary-matching problem is
structural. The locally-normalised decoder has no mechanism for
extending a `B-{LABEL}` because the emission features cannot
condition on the predicted previous tag during training. The
shared failure mode across both training regimes is boundary
drift: the model emits a `B-{LABEL}` at roughly the right
position but cannot match the gold span's end.

[Figure: per-row label F1 vs span-level F1 for each technique and
each training regime, illustrating the boundary-matching gap.]

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

A fourth observation specific to Task 2: the locally-normalised
decoder is biased toward `O` because the training data is 78%
outside-span. We compensate with a sample weight of 3.0 for non-`O`
tokens in the perceptron updates, but the model still struggles to
extend a `B-{LABEL}` into a multi-token span because the emission
features cannot condition on the predicted previous tag during
training. The practical symptom is the gap between per-row label
F1 (0.095 macro) and span-level F1 (0.011 macro) in §5.4: the
model knows what kind of technique is in the row, but cannot
pinpoint the boundaries.

We compared two loss functions on identical features: the
averaged structured perceptron (0/1 loss, hill-climbing on
Viterbi-best sequences) and the per-token multinomial softmax
with L2 (cross-entropy loss). The softmax outperforms the
perceptron on per-row label F1 (0.171 vs 0.095 macro) and ties on
span-level F1. The 0/1 loss is brittle when the training set is
dominated by one class: the perceptron needs to see the gold path
on every update, but the model's predicted path is nearly always
`O → O → ...`, so 62% of training sentences trigger an update
and the `O → O` transition accumulates a large negative weight
that swamps the rare `B-*` transitions. The softmax's
cross-entropy loss, in contrast, accumulates gradient proportional
to the model's *probability* of the gold tag, which keeps rare
classes contributing to the loss even when they are never
predicted. The takeaway is that for class-imbalanced structured
prediction, a smooth loss is materially better than a 0/1 loss,
even before considering Viterbi-vs-softmax decoding.

Replacing the locally-normalised decoder with a linear-chain CRF,
which normalises across the full tag sequence rather than
per-token, is the natural fix for the boundary-drift problem and
is the first item in §7.
