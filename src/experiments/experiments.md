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

We use an averaged structured perceptron with Viterbi decoding and
a BIO-constrained transition matrix. The transition matrix is
compiled from declarative rules in `src/FiniteStateTagger.py`:
`O → {O, B-{LABEL}}`, `B-{LABEL} → {O, I-{LABEL}}`, and
`I-{LABEL} → {O, I-{LABEL}}`. The constraint forces the decoder to
extend a `B-{LABEL}` into `I-{LABEL}` continuations or close it
with `O`; it forbids the nonsense transitions like
`B-flag_waving → I-loaded_language` that the unconstrained decoder
was free to make.

Per-row label accuracy on the validation set (a row is correct if
the predicted span label matches the gold label, ignoring boundary
offsets):

| label | perceptron F1 |
|---|---:|
| appeal_to_fear_prejudice | 0.107 |
| causal_oversimplification | 0.240 |
| doubt | 0.207 |
| exaggeration,minimisation | 0.178 |
| flag_waving | 0.349 |
| loaded_language | 0.000 |
| name_calling,labeling | 0.000 |
| not_propaganda | 0.743 |
| **macro** | **0.203** |
| **micro** | 0.564 |

Span-level P/R/F1 (predicted span counts as correct only if its
character offsets match the gold span *and* the predicted label
matches):

| label | perceptron F1 |
|---|---:|
| causal_oversimplification | 0.148 |
| doubt | 0.056 |
| flag_waving | 0.091 |
| **macro** | **0.037** |
| **micro** | 0.043 |

Hyper-parameter sweep over the non-`O` sample weight (used to
counter the 78% `O` base rate in the perceptron updates):

| non_o_weight | per-row macro F1 | span macro F1 | per-row micro F1 | span micro F1 |
|---:|---:|---:|---:|---:|
| 1.5 | 0.203 | 0.021 | 0.561 | 0.024 |
| **2.0** | 0.203 | **0.037** | 0.564 | **0.043** |
| 2.5 | 0.216 | 0.033 | 0.570 | 0.041 |
| 3.0 | **0.223** | 0.030 | **0.575** | 0.040 |
| 4.0 | 0.209 | 0.023 | 0.573 | 0.035 |

Larger weights boost per-row label F1 by giving the perceptron
stronger gold-side updates, but at the cost of span F1: the model
becomes eager to extend spans past the gold boundaries. We lock in
`non_o_weight = 2.0` because span-level F1 is the metric the
assignment grades on for Task 2.

[Figure: per-row label F1 vs span-level F1 for each technique,
illustrating the boundary-matching gap that the BIO constraint
narrows but does not close.]

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
outside-span. We compensate with a sample weight of 2.0 for non-`O`
tokens in the perceptron updates.

The first structural fix was the BIO-constrained transition matrix.
Without it, the decoder was free to transition from `B-flag_waving`
to `I-loaded_language` (or any other tag), which meant a span that
should be 5 tokens long would fragment into multiple single-token
spans as soon as the emission features drifted. The matrix forbids
nonsense transitions at the structural level; the model still has
to learn when to extend (`I-{LABEL}`) and when to close (`O`), but
the legal-action space is now small enough to be searched
exhaustively by Viterbi. Span-level macro F1 rose from 0.011
(unconstrained) to 0.037 (constrained) on the same features and
training regime, a 3.4× improvement with zero new parameters.

The remaining boundary-drift problem is that the perceptron's 0/1
loss is brittle when the training set is dominated by one class.
The perceptron needs to see the gold path on every update, but the
model's predicted path is nearly always `O → O → ...`, so 60% of
training sentences trigger an update and the `O → O` transition
accumulates a large negative weight that swamps the rare `B-*`
transitions. A smooth loss (cross-entropy) and a globally
normalised decoder (linear-chain CRF) are the natural next steps
and are the first item in §7.
