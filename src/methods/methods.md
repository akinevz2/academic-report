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

### Linguistic Feature Set

The tagger consumes per-token feature vectors produced by
`LinguisticFeatures` (see `src/LinguisticFeatures.py`). Features
are drawn from five linguistic categories and are designed to be
sparse and interpretable so that the linear transition scorer can
read them directly.

- **Shape and morphology.** The lowercased suffixes of length 2, 3,
  and 4; the prefixes of length 2 and 3; booleans for the presence
  of digits, hyphens, apostrophes, and mixed casing. Suffixes
  capture the morphology that propaganda techniques tend to anchor
  on: `-ed` and `-ing` for *loaded language* verbs, `-ist` and
  `-ism` for *name calling, labeling*, `-ive` and `-tion` for
  *causal oversimplification*.
- **Capitalisation.** `is_upper`, `is_title`, `is_lower`,
  `is_mixed_case`, `is_sentence_initial`, `prev_is_period`, and
  `prev_is_quote`. Title-cased tokens that are not in the
  vocabulary are flagged as candidate proper nouns, which is a
  strong cue for *flag waving* and *name calling, labeling*.
- **Punctuation context.** `followed_by_comma`,
  `followed_by_period`, `followed_by_quote`,
  `followed_by_semicolon`, and `is_inside_parens`. Propaganda
  spans frequently sit before commas or inside parentheticals, and
  the closing-quote position is a strong boundary signal for spans
  that name-call or label.
- **Quote context.** `is_inside_quotes` (an odd-count tally of
  open versus close quotes precedes the token) and
  `next_is_open_quote`. Many *name calling, labeling* spans are
  direct quotations: `<BOS> "spooks" <EOS>`.
- **Lexical membership and position.** `in_vocabulary_bf` and
  `is_unk` (gated by the `vocabulary` Bloom filter), plus
  `rel_position`, `is_first`, `is_last`, and (at training time)
  `is_at_bos` and `is_at_eos` from the gold span markers.

### Finite-State Tagger

We model span detection as a regular language over the per-token
feature vector. The state machine has four states: `OUTSIDE`,
`ENTERING`, `INSIDE`, and `LEAVING`. Transitions are scored by a
linear model over the feature vector at the current and previous
token. The Viterbi algorithm selects the highest-scoring path; the
predicted span is the maximal run of `INSIDE` states, and the
predicted label is read from the features at the entry transition.

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
