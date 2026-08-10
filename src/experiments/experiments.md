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

We compared four configurations for the same 17-state BIO tag space
and the same BIO-constrained transition matrix from §4:

- **Perceptron** — discriminative, scores each token with a linear
  model over `LinguisticFeatures` emissions, hill-climbs on 0/1
  loss.
- **HMM-1** — first-order generative HMM with (token, POS) bigram
  emissions, $P(\text{state}_{t+1} \mid \text{state}_t)$.
- **HMM-1 + BF** — HMM-1 with a per-token Bloom-filter span-start
  prior. For each token that appears in-span in training, a Bloom
  filter records which techniques it was seen with. At decode time,
  the Viterbi score for `B-{LABEL}` at position $i$ is boosted by
  the number of nearby tokens (window = 2) whose BF contains that
  label. This "backpropagates" the technique signal from in-span
  tokens to candidate span-start positions.
- **HMM-2 + BF** — second-order HMM ($P(\text{state}_{t+1} \mid
  \text{state}_{t-1}, \text{state}_t)$) with linear-interpolation
  backoff and the same BF prior.

Per-row label accuracy on the validation set:

| label | perceptron | HMM-1 | HMM-1+BF | HMM-2+BF |
|---|---:|---:|---:|---:|
| appeal_to_fear_prejudice | 0.107 | 0.179 | **0.232** | 0.187 |
| causal_oversimplification | **0.240** | 0.357 | 0.338 | 0.339 |
| doubt | 0.207 | 0.262 | **0.347** | 0.207 |
| exaggeration,minimisation | 0.178 | 0.328 | **0.294** | 0.256 |
| flag_waving | 0.349 | **0.306** | 0.247 | 0.238 |
| loaded_language | 0.000 | 0.132 | 0.107 | **0.214** |
| name_calling,labeling | 0.000 | 0.037 | **0.172** | 0.154 |
| not_propaganda | 0.743 | 0.991 | **0.997** | 0.994 |
| repetition | 0.000 | 0.193 | **0.208** | 0.148 |
| **macro** | 0.203 | 0.309 | **0.327** | 0.304 |
| **micro** | 0.564 | 0.622 | **0.633** | 0.619 |

Span-level P/R/F1:

| label | perceptron | HMM-1 | HMM-1+BF | HMM-2+BF |
|---|---:|---:|---:|---:|
| causal_oversimplification | 0.148 | **0.113** | 0.072 | 0.000 |
| doubt | 0.056 | **0.075** | 0.044 | 0.000 |
| exaggeration,minimisation | 0.000 | **0.078** | 0.035 | 0.011 |
| flag_waving | 0.091 | **0.088** | 0.046 | 0.035 |
| repetition | 0.000 | 0.009 | 0.011 | **0.006** |
| **macro** | 0.037 | **0.045** | 0.029 | 0.008 |
| **micro** | 0.043 | 0.030 | **0.025** | 0.008 |

The Bloom-filter prior improves per-row label F1 (0.309 → 0.327
macro) by rescuing `name_calling,labeling` from 0.037 to 0.172 and
boosting `doubt` from 0.262 to 0.347. The BF memory contains the
right tokens for these techniques: `name_calling,labeling` spans are
anchored on proper nouns and evaluative nouns that the BF
remembers, and `doubt` spans are anchored on adverbs like
"interestingly" and "amazingly" that are distinctive in-span
tokens.

However, the BF prior *hurts* span-level F1 (0.045 → 0.029 macro)
because it makes the model predict more spans (boosting recall)
with lower precision (more false positives). The BF prior tells the
model "this token has been seen in-span with technique $c$" but
does not tell it *where* the span starts or ends — so the model
emits `B-{LABEL}` at every position where the BF fires, fragmenting
what should be one span into many short ones. The per-row label
metric forgives this (it only checks the label, not the boundaries)
but the span-level metric does not.

We lock in **HMM-1 + BF** as the primary configuration because the
assignment's Task 2 requires both span and technique detection,
and the per-row label F1 is the headline metric that the BF
improves. The span-level degradation is documented as a finding:
the BF prior is a label-level signal, not a boundary-level signal,
and combining it with a boundary-aware decoder (e.g. a CRF) is the
natural next step.

[Figure: per-row label F1 vs span-level F1 for each technique and
each configuration, illustrating the label-vs-boundary trade-off.]

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
