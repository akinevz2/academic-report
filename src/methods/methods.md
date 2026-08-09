# Methods

## Task 1: Technique Classification

### Bag-of-Words Linear Classifier

We tokenise the snippet plus a window of context, compute TF-IDF
weights with sublinear term frequency, and train a multinomial logistic
regression with L2 regularisation. The feature space is unigrams and
bigrams. The model is one of two configurations we compare.

We ablate over the following hyper-parameters: token case sensitivity,
n-gram range, minimum document frequency, regularisation strength $C$,
and class-weighting scheme (uniform vs. inverse frequency).

### Alternative Linear Configuration

The second configuration replaces the loss with a linear SVM and uses
character n-grams in place of word n-grams. This is treated as a
variation on the same approach for evaluation, not as a separate
paradigm.

## Task 2: Span and Technique Detection

### Finite-State Tagger

We model span detection as a regular language over a per-token feature
vector. The state machine has four states: `OUTSIDE`, `ENTERING`,
`INSIDE`, and `LEAVING`. Transitions are scored by a linear model over
the feature vector at the current and previous token. The Viterbi
algorithm selects the highest-scoring path; the predicted span is the
maximal run of `INSIDE` states, and the predicted label is read from
the features at the entry transition.

Features per token include: word identity, suffix of length 2 and 3,
whether the token appears in the `vocabulary` Bloom filter, a one-hot
of the previous predicted state, and the distance to the nearest
punctuation mark.

### Alternative State Machine

The second configuration augments the state machine with a label state,
so transitions are conditioned on both position and technique. This
lets the model learn that *flag waving* spans tend to be longer than
*repetition* spans, for example. The transition function is otherwise
identical.

## Bloom Filters in the Pipeline

The `labelCollection` filter is consulted before evaluation to flag
predictions outside the training label set. The `vocabulary` filter
gates the feature extraction: tokens absent from the filter are
replaced with an `<UNK>` symbol, which is itself a feature. The
filters are also used at test time to log per-class exposure during
error analysis.
