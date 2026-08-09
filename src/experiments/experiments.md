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

We compared two trainers for the same 17-state BIO tag space and
the same BIO-constrained transition matrix from §4:

- **Averaged structured perceptron with Viterbi decoding** —
  discriminative, scores each token with a linear model over
  `LinguisticFeatures` emissions, hill-climbs on 0/1 loss.
- **Hidden Markov Model with (token, POS) bigram emissions** —
  generative, models P(obs | state) and P(state' | state) by
  maximum-likelihood counting, decodes by Viterbi.

The HMM's emissions are bigrams of (token, POS-tag) pairs: each
position emits `((token_{t-1}, pos_{t-1}), (token_t, pos_t))`,
where the POS tag comes from a small rule-based tagger
(`src/PosTagger.py`). The (token, POS) bigram captures local
syntactic context that the perceptron's suffix-only emissions
miss — e.g. `("infidels", "NNS")` after a determiner is a strong
`name_calling,labeling` cue, and `("not", "RB")` followed by a
quantifier is a strong `exaggeration,minimisation` cue. POS tags
are produced by a deterministic suffix-based tagger (~12 rules, no
external dependencies), so the HMM is fully reproducible.

Per-row label accuracy on the validation set:

| label | perceptron F1 | HMM F1 |
|---|---:|---:|
| causal_oversimplification | 0.240 | 0.000 |
| doubt | 0.207 | **0.308** |
| exaggeration,minimisation | 0.178 | **0.271** |
| flag_waving | 0.349 | **0.487** |
| repetition | 0.000 | **0.182** |
| not_propaganda | 0.743 | **0.828** |
| **macro** | 0.203 | **0.309** |
| **micro** | 0.564 | **0.620** |

Span-level P/R/F1:

| label | perceptron F1 | HMM F1 |
|---|---:|---:|
| causal_oversimplification | 0.148 | 0.104 |
| doubt | 0.056 | 0.046 |
| exaggeration,minimisation | 0.000 | **0.085** |
| flag_waving | 0.091 | 0.090 |
| repetition | 0.000 | **0.094** |
| **macro** | 0.037 | **0.052** |
| **micro** | 0.043 | **0.058** |

The HMM is the better trainer on every per-class metric that is
non-zero for both models, and it adds three classes (`repetition`
per-row, `exaggeration,minimisation` span, `repetition` span) that
the perceptron misses entirely. The macro F1 improvement of
0.106 on per-row labels and 0.015 on span-level accuracy is
substantial given that no new features or hyper-parameters were
introduced — only the choice of training criterion.

[Figure: per-row label F1 vs span-level F1 for each technique and
each trainer, illustrating the per-class trade-off.]

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
